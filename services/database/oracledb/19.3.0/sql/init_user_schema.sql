CREATE TABLE USER (
    userId NUMBER PRIMARY KEY,
    username VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) NOT NULL UNIQUE,
    password VARCHAR2(100) NOT NULL,
    joinDate DATE DEFAULT SYSDATE,
    lastLoginDate DATE,
    userSettings NUMBER,
    CONSTRAINT fk_userSettings FOREIGN KEY (userSettings) REFERENCES SETTINGS(settingsId)
);

CREATE INDEX idx_username ON USER (username);
CREATE INDEX idx_email ON USER (email);