Create table If Not Exists Employee (Id int, Month int, Salary int);
Truncate Table Employee;

Insert Into Employee (Id, Month, Salary)
Values('1', '1', '20'),('2', '1', '20'),('1', '2', '30'),('2', '2', '30'),
      ('2', '2', '30'),('3', '2', '40'),('1', '3', '40'),('3', '3', '60'),
      ('1', '4', '60'),('3', '4', '70');
