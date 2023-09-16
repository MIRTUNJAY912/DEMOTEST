-- Calculate the maximum salary
WITH MaxSalaryCTE AS (
    SELECT MAX(Salary) AS MaxSalary
    FROM raw.jaffle_shop.Employee
)

-- Calculate the SalaryDifference
SELECT
    E.EmployeeID,
    E.FirstName,
    E.LastName,
    E.Salary,
    MS.MaxSalary - E.Salary AS SalaryDifference
FROM raw.jaffle_shop.Employee AS E
CROSS JOIN MaxSalaryCTE AS MS;
