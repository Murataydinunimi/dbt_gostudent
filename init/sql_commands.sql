CREATE SCHEMA IF NOT EXISTS raw;


CREATE TABLE raw.call_dataset (
    contact_id BIGINT PRIMARY KEY,
    trial_booked BOOLEAN,
    trial_date DATE,
    call_attempts INT,
    total_call_duration DECIMAL,
    calls_30 INT
);


CREATE TABLE raw.clv_dataset (
    contract_length INTEGER NOT NULL,
    avg_clv NUMERIC(10, 2) NOT NULL
);

CREATE TABLE raw.customer_dataset (
    contact_id BIGINT PRIMARY KEY,
    customer_date DATE NOT NULL,
    contract_length INTEGER NOT NULL
);


CREATE TABLE raw.lead_dataset (
    contact_id BIGINT PRIMARY KEY,
    marketing_source VARCHAR(50) NOT NULL,
    create_date DATE NOT NULL,
    known_city BOOLEAN NOT NULL,
    message_length INTEGER NOT NULL,
    test_flag BOOLEAN
);


CREATE TABLE raw.marketing_costs_dataset (
    date DATE NOT NULL,
    marketing_source VARCHAR(50) NOT NULL,
    marketing_costs NUMERIC(15, 5) NOT NULL
);


CREATE TABLE raw.sales_cost_dataset (
    month VARCHAR(7) NOT NULL,
    total_sales_costs NUMERIC(15, 2) NOT NULL,
    trial_costs NUMERIC(15, 2) NOT NULL
);
