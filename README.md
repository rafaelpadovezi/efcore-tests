# Como funciona o comportamento transacional do SaveChanges do EF Core

O método `SaveChanges` é responsável por salvar todas as alterações no banco de dados quando se está trabalhando com o Entity Framework. Ao executar esse método, por padrão, estamos executando as operações dentro de uma transação. Segundo a [documentação](https://docs.microsoft.com/pt-br/ef/core/saving/transactions):

> Por padrão, se o provedor de banco de dados oferecer suporte a transações, todas as alterações em uma única chamada para SaveChanges serão aplicadas em uma transação. Se qualquer uma das alterações falhar, a transação é revertida e nenhuma das alterações será aplicada ao banco de dados. Isso significa que é garantido que o SaveChanges terá êxito ou sairá do banco de dados sem modificação caso ocorra algum erro.

Será tratado aqui o funcionamento do `SaveChanges` analisando os logs EF Core e as consultas geradas. O banco de dados escolhido para a análise é o Sql Server da Microsoft.

## Configurando o `DbContext`

Para obter as informações necessárias para o entendimento do EF Core o contexto do banco de dados deve ser configurado. 

```csharp
protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
{
    optionsBuilder
        .UseSqlServer(
            "Data Source=localhost,1433;Initial Catalog=Timesheet;User Id=sa;Password=Password1")
        .LogTo(message => Debug.WriteLine(message))
        .EnableSensitiveDataLogging();
}
```

O método `LogTo` usando na configuração é a nova maneira de acessar os logs do EF Core. A funcionalidade chamada de `Simple Logging` foi apresentada na versão 5 do ORM.

Por padrão os valores dos dados do EF Core não são apresentados nos logs para evitar o vazamento de informações confidenciais. No entanto, esse comportamento pode ser alterado usando o método `EnableSensitiveDataLogging`.

## Adicionando dados com o SaveChanges

Para verificar o funcionamento do `SaveChanges` um objeto aninhado é adicionado e salvo no banco.

``` csharp
var employee = new Employee
{
    Name = "John Doe",
    Entries = new List<TimeEntry>
    {
        new TimeEntry
        {
            Start = TimeSpan.FromHours(8),
            End = TimeSpan.FromHours(12)
        }
    }
};
context.Add(employee);

context.SaveChanges();
```

É possível ver no log gerado que os primeiros passos que o EF Core realiza é a verificação das mudanças das entidades do contexto. Logo em seguida a conexão com o banco de dados é aberta.
```
dbug: 10/02/2021 19:38:01.616 CoreEventId.SaveChangesStarting[10004] (Microsoft.EntityFrameworkCore.Update) 
      SaveChanges starting for 'TestContext'.
dbug: 10/02/2021 19:38:01.626 CoreEventId.DetectChangesStarting[10800] (Microsoft.EntityFrameworkCore.ChangeTracking) 
      DetectChanges starting for 'TestContext'.
dbug: 10/02/2021 19:38:01.654 CoreEventId.DetectChangesCompleted[10801] (Microsoft.EntityFrameworkCore.ChangeTracking) 
      DetectChanges completed for 'TestContext'.
dbug: 10/02/2021 19:38:01.681 RelationalEventId.ConnectionOpening[20000] (Microsoft.EntityFrameworkCore.Database.Connection) 
      Opening connection to database 'Timesheet' on server 'localhost,1433'.
dbug: 10/02/2021 19:38:01.685 RelationalEventId.ConnectionOpened[20001] (Microsoft.EntityFrameworkCore.Database.Connection) 
      Opened connection to database 'Timesheet' on server 'localhost,1433'.
```
As entradas de log seguintes são recionadas à transação. No primeiro momento a transação é iniciada com o level de isolamento não especificado. A próxima mensagem no entanto mostra que a transação foi inializada com o level "ReadCommitted".
```
dbug: 10/02/2021 19:38:01.693 RelationalEventId.TransactionStarting[20209] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Beginning transaction with isolation level 'Unspecified'.
dbug: 10/02/2021 19:38:01.718 RelationalEventId.TransactionStarted[20200] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Began transaction with isolation level 'ReadCommitted'.
```
Em seguida são executados os `INSERT`s. Alguns logs de criação dos comandos e detecção de alterações de chave estrangeira foram omitidos.

```sql
dbug: 10/02/2021 19:38:01.837 RelationalEventId.CommandExecuting[20100] (Microsoft.EntityFrameworkCore.Database.Command) 
      Executing DbCommand [Parameters=[@p0='John Doe' (Size = 4000)], CommandType='Text', CommandTimeout='30']
      SET NOCOUNT ON;
      INSERT INTO [Employees] ([Name])
      VALUES (@p0);
      SELECT [Id]
      FROM [Employees]
      WHERE @@ROWCOUNT = 1 AND [Id] = scope_identity();
dbug: 10/02/2021 19:38:01.958 RelationalEventId.CommandExecuting[20100] (Microsoft.EntityFrameworkCore.Database.Command) 
      Executing DbCommand [Parameters=[@p1='3' (Nullable = true), @p2='12:00:00', @p3='08:00:00'], CommandType='Text', CommandTimeout='30']
      SET NOCOUNT ON;
      INSERT INTO [TimeEntries] ([EmployeeId], [End], [Start])
      VALUES (@p1, @p2, @p3);
      SELECT [Id]
      FROM [TimeEntries]
      WHERE @@ROWCOUNT = 1 AND [Id] = scope_identity();
```

Por último, é possível verificar o `commit` da transação.
```
dbug: 10/02/2021 19:38:01.982 RelationalEventId.TransactionCommitting[20210] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Committing transaction.
dbug: 10/02/2021 19:38:02.026 RelationalEventId.TransactionCommitted[20202] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Committed transaction.
```

## Uso de transação explicita

Para a maioria dos casos, o uso do `SaveChanges` é o necessário para garantir a consistência dos dados. Porém, quando preciso, é possível controlar as transações manualmente.

Seguindo o mesmo exemplo anterior apenas adicionando a transação de forma manual.

```csharp
using var transaction = context.Database.BeginTransaction();

var employee = new Employee
{
    Name = "John Doe",
    Entries = new List<TimeEntry>
    {
        new TimeEntry
        {
            Start = TimeSpan.FromHours(8),
            End = TimeSpan.FromHours(12)
        }
    }
};
context.Add(employee);

context.SaveChanges();

transaction.Commit();
```

As primeiras entradas do log são de abertura de transação. Da mesma forma como o SaveChanges, a transação

```
dbug: 10/02/2021 19:44:09.916 RelationalEventId.TransactionStarting[20209] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Beginning transaction with isolation level 'Unspecified'.
dbug: 10/02/2021 19:44:09.944 RelationalEventId.TransactionStarted[20200] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Began transaction with isolation level 'ReadCommitted'.
```

```
dbug: 10/02/2021 19:44:22.082 CoreEventId.SaveChangesStarting[10004] (Microsoft.EntityFrameworkCore.Update) 
      SaveChanges starting for 'TestContext'.
dbug: 10/02/2021 19:44:22.106 CoreEventId.DetectChangesStarting[10800] (Microsoft.EntityFrameworkCore.ChangeTracking) 
      DetectChanges starting for 'TestContext'.
dbug: 10/02/2021 19:44:22.126 CoreEventId.DetectChangesCompleted[10801] (Microsoft.EntityFrameworkCore.ChangeTracking) 
      DetectChanges completed for 'TestContext'.
dbug: 10/02/2021 19:44:22.341 RelationalEventId.CreatingTransactionSavepoint[20212] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Creating transaction savepoint.
dbug: 10/02/2021 19:44:22.354 RelationalEventId.CreatedTransactionSavepoint[20213] (Microsoft.EntityFrameworkCore.Database.Transaction) 
      Created transaction savepoint.
```

```
dbug: 10/02/2021 19:44:22.485 RelationalEventId.CommandExecuting[20100] (Microsoft.EntityFrameworkCore.Database.Command) 
      Executing DbCommand [Parameters=[@p0='John Doe' (Size = 4000)], CommandType='Text', CommandTimeout='30']
      SET NOCOUNT ON;
      INSERT INTO [Employees] ([Name])
      VALUES (@p0);
      SELECT [Id]
      FROM [Employees]
      WHERE @@ROWCOUNT = 1 AND [Id] = scope_identity();
dbug: 10/02/2021 19:44:22.608 RelationalEventId.CommandExecuting[20100] (Microsoft.EntityFrameworkCore.Database.Command) 
      Executing DbCommand [Parameters=[@p1='5' (Nullable = true), @p2='12:00:00', @p3='08:00:00'], CommandType='Text', CommandTimeout='30']
      SET NOCOUNT ON;
      INSERT INTO [TimeEntries] ([EmployeeId], [End], [Start])
      VALUES (@p1, @p2, @p3);
      SELECT [Id]
      FROM [TimeEntries]
      WHERE @@ROWCOUNT = 1 AND [Id] = scope_identity();
```