--Find the viewers, broken down by age group and gender, attended matches in a specific league and from different cities did these viewers come
SELECT 
    M.league,
    '26-35' AS age_group,
    P.gender,
    COUNT(*) AS audience_count,
    COUNT(DISTINCT PA.city) AS cities_visited  -- Referencing city from the Person_Address table
FROM 
    DB1mnr_Person P
JOIN 
    DB1mnr_Customer C ON P.email = C.email
JOIN 
    DB1mnr_Booking B ON C.cust_id = B.cust_id
JOIN 
    DB1mnr_Match M ON B.match_id = M.match_id
JOIN 
    DB1mnr_Person_Address PA ON P.email = PA.email  -- Added join with the Person_Address table
GROUP BY 
    M.league, P.gender
HAVING 
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MIN(P.DOB)) BETWEEN 26 AND 35
UNION ALL
SELECT 
    M.league,
    '36+' AS age_group,
    P.gender,
    COUNT(*) AS audience_count,
    COUNT(DISTINCT PA.city) AS cities_visited  -- Referencing city from the Person_Address table
FROM 
    DB1mnr_Person P
JOIN 
    DB1mnr_Customer C ON P.email = C.email
JOIN 
    DB1mnr_Booking B ON C.cust_id = B.cust_id
JOIN 
    DB1mnr_Match M ON B.match_id = M.match_id
JOIN 
    DB1mnr_Person_Address PA ON P.email = PA.email  -- Added join with the Person_Address table
GROUP BY 
    M.league, P.gender
HAVING 
    EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM MIN(P.DOB)) > 35
ORDER BY 
    league, age_group, gender;
        
-- Find out the matches in each league had more than one unique audience member and the total audience members attended each
SELECT 
    M.league,
    M.match_id,
    COUNT(DISTINCT B.cust_id) AS total_audience
FROM 
    DB1mnr_Booking B
JOIN 
    DB1mnr_Match M ON B.match_id = M.match_id
GROUP BY 
    M.league, M.match_id
HAVING 
    COUNT(DISTINCT B.cust_id) > 1  -- Example threshold for more audience
ORDER BY 
    total_audience DESC;
    
    
 -- Find out employee designations have more than five staff members and the number of employees are in each of those roles
SELECT 
    E.designation,
    COUNT(*) AS employee_count
FROM 
    DB1mnr_Employee E
GROUP BY 
    E.designation
HAVING 
    COUNT(*) > 5 -- Example threshold for larger staff roles
ORDER BY 
    employee_count DESC;
    
-- Find out the food and beverage items that generated less than $20 in total sales and the total quantity sold for each of these items
SELECT 
    I.item_name,
    SUM(F.quantity) AS total_quantity_sold,
    SUM(F.total_price) AS total_sales
FROM 
    DB1mnr_Food_and_beverages F
JOIN 
    DB1mnr_Items I ON F.item_id = I.item_id
GROUP BY 
    I.item_name
HAVING 
    SUM(F.total_price) < 20 -- Example threshold to indicate low sales
ORDER BY 
    total_sales DESC;

-- Find out the types of vendors that have more than 5 vendors participating and the total rent collected from each vendor type
SELECT 
    V.vendor_type,
    COUNT(V.vendor_id) AS number_of_vendors,
    SUM(V.cost) AS total_rent
FROM 
    DB1mnr_Vendors V
GROUP BY 
    V.vendor_type
HAVING 
    COUNT(V.vendor_id) > 5  -- Example threshold for vendor types in high demand
ORDER BY 
    total_rent DESC;
    
-- Find out the matches that had more than one vehicle parked and the total number of vehicles and unique vehicle types that were parked at each match
SELECT 
    M.match_id,
    COUNT(P.vehicle_no) AS vehicles_parked,
    COUNT(DISTINCT P.vehicle_type) AS types_of_vehicles
FROM 
    DB1mnr_Parking P
JOIN 
    DB1mnr_Match M ON P.match_id = M.match_id
GROUP BY 
    M.match_id
HAVING 
    COUNT(P.vehicle_no) > 1 -- Example threshold for high parking demand
ORDER BY 
    vehicles_parked DESC;
    
--Find out for each match the total number of bookings made through each booking mode and the booking modes that were most popular per match
SELECT 
    M.match_id,
    B.booking_mode AS booking_mode,
    COUNT(*) AS total_bookings
FROM 
    DB1mnr_Booking B
JOIN 
    DB1mnr_Match M ON B.match_id = M.match_id
GROUP BY 
    M.match_id, B.booking_mode
ORDER BY 
    M.match_id, total_bookings DESC;

-- Find out for each match the number of bookings were made for each seating type and the seating types that were most booked per match
SELECT 
    M.match_id,
    B.stand AS seating_type,
    COUNT(*) AS seat_type_count
FROM 
    DB1mnr_Booking B
JOIN 
    DB1mnr_Match M ON B.match_id = M.match_id
GROUP BY 
    M.match_id, B.stand
ORDER BY 
    M.match_id, seat_type_count DESC;

    
-- Find the cities from which more than 2 customers have come to see the match
SELECT pa.city,
       COUNT(DISTINCT c.cust_id) AS total_customers
FROM DB1mnr_Booking b
JOIN DB1mnr_Customer c ON b.cust_id = c.cust_id
JOIN DB1mnr_person_Address pa ON c.email = pa.email
GROUP BY pa.city
HAVING COUNT(DISTINCT c.cust_id) > 2
ORDER BY total_customers DESC;

-- Find the matches that have more than 1 tickets sold with revenue greater than 100
SELECT b.match_id,
       COUNT(b.booking_id) AS tickets_sold,
       SUM(b.price) AS total_revenue
FROM DB1mnr_Booking b
JOIN DB1mnr_Match m ON b.match_id = m.match_id
GROUP BY b.match_id
HAVING SUM(b.price) > 100 AND COUNT(b.booking_id) > 1
ORDER BY total_revenue DESC;

-- Find out the food and beverage items that are sold in each match 
SELECT fb.match_id,
       i.item_name,
       SUM(fb.quantity) AS total_quantity_sold
FROM DB1mnr_Food_and_beverages fb
JOIN DB1mnr_Items i ON fb.item_id = i.item_id
GROUP BY ROLLUP(fb.match_id, i.item_name)
HAVING (SUM(fb.quantity) > 0 AND i.item_name IS NOT NULL) OR fb.match_id IS NULL
ORDER BY fb.match_id, i.item_name;

-- Find out the food and beverage revenue by match and type
SELECT fb.match_id,
       i.item_name,
       SUM(fb.total_price) AS total_fnb_revenue
FROM DB1mnr_Food_and_beverages fb
JOIN DB1mnr_Items i ON fb.item_id = i.item_id
GROUP BY CUBE(fb.match_id, i.item_name)
HAVING (SUM(fb.total_price) > 0 AND i.item_name IS NOT NULL) OR fb.match_id IS NULL
ORDER BY fb.match_id, i.item_name;

-- Find out the vehicles parked for 1st match
SELECT 
    M.match_id,
    M.match_date,
    P.vehicle_no,
    P.vehicle_type,
    P.price,
    P.in_time,
    P.out_time,
    COUNT(P.vehicle_no) OVER (PARTITION BY M.match_id) AS total_vehicles,
    SUM(P.price) OVER (PARTITION BY M.match_id) AS total_parking_revenue,
    MIN(P.in_time) OVER (PARTITION BY M.match_id) AS earliest_parking_time,
    MAX(P.out_time) OVER (PARTITION BY M.match_id) AS latest_parking_time
FROM 
    DB1mnr_Parking P
JOIN 
    DB1mnr_Match M ON P.match_id = M.match_id
WHERE 
    M.match_id = '1'  -- Replace with the match ID you're interested in
ORDER BY 
    P.vehicle_type, P.in_time;

-- Find out the revenue generated by each booking in each league, along with the total revenue for the entire league
SELECT 
    M.league,
    M.match_id,
    M.match_date,
    B.booking_id,
    B.price,
    SUM(B.price) OVER (PARTITION BY M.league) AS total_revenue_by_league
FROM 
    DB1mnr_Booking B
JOIN 
    DB1mnr_Match M ON B.match_id = M.match_id
ORDER BY 
    total_revenue_by_league DESC, M.match_date;


--- Find out the customers that have booked tickets for all matches they attended and ordered food and beverages at each of those matches
SELECT 
    B.cust_id,
    COUNT(DISTINCT B.match_id) AS matches_booked,
    COUNT(DISTINCT F.match_id) AS matches_with_food_and_beverages
FROM 
    DB1mnr_Booking B
JOIN 
    DB1mnr_Food_and_beverages F ON B.cust_id = F.cust_id AND B.match_id = F.match_id
GROUP BY 
    B.cust_id
HAVING 
    COUNT(DISTINCT B.match_id) = (SELECT COUNT(DISTINCT match_id) 
                                   FROM DB1mnr_Booking 
                                   WHERE cust_id = B.cust_id)  -- Ensuring the customer has booked tickets for all matches
    AND 
    COUNT(DISTINCT F.match_id) = (SELECT COUNT(DISTINCT match_id) 
                                   FROM DB1mnr_Booking 
                                   WHERE cust_id = B.cust_id)  -- Ensuring the customer has ordered food for all matches booked
ORDER BY 
    B.cust_id;
   
-- Find the maximum number of match attended by any vendor
SELECT vendor_id,
       name,
       COUNT(DISTINCT match_id) AS match_count
FROM DB1mnr_Vendors
GROUP BY vendor_id, name
HAVING COUNT(DISTINCT match_id) = (
    SELECT MAX(match_count)
    FROM (
        SELECT COUNT(DISTINCT match_id) AS match_count
        FROM DB1mnr_Vendors
        GROUP BY vendor_id
    )
)
ORDER BY match_count DESC;

-- Find the customers that have booked tickets from the city 'Hyderabad'
SELECT B.booking_id,
       B.match_id,
       C.cust_id,
       PA.city
FROM DB1mnr_Booking B
JOIN DB1mnr_Customer C ON B.cust_id = C.cust_id
JOIN DB1mnr_Person_Address PA ON C.email = PA.email
WHERE PA.city LIKE 'Hyd%';

-- Find the top 10 vendors with the highest rent paid
SELECT V.vendor_id,
       V.name AS vendor_name,
       V.cost AS rent_paid,
       M.match_id,
       M.league
FROM DB1mnr_Vendors V
JOIN DB1mnr_Match M ON V.match_id = M.match_id
ORDER BY V.cost DESC
FETCH FIRST 10 ROWS ONLY;




































    






