-- Weather Observation Station 6
select city
from station
where city regexp "^[aeiou]";

-- Weather Observation Station 7
select distinct city
from station
where city regexp "[aeiou]$";

select distinct city
from station
where right(city, 1) in ('a', 'e', 'i', 'o', 'u');

-- Weather Observation Station 8
select distinct city
from station
where city regexp '^[aeiou].*[aeiou]$';

-- Weather Observation Station 9
select distinct city
from station
where city regexp '^[^aeiou]';

-- Higher Than 75 Marks
select name
from students
where marks > 75
order by right(name, 3), id;

-- Type of Triangle
select
case
when a + b > c and a + c > b and a + c > b
then
    case when a = b and b = c then 'Equilateral'
         when a = b or a = c or b = c then 'Isosceles'
         when a != b and a != c and b != c then 'Scalene'
    end
else 'Not A Triangle' end
from triangles;

-- The PADS
select concat(name, '(', left(occupation, 1), ')')
from occupations
order by name;

select concat('There are a total of ', count(*), ' ', lower(occupation), 's.')
from occupations
group by occupation
order by count(*), lower(occupation);

-- Occupations
set @r1 = 0, @r2 = 0, @r3 = 0, @r4 = 0;

select col_doc, col_pro, col_sin, col_act
from
(select @r1 := @r1 + 1 as rnum,
       case when occupation = 'Doctor' then name end as col_doc
from occupations
order by isnull(col_doc), col_doc) t1
join
(select @r2 := @r2 + 1 as rnum,
       case when occupation = 'Professor' then name end as col_pro
from occupations
order by isnull(col_pro), col_pro) t2
on t1.rnum = t2.rnum
join
(select @r3 := @r3 + 1 as rnum,
       case when occupation = 'Singer' then name end as col_sin
from occupations
order by isnull(col_sin), col_sin) t3
on t1.rnum = t3.rnum
join
(select @r4 := @r4 + 1 as rnum,
       case when occupation = 'Actor' then name end as col_act
from occupations
order by isnull(col_act), col_act) t4
on t1.rnum = t4.rnum

where t1.rnum <= (select count(*) from occupations group by occupation order by count(*) desc limit 1);

-- Binary Tree Nodes
select distinct b2.n,
    case
      when b2.p is null then 'Root'
      when b2.p is not null and b1.n is not null then 'Inner'
      else 'Leaf'
    end as 'type'
from
    bst b2
left join
    bst b1
on b1.p = b2.n
order by b2.n;
