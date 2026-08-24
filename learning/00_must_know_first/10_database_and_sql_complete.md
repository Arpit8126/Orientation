# Database Concepts & SQL — Complete Guide from Zero to Advanced

A database is an organized collection of data stored and accessed electronically. SQL (Structured Query Language) is the standard language used to communicate with relational databases. This guide covers database fundamentals and basic to advanced SQL syntax.

---

## PART 1: Core Database Concepts

### Relational Database Management Systems (RDBMS)
In a relational database, data is organized into **tables** (also called relations).
- **Table**: A structure of rows and columns.
- **Row (Record/Tuple)**: A single entry/data item in a table.
- **Column (Field/Attribute)**: A specific property of the records (e.g., `email`, `created_at`).
- **Schema**: The blueprint or structural design of the database (tables, columns, types, and constraints).

### Keys and Relationships
To connect tables together, we use keys:
1. **Primary Key (PK)**: A column (or set of columns) that uniquely identifies each row in a table. It cannot be `NULL` and must be unique. (e.g., `id` or `uuid`).
2. **Foreign Key (FK)**: A column in one table that points to the Primary Key of another table. This establishes a link between the two tables.
3. **Composite Key**: A primary key composed of multiple columns.

#### Types of Relationships:
- **One-to-One (1:1)**: A row in Table A is linked to exactly one row in Table B. (e.g., `users` and `user_profiles`).
- **One-to-Many (1:N)**: A row in Table A can be linked to multiple rows in Table B, but a row in Table B links to only one in Table A. (e.g., one `user` has many `messages`). This is implemented by adding the PK of Table A as an FK in Table B.
- **Many-to-Many (N:M)**: Multiple rows in Table A link to multiple rows in Table B. (e.g., `users` can join many `group_conversations`, and a `group_conversation` has many `users`). This is implemented using a **junction table** (or bridge table) containing FKs pointing to both tables.

### Database Normalization
Normalization is the process of organizing data in a database to reduce redundancy and improve data integrity.
- **1NF (First Normal Form)**: Atomic values (no arrays or nested lists inside columns), unique rows.
- **2NF (Second Normal Form)**: Must be in 1NF, and all non-key columns must fully depend on the primary key (no partial dependencies on composite keys).
- **3NF (Third Normal Form)**: Must be in 2NF, and no transitive dependencies (non-key columns must not depend on other non-key columns).

### ACID Properties
A transaction is a sequence of operations performed as a single logical unit of work. Relational databases guarantee transaction safety using the **ACID** model:
1. **Atomicity**: "All or nothing." Either the entire transaction succeeds, or it is completely rolled back.
2. **Consistency**: A transaction takes the database from one valid state to another, maintaining all constraints.
3. **Isolation**: Concurrent execution of transactions yields the same state as if they were run sequentially.
4. **Durability**: Once a transaction commits, the changes are permanent and survive system crashes.

---

## PART 2: Database Definition Language (DDL)

DDL commands are used to define, alter, and delete database structures (schemas, tables, indexes).

### Data Types (PostgreSQL Focus)
- `INT` / `INTEGER`: 4-byte whole number.
- `BIGINT`: 8-byte whole number (for large IDs/numbers).
- `VARCHAR(n)`: Variable-length character string with limit `n`.
- `TEXT`: Unlimited variable-length string.
- `BOOLEAN`: `TRUE`, `FALSE`, or `NULL`.
- `NUMERIC(precision, scale)`: Exact decimal (e.g., `NUMERIC(10, 2)` for currency).
- `TIMESTAMP`: Date and time without time zone.
- `TIMESTAMPTZ`: Date and time with time zone (always use this in production).
- `UUID`: Globally unique identifier.
- `JSONB`: Binary JSON data.

### Creating Tables & Constraints
Constraints enforce rules on data columns.

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL CHECK (email LIKE '%@%'),
    age INT DEFAULT 18 CHECK (age >= 0),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE posts (
    id SERIAL PRIMARY KEY, -- Auto-incrementing integer (1, 2, 3...)
    author_id UUID REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    content TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);
```

#### Foreign Key Referential Actions:
- `ON DELETE CASCADE`: If the parent row is deleted, automatically delete child rows.
- `ON DELETE SET NULL`: If parent row is deleted, set foreign key column to `NULL` in child rows.
- `ON DELETE RESTRICT` / `NO ACTION`: Prevent parent row deletion if child rows exist.

### Modifying Tables (ALTER TABLE)
```sql
-- Add a column
ALTER TABLE users ADD COLUMN phone VARCHAR(15);

-- Drop a column
ALTER TABLE users DROP COLUMN phone;

-- Rename a column
ALTER TABLE users RENAME COLUMN is_active TO active;

-- Change data type
ALTER TABLE users ALTER COLUMN username TYPE VARCHAR(100);

-- Add a constraint
ALTER TABLE users ADD CONSTRAINT check_username_length CHECK (char_length(username) >= 3);
```

### Deleting Structures
```sql
-- Delete a table and all its data
DROP TABLE posts;

-- Delete a table and automatically delete referencing tables
DROP TABLE users CASCADE;

-- Empty a table's data without deleting the table structure
TRUNCATE TABLE posts;
```

---

## PART 3: Database Manipulation Language (DML)

DML commands are used to insert, update, retrieve, and delete data within tables.

### INSERT Statements
```sql
-- Insert a single record
INSERT INTO users (username, email, age) 
VALUES ('arpit', 'arpit@gla.ac.in', 21);

-- Insert multiple records
INSERT INTO users (username, email, age) 
VALUES 
    ('priya', 'priya@gmail.com', 20),
    ('rahul', 'rahul@yahoo.com', 22);

-- Insert and return values (PostgreSQL feature)
INSERT INTO users (username, email) 
VALUES ('sneha', 'sneha@gla.ac.in') 
RETURNING id, created_at;

-- Upsert: INSERT ... ON CONFLICT (Insert or Update on duplicate key)
INSERT INTO users (username, email) 
VALUES ('arpit', 'arpit_new@gla.ac.in')
ON CONFLICT (username) 
DO UPDATE SET email = EXCLUDED.email;
```

### UPDATE Statements
```sql
-- Update specific rows
UPDATE users 
SET age = 22, active = TRUE 
WHERE username = 'arpit';

-- Update using calculations
UPDATE users 
SET age = age + 1; -- Increments age for all users

-- Update and return updated rows
UPDATE users 
SET active = FALSE 
WHERE age > 60 
RETURNING id, username;
```

### DELETE Statements
```sql
-- Delete specific rows
DELETE FROM users 
WHERE active = FALSE;

-- Delete using subquery
DELETE FROM posts 
WHERE author_id IN (SELECT id FROM users WHERE active = FALSE);
```

---

## PART 4: Basic Querying (SELECT)

Retrieve data from the database.

```sql
-- Select all columns
SELECT * FROM users;

-- Select specific columns and alias them
SELECT username AS user_name, email FROM users;

-- Distinct values (remove duplicates)
SELECT DISTINCT age FROM users;

-- Filtering with WHERE
SELECT * FROM users 
WHERE age >= 21 AND active = TRUE;

-- String Matching (LIKE and ILIKE)
SELECT * FROM users WHERE email LIKE '%@gla.ac.in'; -- Case-sensitive
SELECT * FROM users WHERE username ILIKE 'ArPiT%';   -- Case-insensitive (Postgres)

-- Range filter
SELECT * FROM users WHERE age BETWEEN 18 AND 25;

-- List filter
SELECT * FROM users WHERE username IN ('arpit', 'priya', 'rahul');

-- NULL check
SELECT * FROM users WHERE phone IS NULL;
SELECT * FROM users WHERE phone IS NOT NULL;

-- Sorting (ORDER BY)
SELECT * FROM users 
ORDER BY age DESC, username ASC;

-- Pagination (LIMIT and OFFSET)
SELECT * FROM users 
ORDER BY created_at DESC 
LIMIT 10 OFFSET 20; -- Gets page 3 (items 21-30)
```

---

## PART 5: Joins — Combining Tables

Joins allow you to query data from multiple tables using their primary/foreign key connections.

```
Visualizing Joins:
  Table A (Left)               Table B (Right)
  ┌───────────┐                ┌───────────┐
  │  id | name│                │ id | user │
  └───────────┘                └───────────┘
```

### 1. INNER JOIN
Returns rows only when there is a match in **both** tables.
```sql
SELECT users.username, posts.title 
FROM users 
INNER JOIN posts ON users.id = posts.author_id;
```

### 2. LEFT (OUTER) JOIN
Returns **all** rows from the left table, and matched rows from the right table. If no match exists, `NULL` is returned for right table columns.
```sql
SELECT users.username, posts.title 
FROM users 
LEFT JOIN posts ON users.id = posts.author_id;
-- Returns users even if they haven't written any posts.
```

### 3. RIGHT (OUTER) JOIN
Returns **all** rows from the right table, and matched rows from the left table. (Rarely used, prefer Left Join).
```sql
SELECT users.username, posts.title 
FROM users 
RIGHT JOIN posts ON users.id = posts.author_id;
-- Returns all posts, even if author_id points to a deleted user.
```

### 4. FULL (OUTER) JOIN
Returns rows when there is a match in **either** table. Unmatched rows contain `NULL`.
```sql
SELECT users.username, posts.title 
FROM users 
FULL JOIN posts ON users.id = posts.author_id;
```

### 5. CROSS JOIN
Returns the Cartesian product of both tables (every row in A combined with every row in B).
```sql
SELECT users.username, categories.name 
FROM users 
CROSS JOIN categories;
```

### 6. SELF JOIN
Joining a table with itself (useful for hierarchical data like employees and managers).
```sql
SELECT e.name AS employee, m.name AS manager
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.id;
```

---

## PART 6: Aggregate Functions & Grouping

Aggregates perform calculations on multiple rows and return a single value.

```sql
SELECT COUNT(*) FROM users;            -- Total rows
SELECT AVG(age) FROM users;            -- Average age
SELECT SUM(age) FROM users;            -- Sum of all ages
SELECT MIN(age) FROM users;            -- Minimum age
SELECT MAX(age) FROM users;            -- Maximum age
```

### GROUP BY and HAVING
Use `GROUP BY` to group rows with identical values. Use `HAVING` to filter groups (since `WHERE` cannot filter on aggregate results).

```sql
-- Find average age by status, but only for statuses with more than 5 users
SELECT active, AVG(age) AS avg_age, COUNT(*) AS count
FROM users
WHERE age >= 18 -- Filters rows BEFORE grouping
GROUP BY active
HAVING COUNT(*) > 5; -- Filters groups AFTER grouping
```

---

## PART 7: Subqueries & Common Table Expressions (CTEs)

### Subqueries (Nested Queries)
A query written inside another query.

```sql
-- Subquery in WHERE
SELECT * FROM posts 
WHERE author_id = (SELECT id FROM users WHERE username = 'arpit');

-- Subquery in FROM (derived table — must have an alias)
SELECT AVG(post_count) 
FROM (
    SELECT author_id, COUNT(*) AS post_count 
    FROM posts 
    GROUP BY author_id
) AS user_stats;
```

### Common Table Expressions (CTEs / WITH Clause)
CTEs create temporary named result sets that make complex queries cleaner and easier to read.

```sql
WITH user_post_counts AS (
    SELECT author_id, COUNT(*) AS num_posts
    FROM posts
    GROUP BY author_id
)
SELECT users.username, upc.num_posts
FROM users
JOIN user_post_counts upc ON users.id = upc.author_id
WHERE upc.num_posts > 10;
```

#### Recursive CTE (for hierarchy/trees):
```sql
WITH RECURSIVE org_chart AS (
    -- Anchor member
    SELECT id, name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    -- Recursive member
    SELECT e.id, e.name, e.manager_id, o.level + 1
    FROM employees e
    JOIN org_chart o ON e.manager_id = o.id
)
SELECT * FROM org_chart;
```

---

## PART 8: Advanced SQL Functions & Operations

### Window Functions
Window functions perform calculations across a set of table rows related to the current row, without collapsing the rows (unlike `GROUP BY`).

```sql
-- Row numbering, ranking, and partitions
SELECT 
    name, 
    department, 
    salary,
    -- Rank employee salary within their department
    RANK() OVER(PARTITION BY department ORDER BY salary DESC) as dept_salary_rank,
    -- Running total of salary in department
    SUM(salary) OVER(PARTITION BY department ORDER BY hire_date) as running_total
FROM employees;
```

Common window functions:
- `ROW_NUMBER()`: Unique sequential integer starting at 1.
- `RANK()`: Rank with gaps for duplicates (e.g., 1, 2, 2, 4).
- `DENSE_RANK()`: Rank without gaps (e.g., 1, 2, 2, 3).
- `LAG(col, offset)`: Access row data before the current row.
- `LEAD(col, offset)`: Access row data after the current row.

### Case Statements (If/Else inside SQL)
```sql
SELECT username, age,
    CASE 
        WHEN age < 13 THEN 'Child'
        WHEN age BETWEEN 13 AND 19 THEN 'Teenager'
        ELSE 'Adult'
    END AS age_group
FROM users;
```

### Set Operations
Combine results from multiple SELECT queries (queries must have same column count and types).
- `UNION`: Combines results and removes duplicates.
- `UNION ALL`: Combines results keeping all duplicates (faster).
- `INTERSECT`: Returns rows present in **both** queries.
- `EXCEPT` / `MINUS`: Returns rows in the first query but not in the second.

```sql
SELECT email FROM students
UNION
SELECT email FROM teachers;
```

### JSONB Manipulation (PostgreSQL)
PostgreSQL supports indexing and querying raw JSON structures.

```sql
-- Inserting JSONB
INSERT INTO quizzes (title, questions) 
VALUES ('JS Quiz', '[{"text": "Is JS single threaded?", "answer": true}]'::jsonb);

-- Accessing JSONB properties
SELECT title, questions->0->>'text' AS first_question_text
FROM quizzes;

-- Query matching key/value inside JSONB array
SELECT * FROM quizzes 
WHERE questions @> '[{"answer": true}]';
```

---

## PART 9: Performance Tuning & Indexing

Slow queries cause application bottlenecks. Performance tuning is essential.

### Indexes
Indexes are structures that help the database search rows faster, instead of scanning the entire table.
- **B-Tree Index** (default): Good for equality, range queries, sorting (`<`, `<=`, `=`, `>=`, `>`).
- **Unique Index**: Enforces uniqueness constraint while indexing.
- **Composite Index**: Index on multiple columns.
- **Covering Index**: Contains all fields needed for a query using the `INCLUDE` clause.

```sql
-- Create standard B-Tree index
CREATE INDEX idx_users_username ON users(username);

-- Create composite index (order of columns matters!)
CREATE INDEX idx_posts_author_date ON posts(author_id, created_at DESC);
```

#### Indexing Rules of Thumb:
1. Index columns used in `WHERE`, `JOIN` (foreign keys), and `ORDER BY`.
2. Avoid indexing columns with low cardinality (few unique values like boolean `is_active`).
3. Indexes make queries faster but make inserts, updates, and deletes slower because the index must be updated.

### EXPLAIN ANALYZE
Use `EXPLAIN ANALYZE` before a query to inspect the database query planner's execution path and find where time is spent.

```sql
EXPLAIN ANALYZE SELECT * FROM users WHERE username = 'arpit';
```
Look for:
- **Seq Scan (Sequential Scan)**: Scanning the entire table row-by-row (slow). Needs an index.
- **Index Scan**: Searching using an index (fast).

---

## Summary: Relational Database Cheat Sheet

| SQL Clause | Purpose | Example |
|---|---|---|
| `SELECT` | Specifies columns to retrieve | `SELECT name, age` |
| `FROM` | Specifies target table | `FROM users` |
| `WHERE` | Filters rows based on condition | `WHERE age >= 21` |
| `GROUP BY` | Groups identical values for aggregate functions | `GROUP BY country` |
| `HAVING` | Filters group aggregates | `HAVING COUNT(*) > 10` |
| `ORDER BY` | Sorts output | `ORDER BY created_at DESC` |
| `LIMIT` | Limits row count returned | `LIMIT 5` |
| `OFFSET` | Skips rows for pagination | `OFFSET 10` |
| `INNER JOIN` | Links tables matching keys | `JOIN posts ON users.id = posts.user_id` |
| `LEFT JOIN` | Links left table, null for right tables | `LEFT JOIN profile ON users.id = profile.user_id` |
