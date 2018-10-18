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
