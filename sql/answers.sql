-- show all tables
select *
from pg_catalog.pg_tables
where schemaname != 'pg_catalog' and
      schemaname != 'information_schema';

      -- public	employees	postgres		false	false	false	false
      -- public	orderdetails	postgres		false	false	false	false
      -- public	orders	postgres		false	false	false	false
      -- public	categories	postgres		false	false	false	false
      -- public	customergroupthresholds	postgres		false	false	false	false
      -- public	customers	postgres		false	false	false	false
      -- public	shippers	postgres		false	false	false	false
      -- public	products	postgres		false	false	false	false
      -- public	suppliers	postgres		false	false	false	false

-- 1.
select * from shippers;

-- 2.
select categoryname, description
from categories;

-- 3.
select firstname, lastname, hiredate, title
from employees
where title = 'Sales Representative';

-- 4.select firstname, lastname, hiredate
from employees
where country = 'USA';

-- 5.
select *
from orders
where employeeid = 5;

-- 6.
select supplierid, contactname, contacttitle
from suppliers
where contacttitle != 'Marketing Manager';

-- 7.
-- lower, like
select productid, productname
from products
where lower(productname) like '%queso%';

-- 8.
select orderid, customerid, shipcountry
from orders
where shipcountry in ('France', 'Belgium');

-- 9.
select orderid, customerid, shipcountry
from orders
where shipcountry in ('Brazil', 'Mexico', 'Argentina', 'Venezuela');

-- 10.
select firstname, lastname, title, birthdate
from employees
order by birthdate;

-- 11.
select firstname, lastname, title, date(birthdate)
from employees
order by birthdate;

-- 12.
select firstname, lastname, concat(firstname, ' ', lastname) as fullname
from employees;

-- 13.
-- money type
select orderid, productid, unitprice, quantity,
       (unitprice::money::numeric::float8 * quantity) as totalprice
from orderdetails;

-- 14.
select distinct(customerid)
from customers
group by customerid;

-- 15.
select min(orderdate)
from orders;

-- 16.
select distinct(contacttitle)
from customers
group by contacttitle;

-- 17.
select country, count(customerid) as numberofcustomers
from customers
group by country
order by numberofcustomers desc;

-- 18.
-- convert data types
select p.productid, p.supplierid, s.companyname
from products p
inner join suppliers s
on p.supplierid = cast(s.supplierid as INTEGER);

-- 19.
select o.orderid as orderid,
       date(o.orderdate) as orderdate,
       s.companyname as companyname
from orders o
join shippers s
on o.shipvia = s.shipperid
where orderid < 10270
order by orderid;

----- Medium -----
------------------

-- 1.
select c.categoryname, p.totalnumber
from categories c
join
(
  select categoryid, count(productid) as totalnumber
  from products
  group by categoryid
) p
on p.categoryid = c.categoryid
order by totalnumber desc;

-- 2.
select country, city, count(*)
from customers
group by country, city;

-- 3.
select * from products
where unitsinstock <= reorderlevel
order by productid;

-- 4.
select * from products
where (unitsinstock + unitsonorder) <= reorderlevel and
      discontinued = 'false'
order by productid;

-- 5.
select *,
       case
       when region is null then 0
       else 1
       end as hasregion
from customers
order by hasregion;

-- 6.
select shipcountry, avg(freight::money::numeric::float8) as avg_freight
from orders
group by shipcountry
order by avg_freight desc
limit 3;

-- 7.
select shipcountry, avg(freight::money::numeric::float8) as avg_freight
from orders
where date_part('year', orderdate) = '2015'
group by shipcountry
order by avg_freight desc
limit 3;

-- 8.
select shipcountry, avg(freight::money::numeric::float8) as avg_freight
from orders
where date_trunc('month', orderdate)::date in
  (
  select distinct(date_trunc('month', t.orderdate)::date) as month_t
  from orders t
  order by month_t desc
  limit 12
  )
group by shipcountry
order by avg_freight desc
limit 3;

-- 9.
select o.orderid, od.quantity, p.productname, e.employeeid, e.lastname
from orders o

join
orderdetails od
on o.orderid = od.orderid

join
products p
on p.productid = od.productid

join
employees e
on o.employeeid = e.employeeid
order by o.orderid, p.productid;

-- 10.
select *
from customers c
left join
orders o
on c.customerid = o.customerid
where o.orderid is null;

-- 11.
select *
from customers c
where c.customerid not in
(
  select distinct(customerid)
  from orders o2
  where o2.employeeid = 4
);

------ Hard ------
------------------
-- 1.
select (o2.unitprice::money::numeric::float8 * o2.quantity) as totalprice,
       o1.customerid as customerid
from orders o1
join orderdetails o2
on o1.orderid = o2.orderid
where (o2.unitprice::money::numeric::float8 * o2.quantity) >= 10000;
-- where (o2.unitprice::money::numeric::float8 * o2.quantity) >= 10000 and
--       o1.orderdate between '2016-01-01' and '2017-01-01';

-- 2.
select (o2.unitprice::money::numeric::float8 * o2.quantity) as totalprice,
       o1.customerid as customerid
from orders o1
join orderdetails o2
on o1.orderid = o2.orderid
where (o2.unitprice::money::numeric::float8 * o2.quantity) >= 15000 and
      o1.orderdate between '2016-01-01' and '2017-01-01';
      
-- 3.
select (o2.unitprice::money::numeric::float8 * o2.quantity * (1 - o2.discount)) as totalprice,
       o1.customerid as customerid
from orders o1
join orderdetails o2
on o1.orderid = o2.orderid
where (o2.unitprice::money::numeric::float8 * o2.quantity * (1 - o2.discount)) >= 15000 and
      o1.orderdate between '2016-01-01' and '2017-01-01'
order by totalprice;

-- 4.
select orderdate, employeeid, orderid
from orders
where orderdate = (date_trunc('month', orderdate::date) + interval '1 month' - interval '1 day')::date
order by employeeid, orderid;

-- 5.
select orderid, count(*) as totalcount
from orderdetails
group by orderid
order by totalcount desc
limit 10;

-- 6.
select * from orderdetails where random() < 0.02;

-- 7.
select * from orderdetails 
where quantity >= 60
order by orderid;

-- 8.


-- 9.
select (requireddate::date - shippeddate::date) as delay,
       orderid
from orders
where (requireddate::date - shippeddate::date) > 0
order by delay;

-- 10.

      
