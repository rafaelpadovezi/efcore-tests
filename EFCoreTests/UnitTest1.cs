using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using Xunit;

namespace EFCoreTests
{
    public class Employee
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public ICollection<TimeEntry> Entries { get; set; }
    }

    public class TimeEntry
    {
        public int Id { get; set; }
        public TimeSpan Start { get; set; }
        public TimeSpan End { get; set; }
    }

    public class TestContext : DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder
                .UseSqlServer(
                    "Data Source=localhost,1433;Initial Catalog=Timesheet;User Id=sa;Password=Password1")
                .LogTo(message => Debug.WriteLine(message));
        }

        public DbSet<Employee> Employees { get; set; }
        public DbSet<TimeEntry> TimeEntries { get; set; }
    }

    public class UnitTest1
    {


        [Fact]
        public void Test1()
        {
            var context = new TestContext();
            context.Database.EnsureCreated();

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
        }

        [Fact]
        public void ExplicityTransaction()
        {
            using var context = new TestContext();
            context.Database.EnsureCreated();

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
        }
    }
}
