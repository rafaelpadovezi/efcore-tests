dbug: 12/02/2021 08:40:15.779 RelationalEventId.TransactionStarting[20209] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Beginning transaction with isolation level 'Unspecified'.
dbug: 12/02/2021 08:40:15.790 RelationalEventId.TransactionStarted[20200] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Began transaction with isolation level 'ReadCommitted'.
dbug: 12/02/2021 08:40:15.794 CoreEventId.SaveChangesStarting[10004] (Microsoft.EntityFrameworkCore.Update) 
      SaveChanges starting for 'TestContext'.

dbug: 12/02/2021 08:40:15.835 RelationalEventId.CreatingTransactionSavepoint[20212] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Creating transaction savepoint.
dbug: 12/02/2021 08:40:15.841 RelationalEventId.CreatedTransactionSavepoint[20213] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Created transaction savepoint.

dbug: 12/02/2021 08:40:15.891 RelationalEventId.CommandExecuting[20100] (Microsoft.EntityFrameworkCore.Database.Command) 
      Executing DbCommand [Parameters=[@p0='?' (Size = 4000)], CommandType='Text', CommandTimeout='30']
      SET NOCOUNT ON;
      INSERT INTO [Employees] ([Name])
      VALUES (@p0);
      SELECT [Id]
      FROM [Employees]
      WHERE @@ROWCOUNT = 1 AND [Id] = scope_identity();

dbug: 12/02/2021 08:40:15.942 RelationalEventId.CommandExecuting[20100] (Microsoft.EntityFrameworkCore.Database.Command) 
      Executing DbCommand [Parameters=[@p1='?' (DbType = Int32), @p2='?' (DbType = Time), @p3='?' (DbType = Time)], CommandType='Text', CommandTimeout='30']
      SET NOCOUNT ON;
      INSERT INTO [TimeEntries] ([EmployeeId], [End], [Start])
      VALUES (@p1, @p2, @p3);
      SELECT [Id]
      FROM [TimeEntries]
      WHERE @@ROWCOUNT = 1 AND [Id] = scope_identity();

dbug: 12/02/2021 08:40:15.967 CoreEventId.SaveChangesCompleted[10005] (Microsoft.EntityFrameworkCore.Update) 
      SaveChanges completed for 'TestContext' with 2 entities written to the database.
dbug: 12/02/2021 08:40:15.970 RelationalEventId.TransactionCommitting[20210] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Committing transaction.
dbug: 12/02/2021 08:40:15.980 RelationalEventId.TransactionCommitted[20202] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Committed transaction.
dbug: 12/02/2021 08:40:15.983 RelationalEventId.ConnectionClosing[20002] (Microsoft.EntityFrameworkCore.Database.Connection) 
      Closing connection to database 'Timesheet' on server 'localhost,1433'.
dbug: 12/02/2021 08:40:15.985 RelationalEventId.ConnectionClosed[20003] (Microsoft.EntityFrameworkCore.Database.Connection) 
      Closed connection to database 'Timesheet' on server 'localhost,1433'.
dbug: 12/02/2021 08:40:15.988 RelationalEventId.TransactionDisposed[20204] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Disposing transaction.
