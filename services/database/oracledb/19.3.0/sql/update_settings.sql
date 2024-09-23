CREATE OR REPLACE PROCEDURE add_setting_column (
    p_column_name IN VARCHAR2,
    p_default_value IN VARCHAR2
) AS
BEGIN
    -- Alter the table to add the new column
    EXECUTE IMMEDIATE 'ALTER TABLE SETTINGS ADD ' || p_column_name || ' VARCHAR2(100) DEFAULT ''' || p_default_value || '''';

    -- Optionally, set default values for existing rows
    EXECUTE IMMEDIATE 'UPDATE SETTINGS SET ' || p_column_name || ' = ''' || p_default_value || ''' WHERE ' || p_column_name || ' IS NULL';
END;

-- example of how to use the above procedure to add a new setting
-- and its default value
-- --------------------------------------------------------------
--
-- BEGIN
--     add_setting_column('newColumnName', 'defaultValue');
-- END;
