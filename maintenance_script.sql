-- Complex Database Maintenance Script

-- 1. Archive Old Data
-- Move records older than one year from the 'transactions' table to an archive table
INSERT INTO transactions_archive
SELECT *
FROM transactions
WHERE transaction_date < DATEADD(YEAR, -1, GETDATE());

-- Delete archived records from the 'transactions' table
DELETE FROM transactions
WHERE transaction_date < DATEADD(YEAR, -1, GETDATE());

-- 2. Reorganize Indexes
-- Reorganize indexes on the 'customers' table
ALTER INDEX ALL ON customers REORGANIZE;

-- Reorganize indexes on the 'orders' table
ALTER INDEX ALL ON orders REORGANIZE;

-- 3. Update Statistics
-- Update statistics for the 'products' table with a full scan
UPDATE STATISTICS products WITH FULLSCAN;

-- Update statistics for the 'employees' table using a sample
UPDATE STATISTICS employees WITH SAMPLE 50 PERCENT;

-- 4. Shrink Database
-- Shrink the database files to free up unused space
DBCC SHRINKDATABASE (YourDatabaseName);

-- 5. Log Maintenance
-- Backup and truncate the transaction log
BACKUP LOG YourDatabaseName TO DISK = 'C:\Backup\YourDatabaseName_LogBackup.bak';
DBCC SHRINKFILE (YourDatabaseName_Log, 1);

-- 6. Check Integrity
-- Check integrity of all tables in the database
DBCC CHECKDB (YourDatabaseName) WITH NO_INFOMSGS;

-- 7. Update Last Maintenance Date
-- Update the last maintenance date in the maintenance_info table
UPDATE maintenance_info
SET last_maintenance_date = GETDATE();

-- 8. Log Maintenance Completion
-- Insert a record into the maintenance_log table indicating the completion of maintenance
INSERT INTO maintenance_log (maintenance_type, completion_date)
VALUES ('Complex Maintenance Script', GETDATE());
