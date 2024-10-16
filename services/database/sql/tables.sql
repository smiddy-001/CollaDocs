DROP TABLE CONTRIBUTES_TO_DOCUMENT CASCADE CONSTRAINTS; 
DROP TABLE OWNS_DOCUMENT CASCADE CONSTRAINTS; 
DROP TABLE SECTION CASCADE CONSTRAINTS; 
DROP TABLE CODE CASCADE CONSTRAINTS; 
DROP TABLE IMAGE CASCADE CONSTRAINTS; 
DROP TABLE TEXT CASCADE CONSTRAINTS; 
DROP TABLE DOCUMENT CASCADE CONSTRAINTS; 
DROP TABLE FOLDER CASCADE CONSTRAINTS; 
DROP TABLE SECTION_TYPE CASCADE CONSTRAINTS; 
DROP TABLE DOCUMENT_USER CASCADE CONSTRAINTS;

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
    description VARCHAR2(255)
);

-- Create SECTION table
CREATE TABLE SECTION (
    section_id INTEGER NOT NULL PRIMARY KEY,
    document_id INTEGER NOT NULL,
    section_type_id INTEGER NOT NULL,
    relative_index INTEGER NOT NULL CHECK (relative_index >= 0),
    relative_y_position INTEGER NOT NULL CHECK (relative_y_position >= 0),
    content_size INTEGER,
    section_content INTEGER NOT NULL,
    content_type VARCHAR2(50) NOT NULL CHECK (content_type IN ('VIDEO', 'IMAGE', 'CODE', 'TEXT', 'FIGURE')),
    FOREIGN KEY (document_id) REFERENCES DOCUMENT(DocumentID) ON DELETE CASCADE,
    FOREIGN KEY (section_type_id) REFERENCES SECTION_TYPE(section_type_id) ON DELETE CASCADE,
    CONSTRAINT chk_content_size CHECK (content_size < 2000000000)
);

-- Create CODE table
CREATE TABLE CODE (
    code_id INTEGER PRIMARY KEY,
    section_id INTEGER NOT NULL,
    language VARCHAR2(10) NOT NULL,
    code_text CLOB NOT NULL,
    url VARCHAR2(2048),
    FOREIGN KEY (section_id) REFERENCES SECTION(section_id) ON DELETE CASCADE
);

-- Create TEXT table
CREATE TABLE TEXT (
    text_id INTEGER PRIMARY KEY,
    style varchar(12) CHECK (style IN ('title', 'subtitle','author','date','abstract', 'quote', 'normal', 'h1', 'h2', 'h3')),
    data clob
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
