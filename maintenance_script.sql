-- ======================================
-- Archiving Old Data
-- Moves and archives records older than a specified timeframe
-- ======================================
-- How to use:
-- Replace 'YourTableName' with the name of your table.
-- Replace 'ArchiveTableName' with the archive table name.
-- Specify the timeframe in the WHERE clause.
-- Why to use:
-- Prevents performance degradation by reducing the size of active tables.

INSERT INTO ArchiveTableName
SELECT *
FROM YourTableName
WHERE YourDateColumn < DATEADD(YEAR, -1, GETDATE());

DELETE FROM YourTableName
WHERE YourDateColumn < DATEADD(YEAR, -1, GETDATE());

-- ======================================
-- Index Reorganization
-- Reorganizes indexes to optimize their performance
-- ======================================
-- How to use:
-- Execute for tables with fragmented indexes to improve query performance.
-- Why to use:
-- Reduces fragmentation and optimizes index storage.

DECLARE @TableName NVARCHAR(255);
DECLARE cur CURSOR FOR
SELECT name FROM sys.tables;

OPEN cur;
FETCH NEXT FROM cur INTO @TableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC ('ALTER INDEX ALL ON ' + @TableName + ' REORGANIZE;');
    FETCH NEXT FROM cur INTO @TableName;
END;

CLOSE cur;
DEALLOCATE cur;

-- ======================================
-- Statistics Update
-- Updates table statistics to ensure the query optimizer is informed
-- ======================================
-- How to use:
-- Run for tables where query performance is degrading.
-- Why to use:
-- Keeps query plans efficient by updating outdated statistics.

EXEC sp_MSforeachtable 'UPDATE STATISTICS ?';

-- ======================================
-- Database Shrinking
-- Shrinks database files to free up unused space
-- ======================================
-- How to use:
-- Specify the database and file names. Use cautiously to avoid fragmentation.
-- Why to use:
-- Reclaims unused space to improve storage utilization.

DBCC SHRINKDATABASE (YourDatabaseName);
DBCC SHRINKFILE (YourDatabaseFileName, TargetSizeInMB);

-- ======================================
-- Transaction Log Management
-- Backs up and truncates the transaction log to manage its size
-- ======================================
-- How to use:
-- Specify the backup path. Run periodically to prevent log file growth.
-- Why to use:
-- Prevents the transaction log from consuming excessive disk space.

BACKUP LOG YourDatabaseName
TO DISK = 'C:\Backup\YourDatabaseName_Log.trn';

DBCC SHRINKFILE (YourLogFileName, TargetSizeInMB);

-- ======================================
-- Integrity Checks
-- Ensures the integrity of all tables in the database
-- ======================================
-- How to use:
-- Run periodically or after unexpected server shutdowns.
-- Why to use:
-- Detects and resolves corruption issues in the database.

DBCC CHECKDB (YourDatabaseName);

-- ======================================
-- Logging
-- Logs maintenance activities including timestamps and types
-- ======================================
-- How to use:
-- Replace 'MaintenanceLogTable' with the name of the log table.
-- Why to use:
-- Keeps a record of maintenance tasks for auditing and troubleshooting.

CREATE TABLE MaintenanceLogTable (
    ActivityType NVARCHAR(50),
    ActivityTimestamp DATETIME
);

INSERT INTO MaintenanceLogTable (ActivityType, ActivityTimestamp)
VALUES ('Archive Old Data', GETDATE());

INSERT INTO MaintenanceLogTable (ActivityType, ActivityTimestamp)
VALUES ('Index Reorganization', GETDATE());

INSERT INTO MaintenanceLogTable (ActivityType, ActivityTimestamp)
VALUES ('Statistics Update', GETDATE());

INSERT INTO MaintenanceLogTable (ActivityType, ActivityTimestamp)
VALUES ('Database Shrink', GETDATE());

INSERT INTO MaintenanceLogTable (ActivityType, ActivityTimestamp)
VALUES ('Transaction Log Backup', GETDATE());

INSERT INTO MaintenanceLogTable (ActivityType, ActivityTimestamp)
VALUES ('Integrity Check', GETDATE());

