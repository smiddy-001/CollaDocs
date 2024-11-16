-- for generating the tables and doing some minor checks. 
-- Probably still needs some work but all tables are accounted for.


CREATE TABLE "DOCUMENT_USER" (
    "user_id" integer PRIMARY KEY,
    "Fname" varchar(20),
    "Lname" varchar(20),
    "join_date" timestamp,
    "last_login_date" timestamp
);

CREATE TABLE "DOCUMENT" (
    "document_id" integer PRIMARY KEY,
    "created_at" timestamp,
    "last_modified" timestamp,
    "folder" integer,
    "total_images" integer,
    "total_tables" integer,
    "total_code_blocks" integer
);

CREATE TABLE "OWNS_DOCUMENT" (
    "userid" DOCUMENT_USER.user_id,
    "DocumentId" DOCUMENT.document_id
);

CREATE TABLE "CONTRIBUTES_TO" (
    "user_id" integer,
    "document_id" integer,
    "contribution_type" varchar(20),
    "permission_status" nvarchar2(255) NOT NULL CHECK ("permission_status" IN ('ok', 'changed', 'removed'))
);

CREATE TABLE "FOLDER" (
    "folder_id" integer,
    "folder_name" varchar(15),
    "folder_color" number
);

CREATE TABLE "SECTION" (
    "section_id" integer,
    "document_id" integer,
    "relative_index" integer,
    "relative_y_position" integer,
    "section_title" varchar(30)
);

CREATE TABLE "TEXT" (
    "text_id" integer,
    "text_type" nvarchar2(255) NOT NULL CHECK ("text_type" IN ('h1', 'h2', 'h3', 'normal', 'code', 'bold', 'italic', 'underline', 'strikethrough', 'bold_italic', 'bold_strikethrough', 'bold_italic_strikethrough', 'italic_strikethrough', 'italic_h1', 'italic_h2', 'italic_h3', 'underline_strikethrough', 'underline_bold_italic', 'underline_bold_strikethrough', 'underline_bold_italic_strikethrough', 'underline_italic_strikethrough', 'underline_italic_h1', 'underline_italic_h2', 'underline_italic_h3')),
    "data" varchar(524288)
);

CREATE TABLE "CODE" (
    "code_id" integer PRIMARY KEY,
    "code_type" nvarchar2(255) NOT NULL CHECK ("code_type" IN ('plain', 'gh_gist', 'gl_snippet')),
    "section" section_id,
    "description" varchar(255),
    "url" varchar(2048),
    "language" nvarchar2(255) NOT NULL CHECK ("language" IN ('python', 'c', 'cpp', 'ruat', 'go', 'json', 'java', 'js', 'ts', 'html', 'css', 'c#', 'md'))
);

CREATE TABLE "VIDEO" (
    "video_id" integer PRIMARY KEY
);

CREATE TABLE "TABLE" (
    "table_id" integer PRIMARY KEY,
    "table_headers" integer,
    "table_rows" integer,
    "table_cols" integer,
    "table_row_count" integer,
    "table_col_count" integer
);

CREATE TABLE "ROW" (
    "table_id" integer,
    "row_number" integer,
    PRIMARY KEY ("table_id", "row_number")
);

CREATE TABLE "COL" (
    "table_id" integer,
    "col_number" integer,
    PRIMARY KEY ("table_id", "col_number")
);

CREATE TABLE "TABLE_HEADER" (
    "table_id" integer,
    "row_number" integer,
    "title" varchar(50),
    "column_color" integer,
    PRIMARY KEY ("table_id", "row_number")
);

CREATE TABLE "COLOR" (
    "color_id" integer PRIMARY KEY,
    "red" integer,
    "green" integer,
    "blue" integer
);

CREATE TABLE "CELL" (
    "col_number" integer,
    "row_numebr" integer,
    "data" blob,
    "dataType" nvarchar2(255) NOT NULL CHECK ("dataType" IN ('text', 'date', 'integer', 'float')),
    PRIMARY KEY ("col_number", "row_numebr")
);

CREATE TABLE "IMAGE" (
    "image_id" integer PRIMARY KEY,
    "figure_number" integer,
    "alt" varchar(255)
);

CREATE TABLE "URL_IMAGE" (
    "image_id" integer,
    "url" varchar(2048)
);

CREATE TABLE "YOUTUBE_VIDEO" (
    "video_id" integer,
    "url" varchar(2048),
    "autoplay" boolean
);
