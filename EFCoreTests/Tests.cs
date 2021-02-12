using System;
using System.Collections.Generic;
using Xunit;

namespace EFCoreTests
{
    public class Tests
    {
        [Fact]
        public void SaveChanges()
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

            using var transaction = context.Database.BeginTransaction();

            context.SaveChanges();

            transaction.Commit();
        }
    }
}
