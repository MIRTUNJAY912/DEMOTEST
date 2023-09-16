 select EmployeeId, Name, ManagerId, MinDate
  -- Use lead to get the last date of the next grouping - since it could in theory be more than one day on
  , lead(MinDate) over (partition by EmployeeId, Name order by Grouped) MaxDate
from (
  -- Get the min and max dates for a given grouping
  select EmployeeId, Name, ManagerId, min(Date) MinDate, max(Date) MaxDate, Grouped
  from (
    select *
       -- Sum the change in manager to ensure that if a manager is repeated they form a different group
       , sum(Lagged) over (order by Date asc) Grouped
    from (
      select *
        -- Lag the manager to detect when it changes
        , case when lag(ManagerId,1,-1) over (order by Date asc) <> ManagerId then 1 else 0 end Lagged
      from raw.jaffle_shop.EmployeeHistory
    ) X
  ) Y
  group by EmployeeId, Name, ManagerId, Grouped
) Z
order by EmployeeId, Name, Grouped;
