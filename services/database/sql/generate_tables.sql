-- Step 1: Drop existing tables in the correct order

-- Drop tables with foreign key dependencies first
DROP TABLE CONTRIBUTES_TO_DOCUMENT;
DROP TABLE OWNS_DOCUMENT;
DROP TABLE CODE;
DROP TABLE IMAGE;
DROP TABLE SECTION;

-- Drop tables without dependencies
DROP TABLE DOCUMENT;
DROP TABLE DOCUMENT_USER;
DROP TABLE FOLDER;
DROP TABLE SECTION_TYPE;

-- Step 2: Recreate tables with new definitions

-- Create DOCUMENT_USER table
CREATE TABLE DOCUMENT_USER (
    UserID integer not null primary key,
    FName VARCHAR2(20) NOT NULL,
    LName VARCHAR2(20) NOT NULL,
    JoinDate timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    LastLoginDate timestamp,
    max_documents integer NOT NULL CHECK (max_documents > 0),
    max_document_size integer NOT NULL CHECK (max_document_size > 0),
    CONSTRAINT chk_name CHECK (LENGTH(TRIM(FName)) > 0 AND LENGTH(TRIM(LName)) > 0),
    CONSTRAINT chk_login_date CHECK (LastLoginDate IS NULL OR LastLoginDate >= JoinDate)
);

-- Create FOLDER table
CREATE TABLE FOLDER (
    id INTEGER NOT NULL PRIMARY KEY,
    parent_id INTEGER,
    name VARCHAR(15) NOT NULL,
    color VARCHAR(10),
    mpath VARCHAR(120),
    CONSTRAINT fk_parent_id FOREIGN KEY (parent_id) REFERENCES FOLDER(id),
    CONSTRAINT chk_mpath CHECK (
        REGEXP_LIKE(mpath, '^/$|^/([0-9]+(/([0-9]+))*)/$')
        OR mpath IS NULL
    ),
    CONSTRAINT chk_color CHECK (
        REGEXP_LIKE(color, '^#([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$')
        OR color IS NULL
    ),
    CONSTRAINT chk_name_not_empty CHECK (LENGTH(TRIM(name)) > 0)
);

-- Create DOCUMENT table
CREATE TABLE DOCUMENT (
    DocumentID integer not null primary key,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
    last_modified timestamp,
    folderID integer NOT NULL,
    number_of_images integer DEFAULT 0 NOT NULL CHECK (number_of_images >= 0),
    CONSTRAINT fk_folder FOREIGN KEY (folderID) REFERENCES FOLDER(id),
    CONSTRAINT chk_modified_date CHECK (last_modified IS NULL OR last_modified >= created_at)
);

-- Create OWNS_DOCUMENT table
CREATE TABLE OWNS_DOCUMENT (
    userID integer not null,
    DocumentID integer not null,
    PRIMARY KEY (UserID, DocumentID),
    FOREIGN KEY (UserID) REFERENCES DOCUMENT_USER(UserID),
    FOREIGN KEY (DocumentID) REFERENCES DOCUMENT(DocumentID)
);

-- Create CONTRIBUTES_TO_DOCUMENT table
CREATE TABLE CONTRIBUTES_TO_DOCUMENT (
    userID integer not null,
    documentID integer not null,
    contributionType varchar(20) NOT NULL,
    document_connection_status varchar(20) NOT NULL,
    PRIMARY KEY (userID, documentID),
    FOREIGN KEY (userID) REFERENCES DOCUMENT_USER(UserID),
    FOREIGN KEY (documentID) REFERENCES DOCUMENT(DocumentID),
    CONSTRAINT chk_contribution_type CHECK (contributionType IN ('editor', 'contributor', 'viewer')),
    CONSTRAINT chk_connection_status CHECK (document_connection_status IN ('ok', 'removed', 'changed_contributor_type'))
);

-- Create SECTION_TYPE table
CREATE TABLE SECTION_TYPE (
    section_type_id INTEGER NOT NULL PRIMARY KEY,
    name VARCHAR2(50) NOT NULL UNIQUE,
    description VARCHAR2(255),
    CONSTRAINT chk_section_type_name_not_empty CHECK (LENGTH(TRIM(name)) > 0)
);

-- Create SECTION table
CREATE TABLE SECTION (
    section_id INTEGER NOT NULL PRIMARY KEY,
    document_id INTEGER NOT NULL,
    section_type_id INTEGER NOT NULL,
    relative_index INTEGER NOT NULL CHECK (relative_index >= 0),
    relative_y_position INTEGER NOT NULL CHECK (relative_y_position >= 0),
    content VARCHAR2(4000),
    content_size INTEGER,
    FOREIGN KEY (document_id) REFERENCES DOCUMENT(DocumentID) ON DELETE CASCADE,
    FOREIGN KEY (section_type_id) REFERENCES SECTION_TYPE(section_type_id) ON DELETE CASCADE,
    CONSTRAINT chk_content_size CHECK (content_size = LENGTH(content))
);

-- Create CODE table
CREATE TABLE CODE (
    code_id INTEGER PRIMARY KEY,
    section_id INTEGER NOT NULL,
    language VARCHAR2(10) NOT NULL,
    code_text CLOB NOT NULL,
    url VARCHAR2(2048),
    FOREIGN KEY (section_id) REFERENCES SECTION(section_id) ON DELETE CASCADE,
    CONSTRAINT chk_language_not_empty CHECK (LENGTH(TRIM(language)) > 0),
    CONSTRAINT chk_code_text_not_empty CHECK (LENGTH(TRIM(code_text)) > 0)
);

-- Text table to store text sections
CREATE TABLE TEXT (
    text_id INTEGER PRIMARY KEY,
    title VARCHAR2(12),      -- Title, following APA 7th style
    level TINYINT,           -- Goes from 0 to 255
    data VARCHAR2(65534)     -- HTML textbox maximum
);

-- Create IMAGE table
CREATE TABLE IMAGE (
    image_id INTEGER NOT NULL PRIMARY KEY,
    section_id INTEGER NOT NULL,
    location_type VARCHAR2(10) NOT NULL CHECK (location_type IN ('raw', 'url')),
    extension VARCHAR2(5) CHECK (extension IN ('.png', '.jpg', '.jpeg', '.gif')),
    alt VARCHAR2(128),
    data BLOB,
    url VARCHAR2(255),
    FOREIGN KEY (section_id) REFERENCES SECTION(section_id) ON DELETE CASCADE,
    CONSTRAINT chk_image_data CHECK (
        (location_type = 'raw' AND data IS NOT NULL AND url IS NULL)
        OR (location_type = 'url' AND url IS NOT NULL AND data IS NULL)
    ),
    CONSTRAINT chk_extension_not_null CHECK (
        (location_type = 'raw' AND extension IS NOT NULL)
        OR location_type = 'url'
    )
);

-- Step 3: Create triggers

-- Trigger to update content_size in SECTION
CREATE OR REPLACE TRIGGER trg_update_content_size
BEFORE INSERT OR UPDATE ON SECTION
FOR EACH ROW
BEGIN
    :NEW.content_size := LENGTH(:NEW.content);
END;
/

-- Trigger to check total size of all sections in a document
CREATE OR REPLACE TRIGGER trg_check_document_size
BEFORE INSERT OR UPDATE ON SECTION
FOR EACH ROW
DECLARE
    v_total_size INTEGER;
    v_max_size INTEGER;
BEGIN
    -- Get the maximum allowed size for the user who owns the document
    SELECT du.max_document_size
    INTO v_max_size
    FROM DOCUMENT_USER du
    JOIN OWNS_DOCUMENT od ON du.UserID = od.UserID
    WHERE od.DocumentID = :NEW.document_id;

    -- Sum the size of all sections in the document, including the new/updated section
    SELECT NVL(SUM(content_size), 0) + NVL(:NEW.content_size, 0)
    INTO v_total_size
    FROM SECTION
    WHERE document_id = :NEW.document_id
    AND section_id != :NEW.section_id;

    -- If the total size exceeds the allowed max size, raise an error
    IF v_total_size > v_max_size THEN
        RAISE_APPLICATION_ERROR(-20001, 'Total size of document sections exceeds the allowed max_document_size.');
    END IF;
END;
/