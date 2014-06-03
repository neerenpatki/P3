﻿SELECT p.id, p.name FROM products p, categories c WHERE c.name=c.name AND c.id=p.cid ORDER BY p.name

EXPLAIN ANALYZE VERBOSE
SELECT p.id, p.name, u.name, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN 
sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON TRUE  WHERE s.uid = u.id
GROUP BY u.name, p.id ORDER BY u.name

SELECT * FROM users ORDER BY name

SELECT p.id, p.name, u.state, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN 
sales s ON (p.id = s.pid) LEFT OUTER JOIN users u ON s.uid = u.id AND u.age >= 12 AND u.age < 18
GROUP BY u.state, p.id ORDER BY u.state

SELECT p.id, p.name FROM products p, categories c WHERE c.name=c.name AND c.id=p.cid ORDER BY p.name

SELECT p.id, p.name, SUM(s.quantity*s.price) FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid)
LEFT OUTER JOIN users u ON (s.uid = u.id) WHERE TRUE AND c.name = 'Computers' AND TRUE AND TRUE GROUP BY p.id ORDER BY p.name


SELECT * FROM products p LEFT OUTER JOIN categories c ON (p.cid = c.id) LEFT OUTER JOIN sales s ON (p.id = s.pid)
LEFT OUTER JOIN users u ON (s.uid = u.id AND u.state = 'Alabama')


EXPLAIN ANALYZE VERBOSE
SELECT p.name, SUM(s.quantity*s.price) FROM products p, sales s, users u, categories c WHERE p.id = s.pid AND u.state = 'Alabama'
 AND u.id = s.uid AND p.cid = c.id AND c.name = c.name GROUP BY p.id ORDER BY p.name

SELECT u.id, u.name, SUM(s.quantity*s.price) FROM users u LEFT OUTER JOIN 
sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON (p.id = s.pid) LEFT OUTER JOIN
categories c ON (p.cid = c.id) WHERE TRUE AND c.name = 'Computers' AND 
TRUE AND TRUE GROUP BY u.id ORDER BY u.name

SELECT u.state, COALESCE(SUM(s.quantity*s.price),0) FROM 
			users u LEFT OUTER JOIN sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON 
			(p.id = s.pid) LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE
			TRUE AND TRUE AND TRUE GROUP BY u.state ORDER BY u.state


SELECT * FROM users
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


SELECT u.state, COALESCE(SUM(s.quantity*s.price),0) FROM 
users u LEFT OUTER JOIN sales s ON (s.uid = u.id) LEFT OUTER JOIN products p ON (p.id = s.pid)
LEFT OUTER JOIN categories c ON (p.cid = c.id) WHERE TRUE
AND c.name = 'Video Games' AND TRUE AND TRUE GROUP BY u.state ORDER BY u.state

SELECT * FROM users
SELECT * FROM sales