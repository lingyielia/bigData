## General Order
- from
- on
- join
- where
- group by
- having
- select
- order by
- limit

## Components
- create row number
- self join
- case
- calculate median

## Questions
### 184. Department Highest Salary
```
select d.Name as Department,
      e.Name as Employee,
      e.Salary
from Employee e, Department d
where e.DepartmentId = d.Id and
    (e.DepartmentId, e.Salary) in
    (select DepartmentId, max(Salary) as Salary
     from Employee
     group by DepartmentId
    );
```

### 176. Second Highest Salary
```
select ifnull
((select distinct Salary
  from Employee
  order by Salary desc
  limit 1 offset 1  
  ), null
) as SecondHighestSalary;
```

### 177. Nth Highest Salary
> function
```
create function getNthHighestSalary(N int) returns int
begin
declare M int;
set M = N - 1;
    return (
      select distinct Salary from Employee
      order by Salary desc
      limit 1 offset M
      );
end
```

### 178. Rank Scores
> dense_rank
```
<!-- window function -->
select Score, dense_rank() over (order by Score desc) as 'Rank'
from Scores;
```

```
select s.Score, count(r.Score) as 'Rank'
from Scores s,
     (
     select distinct Score
     from Scores
     ) r
where s.Score <= r.Score
group by s.Id, s.Score
order by s.Score desc;
```

### 180. Consecutive Numbers
```
select distinct l1.Num as ConsecutiveNums
from Logs l1, Logs l2, Logs l3
where l1.Id = l2.Id - 1 and
      l2.Id = l3.Id - 1 and
      l1.Num = l2.Num and
      l2.Num = l3.Num;
```

### 197. Rising Temperature

```
<!-- window function -->
select t.Id
from
    (
    select Temperature, Id,
           lag(Temperature) over (order by RecordDate) as 't_yesterday'
    from Weather
    ) t
where t.Temperature - t.t_yesterday > 0;
```

> datediff()
```
select w2.Id
from Weather w1
join Weather w2
on datediff (w2.RecordDate, w1.RecordDate) = 1
where w2.Temperature > w1.Temperature;
```

### 182. Duplicate Emails
> having
```
select Email
from Person
group by Email
having count(Id) > 1;
```

### 627. Swap Salary
> update, if
```
update salary
set sex = if(sex='f', 'm', 'f');
```
> case
```
update salary
set sex =
case sex
    when 'f' then 'm'
    else 'f'
end;
```

## Questions Pass
### 175. Combine Two Tables
```
select FirstName, LastName, City, State
from Person
left join Address
on Person.PersonId = Address.PersonId;
```

### 181. Employees Earning More Than Their Managers
```
select e.Name
from Employee e, Employee m
where e.ManagerId = m.Id and e.Salary > m.Salary;
```

### 183. Customers Who Never Order
```
select c.Name as Customers
from Customers c
left join Orders o
on c.Id = o.CustomerId
where o.CustomerId is null;
```

### 196. Delete Duplicate Emails
> delete
```
delete from Person
where Id not in
( select Id from
    (
    select min(Id) as Id
    from Person
    group by Email
    ) t
);
```

### 595. Big Countries
```
select name, population, area
from World
where area > 3000000 or
      population > 25000000;
```
