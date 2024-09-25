CREATE TABLE SETTINGS (
    settingsId NUMBER PRIMARY KEY,
    permissions VARCHAR2(100) DEFAULT 'READ_ONLY',
    userColorScheme VARCHAR2(50) DEFAULT 'LIGHT'
    -- Add additional columns with default values as needed 
);
