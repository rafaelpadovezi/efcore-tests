dbug: 12/02/2021 08:29:45.665 CoreEventId.SaveChangesStarting[10004] (Microsoft.EntityFrameworkCore.Update) 
      SaveChanges starting for 'TestContext'.
dbug: 12/02/2021 08:29:45.669 CoreEventId.DetectChangesStarting[10800] (Microsoft.EntityFrameworkCore.ChangeTracking) 
      DetectChanges starting for 'TestContext'.
dbug: 12/02/2021 08:29:45.680 CoreEventId.DetectChangesCompleted[10801] (Microsoft.EntityFrameworkCore.ChangeTracking) 
      DetectChanges completed for 'TestContext'.

dbug: 12/02/2021 08:29:45.694 RelationalEventId.TransactionStarting[20209] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Beginning transaction with isolation level 'Unspecified'.
dbug: 12/02/2021 08:29:45.698 RelationalEventId.TransactionStarted[20200] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Began transaction with isolation level 'ReadCommitted'.

dbug: 12/02/2021 08:29:45.747 RelationalEventId.CommandExecuting[20100] (Microsoft.EntityFrameworkCore.Database.Command) 
      Executing DbCommand [Parameters=[@p0='?' (Size = 4000)], CommandType='Text', CommandTimeout='30']
      SET NOCOUNT ON;
      INSERT INTO [Employees] ([Name])
      VALUES (@p0);
      SELECT [Id]
      FROM [Employees]
      WHERE @@ROWCOUNT = 1 AND [Id] = scope_identity();

dbug: 12/02/2021 08:29:45.818 RelationalEventId.CommandExecuting[20100] (Microsoft.EntityFrameworkCore.Database.Command) 
      Executing DbCommand [Parameters=[@p1='?' (DbType = Int32), @p2='?' (DbType = Time), @p3='?' (DbType = Time)], CommandType='Text', CommandTimeout='30']
      SET NOCOUNT ON;
      INSERT INTO [TimeEntries] ([EmployeeId], [End], [Start])
      VALUES (@p1, @p2, @p3);
      SELECT [Id]
      FROM [TimeEntries]
      WHERE @@ROWCOUNT = 1 AND [Id] = scope_identity();

dbug: 12/02/2021 08:29:45.830 RelationalEventId.TransactionCommitting[20210] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Committing transaction.
dbug: 12/02/2021 08:29:45.835 RelationalEventId.TransactionCommitted[20202] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Committed transaction.
dbug: 12/02/2021 08:29:45.836 RelationalEventId.ConnectionClosing[20002] (Microsoft.EntityFrameworkCore.Database.Connection) 
      Closing connection to database 'Timesheet' on server 'localhost,1433'.
dbug: 12/02/2021 08:29:45.838 RelationalEventId.ConnectionClosed[20003] (Microsoft.EntityFrameworkCore.Database.Connection) 
      Closed connection to database 'Timesheet' on server 'localhost,1433'.
dbug: 12/02/2021 08:29:45.840 RelationalEventId.TransactionDisposed[20204] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Disposing transaction.
dbug: 12/02/2021 08:29:45.853 CoreEventId.SaveChangesCompleted[10005] (Microsoft.EntityFrameworkCore.Update) 
      SaveChanges completed for 'TestContext' with 2 entities written to the database.
