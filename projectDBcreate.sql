-- 1. Person Table
CREATE TABLE DB1mnr_Person (
    email VARCHAR2(100) not null,
    phone VARCHAR2(20) not null,
    DOB DATE,
    first_name VARCHAR2(50) not null,
    last_name VARCHAR2(50) not null,
    gender CHAR(1) check (gender in ('M','F','O')),
    primary key(email),
    unique(phone)
);

-- 2. Person Address Table
CREATE TABLE DB1mnr_person_Address(
    email VARCHAR2(100) not null,
    city VARCHAR2(100),
    zip VARCHAR2(20),
    primary key(email),
    foreign key(email) references DB1mnr_Person(email) on delete cascade
);

-- 3. Employee Table
CREATE TABLE DB1mnr_Employee (
    email VARCHAR2(100) not null,
    ssn VARCHAR2(20) not null,
    salary NUMBER(10,2),
    start_date DATE,
    designation VARCHAR2(100),
    primary key(ssn),
    foreign key(email) references DB1mnr_Person(email) on delete cascade,
    unique(email)
);

-- 4. Customer Table
CREATE TABLE DB1mnr_Customer (
    email VARCHAR2(100) not null,
    cust_id NUMBER not null,
    primary key(cust_id),
    foreign key (email) references DB1mnr_Person(email) on delete cascade,
    unique(email)
);

-- 5. Match Table
CREATE TABLE DB1mnr_Match (
    match_id NUMBER not null,
    league VARCHAR2(100),
    match_date DATE,
    primary key(match_id)
);

-- 6. Booking Table
CREATE TABLE DB1mnr_Booking (
    booking_id NUMBER not null,
    cust_id NUMBER,
    match_id NUMBER,
    stand VARCHAR2(50),
    seat_no NUMBER,
    price NUMBER(10, 2),
    booking_mode VARCHAR2(50) check (booking_mode in ('Online','Offline')),
    primary key(booking_id),
    foreign key (cust_id) references DB1mnr_Customer(cust_id) on delete cascade,
    foreign key (match_id) references DB1mnr_Match(match_id) on delete cascade
);

-- 7. Match_teams Table
CREATE TABLE DB1mnr_Match_teams (
    match_id NUMBER not null,
    team1 VARCHAR2(100) not null,
    team2 VARCHAR2(100) not null,
    primary key (match_id, team1, team2),
    foreign key (match_id) references DB1mnr_Match(match_id) on delete cascade
);

-- 8. Items Table
CREATE TABLE DB1mnr_Items (
    item_id NUMBER not null,
    item_name VARCHAR2(100),
    price NUMBER(10, 2),
    primary key(item_id), 
    unique(item_name)
);

-- 9. Food_and_beverages Table
CREATE TABLE DB1mnr_Food_and_beverages (
    cust_id NUMBER,
    order_id NUMBER not null,
    item_id NUMBER,
    match_id NUMBER,
    quantity NUMBER,
    total_price NUMBER(10, 2),
    primary key (order_id),
    foreign key (cust_id) REFERENCES DB1mnr_Customer(cust_id) on delete cascade,
    foreign key (item_id) REFERENCES DB1mnr_Items(item_id) on delete cascade,
    foreign key (match_id) REFERENCES DB1mnr_Match(match_id) on delete cascade
);

-- 10. Parking Table
CREATE TABLE DB1mnr_Parking (
    cust_id NUMBER,
    vehicle_no VARCHAR2(20) not null,
    match_id NUMBER,
    price NUMBER(5, 2),
    vehicle_type VARCHAR2(50) check (vehicle_type in ('2-wheel','4-wheel')),
    in_time TIMESTAMP,
    out_time TIMESTAMP,
    primary key (vehicle_no,match_id),
    foreign key (cust_id) references DB1mnr_Customer(cust_id) on delete cascade,
    foreign key (match_id) references DB1mnr_Match(match_id) on delete cascade
);

-- 11. Vendors Table
CREATE TABLE DB1mnr_Vendors (
    vendor_id NUMBER not null,
    match_id NUMBER,
    name VARCHAR2(100),
    vendor_type VARCHAR2(50),
    cost NUMBER(10, 2),
    primary key (vendor_id),
    foreign key (match_id) references DB1mnr_Match(match_id) on delete cascade
);

