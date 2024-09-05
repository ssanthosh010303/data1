-- Author: Sakthi Santhosh
-- Created on: 05/09/2024
CREATE TABLE employee_src (
    employee_id INT PRIMARY KEY,
    name NVARCHAR(100),
    is_deleted BIT
);

CREATE TABLE employee_tgt (
    employee_id INT PRIMARY KEY,
    name NVARCHAR(100),
    is_deleted BIT
);

MERGE INTO employee_tgt AS tgt
USING employee_src AS src
ON tgt.employee_id = src.employee_id
WHEN MATCHED AND tgt.name <> src.name AND tgt.is_deleted = 0
    THEN UPDATE SET tgt.name = src.name
WHEN NOT MATCHED BY TARGET
    THEN INSERT (employee_id, name, is_deleted) VALUES (src.employee_id, src.name, 0)
WHEN NOT MATCHED BY SOURCE AND tgt.is_deleted = 0
    THEN UPDATE SET tgt.is_deleted = 1;
