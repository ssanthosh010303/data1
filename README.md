# Data Training Day-1: SQL Triggers and Stored Procedures with SQL Server

- **Author:** Sakthi Santhosh
- **Created on:** 5th September, 2024

## Task: Synchronize Employee Data

1. Insert new employee records from `employee_src` to `employee_tgt` if they don't already exist.
2. Update employee names in `employee_tgt` from the latest data in `employee_src` if the record is not marked as deleted.
3. Mark employees as deleted in `employee_tgt` if they no longer exist in `employee_src` and are currently active.
4. Ensure changes are made efficiently by handling new inserts, updates, and deletions in a single procedure execution.

## Code

```sql
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
```
