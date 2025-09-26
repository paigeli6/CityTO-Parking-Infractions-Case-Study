-- hourly tickets:
select
    hour,
    count(*) as total_tickets
from
    parking_tickets
where
    time_of_infraction < 2360
group by
    hour
order by
    total_tickets DESC;

--weekday tickets:
select
    weekday,
    count(*) as total_tickets
from
    parking_tickets
group by
    weekday
order by
    total_tickets DESC;

-- tickets by year month, ordered total_tickets DESC:
select
    year,
    month,
    count(*) as total_tickets
from
    parking_tickets
group by
    year,
    month
order by
    total_tickets DESC;

-- tickets by year month, ordered year month:
select
    year,
    month,
    count(*) as total_tickets
from
    parking_tickets
group by
    year,
    month
order by
    year,
    month;

-- tickets by location2 streetname only, with total tickets and revenue at each street, ordered by 
-- total_tickets
select
    location2,
    count(*) as total_tickets,
    sum(set_fine_amount) as total_revenue
from
    parking_tickets
group by
    location2
order by
    total_tickets DESC;

-- tickets by location2, with total_tickets, total revenue, avg fine, infraction code and description, 
-- ordered by total revenue. 
select
    location2,
    count(*) as total_tickets,
    sum(set_fine_amount) as total_revenue,
    round(Avg(set_fine_amount), 2) as avg_fine,
    infraction_code,
    infraction_description
from
    parking_tickets
group by
    location2,
    infraction_code,
    infraction_description
order by
    total_revenue DESC;

select
    location2,
    count(*) as total_tickets,
    sum(set_fine_amount) as total_revenue,
    set_fine_amount,
    infraction_code,
    infraction_description
from
    parking_tickets
group by
    location2,
    set_fine_amount,
    infraction_code,
    infraction_description
order by
    total_revenue DESC;

SELECT
    location2,
    COUNT(*) AS total_tickets,
    SUM(set_fine_amount) AS total_revenue
FROM
    parking_tickets
GROUP BY
    location2
ORDER BY
    total_revenue DESC
LIMIT
    20;

-- 4700 KEELE ST infraction code 3, total tickets and revenue, ordered by year
WITH
    years AS (
        SELECT
            generate_series (2017, 2024) AS year
    ),
    tickets AS (
        SELECT
            year,
            COUNT(*) AS total_tickets,
            SUM(set_fine_amount) AS total_revenue
        FROM
            parking_tickets
        WHERE
            location2 = '4700 KEELE ST'
            AND infraction_code = 3
        GROUP BY
            year
    )
SELECT
    y.year,
    COALESCE(t.total_tickets, 0) AS total_tickets,
    COALESCE(t.total_revenue, 0) AS total_revenue
FROM
    years y
    LEFT JOIN tickets t ON y.year = t.year
ORDER BY
    y.year;

-- top 20 locations by year for total rev
WITH
    top_streets AS (
        select
            location2 as street
        from
            parking_tickets
        group by
            location2
        order by
            sum(set_fine_amount) desc
        limit
            20
    ),
    years as (
        select
            generate_series (2017, 2024) as year
    ),
    revenue_per_year as (
        select
            year,
            location2 as street,
            sum(set_fine_amount) as total_revenue
        from
            parking_tickets
        where
            location2 in (
                select
                    street
                from
                    top_streets
            )
        group by
            year,
            street
    )
select
    y.year,
    t.street,
    coalesce(r.total_revenue, 0) as total_revenue
from
    top_Streets t
    cross join years y
    left join revenue_per_year r on r.street = t.street
    and r.year = y.year
order by
    t.street,
    y.year;

SELECT
    infraction_code,
    infraction_description,
    COUNT(*) AS count_per_type,
    sum(set_fine_amount) as total_revenue
FROM
    parking_tickets
GROUP BY
    infraction_code,
    infraction_Description
ORDER BY
    total_revenue DESC;

-- tickets by hour by location2 ordered tickets desc
WITH
    top_locations AS (
        SELECT
            location2
        FROM
            parking_tickets
        GROUP BY
            location2
        ORDER BY
            COUNT(*) DESC
        LIMIT
            5
    )
SELECT
    location2,
    hour,
    COUNT(*) AS tickets
FROM
    parking_tickets
WHERE
    location2 IN (
        SELECT
            location2
        FROM
            top_locations
    )
GROUP BY
    location2,
    hour
ORDER BY
    location2,
    tickets desc,
    hour;

-- tickets by month by location2 ordered tickets decs
WITH
    top_locations AS (
        SELECT
            location2
        FROM
            parking_tickets
        GROUP BY
            location2
        ORDER BY
            COUNT(*) DESC
        LIMIT
            5
    )
SELECT
    location2,
    month,
    COUNT(*) AS monthly_tickets
FROM
    parking_tickets
WHERE
    location2 IN (
        SELECT
            location2
        FROM
            top_locations
    )
GROUP BY
    location2,
    month
ORDER BY
    location2,
    monthly_tickets desc,
    month;

-- diversity of infraction types at location, sorted num infractions desc
SELECT
    location2,
    COUNT(DISTINCT infraction_code) AS unique_infrac
FROM
    parking_tickets
GROUP BY
    location2
ORDER BY
    unique_infrac DESC
LIMIT
    20;

-- unique infractions by year
select
    year,
    count(distinct infraction_code) as unique_infrac
from
    parking_tickets
group by
    year
order by
    year;

-- violation type trends over time:
select
    year,
    infraction_code,
    count(*) as num_tickets
from
    parking_tickets
group by
    year,
    infraction_code
order by
    infraction_code,
    year;

-- infraction code total tickets and revenue, ordered by total rev desc
SELECT
    infraction_code,
    COUNT(*) AS total_tickets,
    SUM(set_fine_amount) AS total_revenue,
    AVG(set_fine_amount) AS avg_fine
FROM
    parking_tickets
GROUP BY
    infraction_code
ORDER BY
    total_revenue DESC;

-- violation type and location
SELECT
    location2 AS street,
    infraction_code,
    COUNT(*) AS num_tickets,
    SUM(set_fine_amount) AS total_revenue
FROM
    parking_tickets
GROUP BY
    location2,
    infraction_code
ORDER BY
    location2,
    num_tickets DESC;