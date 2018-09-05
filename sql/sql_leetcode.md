# All SQL Questions on Leetcode
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

### 597. Friend Requests I: Overall Acceptance Rate
```
select
ifnull(round(count(distinct requester_id, accepter_id) / count(distinct sender_id, send_to_id), 2), 0) as accept_rate
from friend_request, request_accepted;
```
follow-up
```
select date_format(request_date, '%Y-%m') as res_month,
       ifnull(round((count(distinct requester_id, accepter_id)) /
                    (count(distinct sender_id, send_to_id)), 2), 0) as accept_rate
from friend_request, request_accepted
where date_format(request_date, '%Y-%m') = date_format(accept_date, '%Y-%m')
group by res_month;
```

### 626. Exchange Seats
> case
```
select
    case
    when seat.id % 2 != 0 and
         seat.id = (select count(*) from seat) then seat.id
    when seat.id % 2 = 0 then seat.id - 1
    else seat.id + 1
    end as id,
    student
from seat
order by id;
```

### 578. Get Highest Answer Rate Question
> extract different count from on column
```
select question_id as survey_log
from (
    select question_id,
           sum(case
                   when action = 'answer' then 1
                   else 0
               end) as num_a,
           sum(case
                   when action = 'show' then 1
                   else 0
               end) as num_s
    from survey_log
    group by question_id
) temp
order by (num_a / num_s) desc limit 1;
```

### 579. Find Cumulative Salary of an Employee
```
<!-- window function -->
select Id, Month,
       sum(Salary) over (partition by Id order by Month) as 'Salary'
from Employee e
where (select count(*) from Employee e1 where e1.Id = e.Id and e1.Month > e.Month) between 1 and 3
order by Id, Salary desc;
```
> self join
```
select e1.Id, max(e2.Month) as Month, sum(e2.Salary) as Salary
from Employee e1, Employee e2
where e1.Id = e2.Id and (e2.Month between (e1.Month-3) and (e1.Month-1))
group by e1.Id, e1.Month
order by e1.Id, e1.Month desc;
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

### 596. Classes More Than 5 Students
```
select class
from courses
group by class
having count(distinct student) >= 5;
```

### 586. Customer Placing the Largest Number of Orders
```
select customer_number from orders
group by customer_number
having count(order_number) =
  (
    select max(order_count) as max_count
    from
    (
      select count(order_number) as order_count
      from orders
      group by customer_number
      ) t
  );
```

### 620. Not Boring Movies
```
select *
from cinema
where id % 2 = 1 and
      description not in ('boring')
order by rating desc;
```

### 577. Employee Bonus
> left join
```
select name, bonus
from Employee e
left join Bonus b
on e.empId = b.empId
where bonus < 1000 or bonus is null;
```

### 613. Shortest Distance in a Line
```
select min(p1.x - p2.x) as shortest
from point p1, point p2
where p1.x > p2.x;
```

### 603. Consecutive Available Seats
> abs
```
select distinct c1.seat_id
from cinema c1, cinema c2
where abs(c1.seat_id - c2.seat_id) = 1 and
      c1.free = 1 and
      c2.free = 1
order by seat_id;
```

### 584. Find Customer Referee
```
select name
from customer
where referee_id != 2 or referee_id is null;
```

### 607. Sales Person
```
select s.name
from salesperson s
left join
(
  select sales_id
  from orders o, company c
  where o.com_id = c.com_id and
        c.name = 'RED'
) t
on s.sales_id = t.sales_id
where t.sales_id is null;
```

### 619. Biggest Single Number
> deal with null case
```
select
(
  select num
  from number
  group by num
  having count(num) = 1
  order by num desc
  limit 1
) as num;
```

### 610. Triangle Judgement
> case
```
select x, y, z,
       case
           when x + y > z and x + z > y and y + z > x then 'Yes'
           else 'No'
       end as 'triangle'
from triangle;
```

### 614. Second Degree Follower
> self join
```
select f1.follower, count(distinct f2.follower) as num
from follow f1
join follow f2
on f1.follower = f2.followee
group by f1.follower
order by f1.follower;
```

### 585. Investments in 2016
> unique
```
select round(sum(TIV_2016), 2) as TIV_2016
from insurance
where PID not in
    (select PID from insurance group by TIV_2015 having count(PID) = 1) and
      PID in
    (select PID from insurance group by LAT, LON having count(PID) = 1);
```

### 574. Winning Candidate
```
select Name
from Candidate c,
     (select CandidateId, count(id) as num from Vote
     group by CandidateId
     order by num
     limit 1) t
where c.id = t.CandidateId;
```

### 570. Managers with at Least 5 Direct Reports
```
select Name
from Employee e,
     (
     select ManagerId
     from Employee
     group by ManagerId
     having count(*) >= 5
     ) t
where e.Id = t.ManagerId;
```

### 602. Friend Requests II: Who Has the Most Friends
> union
```
select id1 as id, count(distinct id2) as num
from (
  select requester_id as id1, accepter_id as id2 from request_accepted
  union
  select accepter_id as id1, requester_id as id2 from request_accepted
) t
group by id1
order by num desc
limit 1;

```

### 612. Shortest Distance in a Plane
> round, logic and or
```
select t.dist as shortest
from (
  select round(sqrt((p1.x - p2.x)*(p1.x - p2.x) + (p1.y - p2.y)*(p1.y - p2.y)), 2) as dist
  from point_2d p1, point_2d p2
  where p1.x != p2.x or p1.y != p2.y
  order by dist
  limit 1
  ) t;
```

### 608. Tree Node
> must left join
```
select distinct t1.id,
       case
           when t1.p_id is null then 'Root'
           when t1.p_id is not null and t2.id is not null then 'Inner'
           else 'Leaf'
       end as 'Type'
from tree t1 left join tree t2
on t1.id = t2.p_id;
```

### 580. Count Student Number in Departments
```
select dept_name,
       ifnull(num, 0) as student_number
from department d
left join (
  select dept_id, count(student_id) as num
  from student
  group by dept_id
  ) t
on d.dept_id = t.dept_id
order by student_number desc, dept_name;
```

### 185. Department Top Three Salaries
```
<!-- window function -->
select d.Name as Department,
       t.Name as Employee,
       t.Salary as Salary
from Department d,
     (
     select *,
            dense_rank() over (partition by DepartmentId order by Salary desc) as 's_rank'
     from Employee
     order by DepartmentId, Salary desc
     ) t
where t.DepartmentId = d.Id and
      t.s_rank <= 3;
```
> top 3
```
select d.Name as Department,
       e.Name as Employee,
       e.Salary as Salary
from Department d, Employee e
where 3 >
    (
    select count(distinct e1.Salary)
    from Employee e1
    where e1.Salary > e.Salary and
    e1.DepartmentId = e.DepartmentId) and
    d.Id = e.DepartmentId
order by Department, Salary desc;
```

### 262. Trips and Users
```
select t.Request_at as Day,
       round(sum(case
                   when t.Status != 'completed' then 1 else 0
                 end) / count(*), 2) as 'Cancellation Rate'
from (select * from Trips
      where Client_Id in (select Users_Id from Users where Banned = 'No') and
            Driver_Id in (select Users_Id from Users where Banned = 'No')) t
group by t.Request_at
having Day between '2013-10-01' and '2013-10-03';
```

### 571. Find Median Given Frequency of Numbers
```
select avg(n.Number) as median
from Numbers n
where abs((select sum(Frequency) from Numbers n1 where n1.Number <= n.Number) -
          (select sum(Frequency) from Numbers n1 where n1.Number >= n.Number)) <= n.Frequency;
```

### 569. Median Employee Salary
> find median
```
select min(Id), Company, Salary
from Employee e1
where abs((select count(*) from Employee e2 where e2.Company=e1.Company and e2.Salary <= e1.Salary) -
          (select count(*) from Employee e3 where e3.Company=e1.Company and e3.Salary >= e1.Salary)) <= 1
group by Company, Salary
order by Company, Salary;
```

### 615. Average Salary: Departments VS Company
> join and compare
```
select c.pay_month, d.department_id,
       case
           when d.avg_dep > c.avg_com then 'higher'
           when d.avg_dep < c.avg_com then 'lower'
           else 'same'
       end as comparison
from (
    select date_format(pay_date, '%Y-%m') as pay_month,
           avg(amount) as avg_com
    from salary
    group by pay_month) c
join (
    select date_format(pay_date, '%Y-%m') as pay_month,
           e.department_id,
           avg(amount) as avg_dep
    from salary, employee e
    where salary.employee_id = e.employee_id
    group by pay_month, department_id
  ) d
on c.pay_month = d.pay_month;
```

### 618. Students Report By Geography
> pivot table
```
select t_am.America, t_as.Asia, t_eu.Europe
from
(select @id1:=0, @id2:=0, @id3:=0) t,
(select @id1:=@id1+1 as id1, name as Asia from student where continent = 'Asia' order by Asia) t_as
right join
(select @id2:=@id2+1 as id2, name as America from student where continent = 'America' order by America) t_am
on t_as.id1 = t_am.id2
left join
(select @id3:=@id3+1 as id3, name as Europe from student where continent = 'Europe' order by Europe) t_eu
on t_am.id2 = t_eu.id3;
```
