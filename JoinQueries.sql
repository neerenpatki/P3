SELECT p.id, p.name FROM products p, categories c WHERE c.name=c.name AND c.id=p.cid ORDER BY p.name

EXPLAIN ANALYZE VERBOSE
SELECT * INTO tempTable FROM (SELECT p.id, p.name, u.name as user, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN 
sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id
GROUP BY u.name, p.id ORDER BY u.name) AS T

EXPLAIN ANALYZE VERBOSE
SELECT p.id, p.name, u.name as user, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN 
sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id WHERE p.name >= 'Apple Macbook' AND p.name <= 
'Samsung Galaxy'
GROUP BY u.name, p.id ORDER BY u.name

SELECT p.name, u.name as user, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN 
sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id  WHERE p.name >= 'Apple Macbook' AND p.name <= 'Samsung Galaxy'
GROUP BY u.name, p.name ORDER BY u.name

--Customer Cells
SELECT name, uname, SUM(quantity*price) FROM all_temp 
WHERE name >= 'Apple Macbook' AND name <= 'Samsung Galaxy'
GROUP BY uname, name ORDER by uname, name

--Customer Spent
SELECT uname, SUM(quantity*price) FROM all_temp
WHERE TRUE AND TRUE AND TRUE AND TRUE
GROUP BY uname ORDER BY uname LIMIT 20 

SELECT u.name, SUM(s.quantity*s.price) FROM users u LEFT OUTER JOIN sales s ON (s.uid = u.id) 
LEFT OUTER JOIN products p ON (p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE
TRUE AND TRUE AND TRUE GROUP BY u.name ORDER BY u.name LIMIT 20


CREATE TEMPORARY TABLE sales_temp AS(
SELECT u.id, u.name, SUM(s.quantity*s.price) FROM users u LEFT OUTER JOIN 
sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON (p.id = s.pid) LEFT OUTER JOIN
categories c ON (p.cid = c.id) WHERE TRUE AND TRUE AND 
TRUE AND TRUE GROUP BY u.id ORDER BY u.name LIMIT 20);


SELECT name, count(*) as cnt
FROM users
LEFT OUTER JOIN sales
ON (users.id = sales.uid)
GROUP BY name,users.id
ORDER BY name LIMIT 50;

CREATE TEMPORARY TABLE users_temp AS (SELECT * FROM users LIMIT 50);

SELECT * FROM users_temp



SELECT p.id, p.name, u.state as user, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN 
sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id AND TRUE AND TRUE WHERE p.name >= 'Apple Macbook' AND p.name <= 
'Samsung Galaxy'
GROUP BY u.state, p.id ORDER BY u.state

SELECT * FROM tempTable LIMIT 20

DROP TABLE tempTable

SELECT p.id, p.name FROM products p, categories c WHERE c.name=c.name AND c.id=p.cid ORDER BY p.name

SELECT p.id, p.name, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid)
LEFT OUTER JOIN users u ON (s.uid = u.id) WHERE TRUE AND c.name = 'Computers' AND TRUE AND TRUE GROUP BY p.id ORDER BY p.name


SELECT * FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid)
LEFT OUTER JOIN users u ON (s.uid = u.id AND u.state = 'Alabama')


EXPLAIN ANALYZE VERBOSE
SELECT p.name, SUM(s.quantity*s.price) FROM products p, sales s, users u, categories c WHERE p.id = s.pid AND u.state = 'Alabama'
 AND u.id = s.uid AND p.cid = c.id AND c.name = c.name GROUP BY p.id ORDER BY p.name

EXPLAIN ANALYZE VERBOSE
SELECT u.id, u.name, SUM(s.quantity*s.price) FROM users u LEFT OUTER JOIN 
sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON (p.id = s.pid) LEFT OUTER JOIN
categories c ON (p.cid = c.id) WHERE TRUE AND TRUE AND 
TRUE AND TRUE GROUP BY u.id ORDER BY u.name

SELECT u.state, COALESCE(SUM(s.quantity*s.price),0) FROM 
			users u LEFT OUTER JOIN sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON 
			(p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE
			TRUE AND TRUE AND TRUE GROUP BY u.state ORDER BY u.state

SELECT p.name, u.state, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c 
ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid) LEFT OUTER JOIN users u 
ON s.uid = u.id
GROUP BY u.state, p.name ORDER BY u.state


CREATE TEMPORARY TABLE all_temp AS (SELECT p.id as pid, p.name, u.id, u.name as uname, u.state, s.quantity, s.price FROM products p LEFT OUTER JOIN categories c 
ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid) LEFT OUTER JOIN users u 
ON s.uid = u.id)

SELECT * FROM all_temp

-- State Cells
SELECT name, state, SUM(quantity*price) FROM all_temp
GROUP BY state, name ORDER BY state

--State spent
SELECT state, SUM(quantity*price) FROM all_temp
WHERE TRUE AND TRUE AND TRUE GROUP BY state ORDER BY state

SELECT u.state, COALESCE(SUM(s.quantity*s.price),0) FROM 
			users u LEFT OUTER JOIN sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON 
			(p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE
			TRUE AND TRUE AND TRUE GROUP BY u.state ORDER BY u.state



SELECT * FROM users ORDER BY name
SELECT * FROM sales

SELECT SUM(s.quantity * s.price) FROM users u, sales s, categories c, products p WHERE u.name = 'Neeren' AND u.id = s.uid 
AND s.pid = p.id AND p.cid = c.id AND c.name = "+category+" AND u.age >= "+lowerAge+" AND age < "+upperAge+" GROUP BY u.name

 SELECT p.name, SUM(s.quantity*s.price) FROM products p, sales s, users u, categories c WHERE p.id = s.pid 
  AND u.id = s.uid AND p.cid = c.id AND c.name = c.name GROUP BY p.id ORDER BY p.name


SELECT p.id, p.name, SUM(s.quantity*s.price) FROM users u, sales s, products p WHERE u.id = 3 AND s.uid = u.id AND s.pid = p.id 
GROUP BY p.id ORDER BY p.name


SELECT p.id, p.name, SUM(s.quantity*s.price) FROM users u, sales s, products p, categories c
WHERE u.id = 5 AND s.uid = u.id AND s.pid = p.id AND c.id = p.cid AND c.name = 'Cell Phones' GROUP BY p.id ORDER BY p.name


SELECT p.id, p.name, SUM(s.quantity*s.price) FROM users u, sales s, products p, categories c
WHERE u.state = 'Alabama' AND s.uid = u.id AND s.pid = p.id AND c.id = p.cid AND c.name = 'Cell Phones' GROUP BY p.id ORDER BY p.name


-- Products for All Categories
SELECT id, name FROM products ORDER BY name LIMIT 10 OFFSET (nextProds*10)
-- Products Spent Totals
SELECT p.id, p.name, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c 
ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON (s.uid = u.id) 
WHERE stateFilter AND categoryFilter AND lowerAgeFilter AND upperAgeFilter GROUP BY p.id ORDER BY p.name

-- Products for specified category
SELECT p.id, p.name FROM products p, categories c WHERE c.name= category AND c.id=p.cid ORDER BY p.name LIMIT 10
-- Products Spent Totals
prodSpentSQL = SELECT p.id, p.name, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN
 categories c ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON (s.uid = u.id) WHERE
 stateFilter AND categoryFilter AND lowerAgeFilter AND upperAgeFilter GROUP BY p.id ORDER BY p.nameww

--State Spent Total
SELECT u.state, COALESCE(SUM(s.quantity*s.price),0) FROM users u LEFT OUTER JOIN sales s ON (s.uid = u.id) LEFT OUTER JOIN 
products p ON (p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE stateFilter AND categoryFilter AND 
lowerAgeFilter AND upperAgeFilter GROUP BY u.state ORDER BY u.state

--State	Spent Cells		
SELECT p.id, p.name, u.state, SUM(s.quantity*s.price) FROM 
			products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN 
			sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id AND lowerAgeFilter
			AND upperAgeFilter WHERE p.name >= prodNames.get(0) AND p.name <= prodNames.get(prodNames.size()-1)
			AND u.state >= startState AND u.state <= endState GROUP BY u.state, p.id ORDER BY u.state

--Customer Total Spent
SELECT u.id, u.name, COALESCE(SUM(s.quantity*s.price),0) FROM 
			users u LEFT OUTER JOIN sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON 
			(p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE stateFilter
			 AND categoryFilter AND lowerAgeFilter AND upperAgeFilter GROUP BY u.id 
			ORDER BY u.name LIMIT 20 OFFSET +(nextRows*20);


SELECT u.id, u.name, COALESCE(SUM(s.quantity*s.price),0) FROM 
			users u LEFT OUTER JOIN sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON 
			(p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE c.name = 'Computers' GROUP BY u.id 
			ORDER BY u.name LIMIT 20

SELECT p.id, p.name, u.name, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id)
LEFT OUTER JOIN sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id GROUP BY u.name, p.id ORDER BY u.name
			
--Customer Spent Cells
SELECT p.id, p.name, u.name, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id)
LEFT OUTER JOIN sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id WHERE p.name >= prodNames.get(0)
 AND p.name <= prodNames.get(prodNames.size()-1) AND u.name >= customerNames.get(0)+
  AND u.name <= customerNames.get(custonerNames.size()-1) GROUP BY u.name, p.id ORDER BY u.name

SELECT id, name FROM users u WHERE TRUE AND TRUE AND TRUE ORDER BY u.name LIMIT 20 
SELECT * FROM users

--Query for customers ordered by totals
SELECT u.id, u.name, COALESCE(SUM(s.quantity*s.price),0) AS total FROM 
			users u LEFT OUTER JOIN sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON 
			(p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) GROUP BY u.id 
			ORDER BY total desc LIMIT 20


SELECT * FROM users WHERE state = 'Alabama'

CREATE INDEX sales_pid ON sales(pid)
CREATE INDEX users_state ON users(state)
CREATE INDEX users_name ON users(name)
CREATE INDEX sales_uid ON sales(uid)

DROP TABLE prodTot;
DROP TABLE cat_user;
DROP TABLE customers;
DROP TABLE st;


DROP TABLE prod_user;
DROP TABLE prod_st
--product,user (precomputed)
CREATE TABLE prod_user AS (SELECT p.id as pid, p.name, p.cid, u.id, u.name as uname, state, SUM(s.quantity*s.price) 
FROM products p LEFT OUTER JOIN categories c 
ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid) LEFT OUTER JOIN users u 
ON s.uid = u.id LEFT OUTER JOIN states st ON(u.stateID = st.id) WHERE u.name is not null GROUP BY p.id, u.id, state)

SELECT * FROM prod_user

--product,state (precomputed)

CREATE TABLE prod_st AS (SELECT p.id as pid, p.name, p.cid, state, SUM(s.quantity*s.price) 
FROM products p LEFT OUTER JOIN categories c 
ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid) LEFT OUTER JOIN users u 
ON s.uid = u.id LEFT OUTER JOIN states st ON(u.stateID = st.id) WHERE state is not null GROUP BY p.id, state )
SELECT * FROM prod_st

--total for customers
SELECT id, uname, SUM(sum) FROM prod_user GROUP BY id, uname ORDER BY sum DESC LIMIT 20

--filters

--total for states
--filters

--all
SELECT SUM(sum) FROM prod_user

--category
SELECT cid, SUM(sum) FROM prodTot GROUP BY cid, sum

--product (precomputed)
CREATE TABLE prodTot AS (SELECT pid, name, cid, SUM(sum) FROM prod_user GROUP BY pid, name, cid)

--all
SELECT SUM(sum) FROM prodTot

-- top 10 products
SELECT * FROM prodTot ORDER BY sum desc LIMIT 10

DROP TABLE cat_user
--category,user (precomputed)
CREATE TABLE cat_user AS (SELECT cid, id, uname, state, SUM(sum) FROM prod_user GROUP BY cid, id, uname, state)

--all
SELECT SUM(sum) FROM cat_user

--category
SELECT cid, SUM(sum) FROM cat_user GROUP BY cid

--user (precomputed)
CREATE TABLE customers AS (SELECT id, uname, state, SUM(sum) FROM cat_user where id is not null GROUP BY id, uname, state)



--st (precomputed)
DROP TABLE st
CREATE TABLE st AS (SELECT state, SUM(sum) FROM prod_st where state is not null group by state)
SELECT * FROM st

-- top 20 users
SELECT * FROM customers ORDER BY sum desc LIMIT 20

SELECT id, uname, SUM(sum) FROM cat_user GROUP BY id, uname ORDER BY sum desc LIMIT 20

SELECT * FROM sales

DROP TABLE users CASCADE;
DROP TABLE categories CASCADE;
DROP TABLE products CASCADE;
DROP TABLE carts CASCADE;
DROP TABLE sales CASCADE;

CREATE TABLE states (
    id          SERIAL PRIMARY KEY,
    state       TEXT NOT NULL UNIQUE
);

insert into states (state) values ('Alabama');
insert into states (state) values ('Alaska');
insert into states (state) values ('Arizona');
insert into states (state) values ('Arkansas');
insert into states (state) values ('California');
insert into states (state) values ('Colorado');
insert into states (state) values ('Connecticut');
insert into states (state) values ('Delaware');
insert into states (state) values ('Florida');
insert into states (state) values ('Georgia');
insert into states (state) values ('Hawaii');
insert into states (state) values ('Idaho');
insert into states (state) values ('Illinois');
insert into states (state) values ('Indiana');
insert into states (state) values ('Iowa');
insert into states (state) values ('Kansas');
insert into states (state) values ('Kentucky');
insert into states (state) values ('Louisiana');
insert into states (state) values ('Maine');
insert into states (state) values ('Maryland');
insert into states (state) values ('Massachusetts');
insert into states (state) values ('Michigan');
insert into states (state) values ('Minnesota');
insert into states (state) values ('Mississippi');
insert into states (state) values ('Missouri');
insert into states (state) values ('Montana');
insert into states (state) values ('Nebraska');
insert into states (state) values ('Nevada');
insert into states (state) values ('New Hampshire');
insert into states (state) values ('New Jersey');
insert into states (state) values ('New Mexico');
insert into states (state) values ('New York');
insert into states (state) values ('North Carolina');
insert into states (state) values ('North Dakota');
insert into states (state) values ('Ohio');
insert into states (state) values ('Oklahoma');
insert into states (state) values ('Oregon');
insert into states (state) values ('Pennsylvania');
insert into states (state) values ('Rhode Island');
insert into states (state) values ('South Carolina');
insert into states (state) values ('South Dakota');
insert into states (state) values ('Tennessee');
insert into states (state) values ('Texas');
insert into states (state) values ('Utah');
insert into states (state) values ('Vermont');
insert into states (state) values ('Virginia');
insert into states (state) values ('Washington');
insert into states (state) values ('West Virginia');
insert into states (state) values ('Wisconsin');
insert into states (state) values ('Wyoming');

/**table 1: [entity] users**/
CREATE TABLE users (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    role        TEXT NOT NULL,
    age   	INTEGER NOT NULL,
    stateID  	INTEGER REFERENCES states (id) ON DELETE CASCADE
);
INSERT INTO users (name, role, age, stateID) VALUES('CSE','owner',35, 1);
INSERT INTO users (name, role, age, stateID) VALUES('David','customer',33, 2);
INSERT INTO users (name, role, age, stateID) VALUES('Floyd','customer',27, 3);
INSERT INTO users (name, role, age, stateID) VALUES('James','customer',55, 4);
INSERT INTO users (name, role, age, stateID) VALUES('Ross','customer',24, 5);
INSERT INTO users (name, role, age, stateID) VALUES('Tyler','customer',19, 6);
INSERT INTO users (name, role, age, stateID) VALUES('Neeren', 'customer',21,10);
SELECT * FROM  users  order by id asc limit 5;


/**table 2: [entity] category**/
CREATE TABLE categories (
    id          SERIAL PRIMARY KEY,
    name        TEXT NOT NULL UNIQUE,
    description TEXT
);
INSERT INTO categories (name, description) VALUES('Computers','A computer is a general purpose device that can be programmed to carry out a set of arithmetic or logical operations automatically. Since a sequence of operations can be readily changed, the computer can solve more than one kind of problem.');
INSERT INTO categories (name, description) VALUES('Cell Phones','A mobile phone (also known as a cellular phone, cell phone, and a hand phone) is a phone that can make and receive telephone calls over a radio link while moving around a wide geographic area. It does so by connecting to a cellular network provided by a mobile phone operator, allowing access to the public telephone network.');
INSERT INTO categories (name, description) VALUES('Cameras','A camera is an optical instrument that records images that can be stored directly, transmitted to another location, or both. These images may be still photographs or moving images such as videos or movies.');
INSERT INTO categories (name, description) VALUES('Video Games','A video game is an electronic game that involves human interaction with a user interface to generate visual feedback on a video device..');
SELECT * FROM categories order by id asc;

/**table 3: [entity] product**/
CREATE TABLE products (
    id          SERIAL PRIMARY KEY,
    cid         INTEGER REFERENCES categories (id) ON DELETE CASCADE,
    name        TEXT NOT NULL,
    SKU         TEXT NOT NULL UNIQUE,
    price       INTEGER NOT NULL
);
INSERT INTO products (cid, name, SKU, price) VALUES(1, 'Apple MacBook',		'103001',	1200); /**1**/
INSERT INTO products (cid, name, SKU, price) VALUES(1, 'HP Laptop',    		'106044',	480);
INSERT INTO products (cid, name, SKU, price) VALUES(1, 'Dell Laptop',  		'109023',	399);/**3**/
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'Iphone 5s',        	'200101',	709);
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'Samsung Galaxy S4',	'208809',	488);/**5**/
INSERT INTO products (cid, name, SKU, price) VALUES(2, 'LG Optimus g',    	 '209937',	375);
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'Sony DSC-RX100M',	'301211',	689);/**7**/
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'Canon EOS Rebel T3', 	 '304545',	449);
INSERT INTO products (cid, name, SKU, price) VALUES(3, 'Nikon D3100',  		'308898',	520);
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'Xbox 360',  		'405065',	249);/**10**/
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'Nintendo Wii U ', 	 '407033',	430);
INSERT INTO products (cid, name, SKU, price) VALUES(4, 'Nintendo Wii',  	'408076',	232);
SELECT * FROM products order by id asc limit 10;



/**table 4: [relation] carts**/
CREATE TABLE sales (
    id          SERIAL PRIMARY KEY,
    uid         INTEGER REFERENCES users (id) ON DELETE CASCADE,
    pid         INTEGER REFERENCES products (id) ON DELETE CASCADE,
    quantity    INTEGER NOT NULL,
    price	INTEGER NOT NULL
);

SELECT * FROM sales order by id desc;

CREATE TABLE carts (
    id          SERIAL PRIMARY KEY,
    uid         INTEGER REFERENCES users (id) ON DELETE CASCADE,
    pid         INTEGER REFERENCES products (id) ON DELETE CASCADE,
    quantity    INTEGER NOT NULL,
    price	INTEGER NOT NULL
);

INSERT INTO sales (uid, pid, quantity, price) VALUES(3, 1 , 2, 1200);
INSERT INTO sales (uid, pid, quantity, price) VALUES(3, 2 , 1, 480);
INSERT INTO sales (uid, pid, quantity, price) VALUES(4, 10, 4, 249);
INSERT INTO sales (uid, pid, quantity, price) VALUES(5, 12, 2, 232);
INSERT INTO sales (uid, pid, quantity, price) VALUES(5, 9 , 5, 520);
INSERT INTO sales (uid, pid, quantity, price) VALUES(5, 5 , 3, 488);
INSERT INTO sales (uid, pid, quantity, price) VALUES(5, 1, 1, 1200);


SELECT s.id, state FROM users u, states s WHERE u.stateID = s.id GROUP BY s.id ORDER BY state asc

insert into us_t (id, state) select u2.id, state from (
SELECT s.id, state FROM users u, states s WHERE u.stateID = s.id GROUP BY s.id ORDER BY state asc limit 20) 
as u left outer join users u2 on u2.stateID = u.id order by state

select s.state from users u, states s where u.stateID = s.id and age>12 and age<= 45 group by s.state order by s.state asc limit 20

select u2.id, state from (
select s.id, s.state from users u, states s where u.stateID = s.id and age>12 and age<= 45 group by s.id, s.state order by s.state asc limit 20
) as u left outer join users u2 on u2.stateID = u.id order by state

select s.state from users u, states s where s.state='Alabama' and u.stateID = s.id group by s.id order by state asc limit 20

select u2.id, u.state from (
select u.id, s.state from users u, states s where s.state='Alabama' and u.stateID = s.id group by u.id,s.state order by state asc limit 20
) as u left outer join users u2 on u2.stateID=u.id order by u.state

select s.id, s.state from users u, states s where s.state='Alabama' and u.stateID = s.id group by s.id order by s.state asc limit 20



SELECT s.id, state FROM users u, states s WHERE u.stateID = s.id GROUP BY s.id ORDER BY state asc
select id,name from products order by name asc limit 20
insert into us_t (id, state) select u2.id, state from (
SELECT s.id, state FROM users u, states s WHERE u.stateID = s.id GROUP BY s.id ORDER BY state asc
) as u left outer join users u2 on u2.stateID = u.id order by state

select count(distinct stateID) from users

CREATE TABLE us_t (id int, state text)
CREATE TABLE ps_t (id int, name text)


select u.state, sum(s.quantity*s.price) from  us_t u, sales s  where s.uid=u.id group by u.state

select s.pid, sum(s.quantity*s.price) from ps_t p, sales s where s.pid=p.id  group by s.pid

insert into ps_t (id, name) select id,name from products order by name asc limit 20
select s.pid, sum(s.quantity*s.price) from ps_t p, sales s where s.pid=p.id  group by s.pid

select s.pid, sum(s.quantity*s.price) from ps_t p, sales s, users u, states st
where s.pid=p.id and s.uid=u.id and u.stateID = st.id and st.state ='Arkansas'  group by s.pid;

SQL_1="select s.id, s.state from users u, states s where u.stateID = s.id "+
		" group by s.id order by s.state asc limit "+show_num_row;
		SQL_2="select id,name from products order by name asc limit "+show_num_col;
		SQL_ut="insert into us_t (id, state) select u2.id, state from ("+SQL_1+") as u "+
		"left outer join users u2 on u2.stateID = u.id order by state";
		SQL_pt="insert into ps_t (id, name) "+SQL_2;
		SQL_row="select count(distinct stateID) from users";
		SQL_col="select count(*) from products";
		SQL_amount_row="select u.state, sum(s.quantity*s.price) from  us_t u, sales s  where s.uid=u.id group by u.state;";
		SQL_amount_col="select s.pid, sum(s.quantity*s.price) from ps_t p, sales s where s.pid=p.id  group by s.pid;";
