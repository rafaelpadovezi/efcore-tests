using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Diagnostics;

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
}