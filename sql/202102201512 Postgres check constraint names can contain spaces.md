# Postgres check constraint names can contain spaces

You can give check constraints very descriptive names in Postgres by using double quotes, so that the constraint name itself is a full English clause.

For instance:

```sql
create table people (
    name text
        constraint "name must be more than two characters long"
        check (length(name) > 2),
    age int
        constraint "users must be at least 18 years old"
        check (age >= 18)
);
```

When we use `\d` to describe the table in `psql` we get this result:

```sql
               Table "public.people"
 Column |  Type   | Collation | Nullable | Default 
--------+---------+-----------+----------+---------
 name   | text    |           |          | 
 age    | integer |           |          | 
Check constraints:
    "name must be more than two characters long" CHECK (length(name) > 2)
    "users must be at least 18 years old" CHECK (age >= 18)
```

This is useful as the name of the constraint is included in the error message, for instance given the following Python program using `psycopg2` directly:

```python
import psycopg2
import psycopg2.errors

conn = psycopg2.connect(user="robjwells", database="robjwells")
with conn.cursor() as cur:
    try:
        cur.execute(
            "insert into people (name, age) values ('Jo', 42)"
        )
    except psycopg2.errors.CheckViolation as e:
        print("Caught CheckViolation:")
        print(e)
    finally:
        conn.rollback()
```

We get the following output:

```
Caught CheckViolation:
new row for relation "people" violates check constraint "name must be more than two characters long"
DETAIL:  Failing row contains (Jo, 42).
```

Similarly, if we change the constraint that is violated:

```diff
- "insert into people (name, age) values ('Jo', 42)"
+ "insert into people (name, age) values ('Gizmo', 1)"
```

We get:

```
Caught CheckViolation:
new row for relation "people" violates check constraint "users must be at least 18 years old"
DETAIL:  Failing row contains (Gizmo, 1).
```

But note that only the first constraint violated is reported. So given:

```diff
- "insert into people (name, age) values ('Jo', 42)"
+ "insert into people (name, age) values ('Al', 13)"
```

Our output notes only the failure of the name-length check:

```
Caught CheckViolation:
new row for relation "people" violates check constraint "name must be more than two characters long"
DETAIL:  Failing row contains (Al, 13).
```

#til #til-sql #postgres
