
-- Insert initial values
INSERT INTO FOLDER VALUES(1, NULL, '/', NULL, '/');
INSERT INTO FOLDER VALUES(2, 1, 'home', NULL, '/1/');
INSERT INTO FOLDER VALUES(3, 2, 'aspiring-master', NULL, '/1/2/');
INSERT INTO FOLDER VALUES(4, 3, '.bashrc', NULL, '/1/2/3/');
INSERT INTO FOLDER VALUES(5, 2, 'guest-user', NULL, '/1/2/');
INSERT INTO FOLDER VALUES(6, 1, 'var', NULL, '/1/');
INSERT INTO FOLDER VALUES(7, 6, 'log', NULL, '/1/6/');
INSERT INTO CODE (code_id, code_type_id, section_id, language, code_text)
VALUES (2, 1, 11, 'cpp', 'int main() { return 0; }');
INSERT INTO CODE (code_id, code_type_id, section_id, language, code_text)
VALUES (3, 1, 12, 'python', 'print("Hello, World!")');
INSERT INTO CODE (code_id, code_type_id, section_id, language, code_text)
VALUES (4, 1, 13, 'js', 'console.log("Hello, JavaScript!");');
INSERT INTO SECTION_TYPE (section_type_id, name, description) VALUES (1, 'text', 'Text section');
INSERT INTO SECTION_TYPE (section_type_id, name, description) VALUES (2, 'code', 'Code section');
INSERT INTO SECTION_TYPE (section_type_id, name, description) VALUES (3, 'image', 'Image section');
