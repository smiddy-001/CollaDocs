
-- Create triggers (Note: These may require additional permissions)
CREATE OR REPLACE TRIGGER trg_update_content_size
BEFORE INSERT OR UPDATE ON SECTION
FOR EACH ROW
BEGIN
    :NEW.content_size := LENGTH(:NEW.section_content);
END;
/

CREATE OR REPLACE TRIGGER trg_check_document_size
BEFORE INSERT OR UPDATE ON SECTION
FOR EACH ROW
DECLARE
    v_total_size INTEGER;
    v_max_size INTEGER;
BEGIN
    SELECT du.max_document_size
    INTO v_max_size
    FROM DOCUMENT_USER du
    JOIN OWNS_DOCUMENT od ON du.UserID = od.UserID
    WHERE od.DocumentID = :NEW.document_id;

    SELECT NVL(SUM(content_size), 0) + NVL(:NEW.content_size, 0)
    INTO v_total_size
    FROM SECTION
    WHERE document_id = :NEW.document_id
    AND section_id != :NEW.section_id;

    IF v_total_size > v_max_size THEN
        RAISE_APPLICATION_ERROR(-20001, 'Total size of document sections exceeds the allowed max_document_size.');
    END IF;
END;
/