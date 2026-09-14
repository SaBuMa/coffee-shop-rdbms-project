BEGIN;

-- =========================================================
-- DROP EXISTING TABLES
-- =========================================================
DROP TABLE IF EXISTS public.sales_detail CASCADE;
DROP TABLE IF EXISTS public.sales_transaction CASCADE;
DROP TABLE IF EXISTS public.product CASCADE;
DROP TABLE IF EXISTS public.product_type CASCADE;
DROP TABLE IF EXISTS public.customer CASCADE;
DROP TABLE IF EXISTS public.staff CASCADE;
DROP TABLE IF EXISTS public.sales_outlet CASCADE;

-- =========================================================
-- SALES OUTLET
-- =========================================================
CREATE TABLE public.sales_outlet
(
    sales_outlet_id     INTEGER PRIMARY KEY,
    sales_outlet_name   VARCHAR(100) NOT NULL UNIQUE,
    sales_outlet_type   VARCHAR(20) NOT NULL,
    address             VARCHAR(100) NOT NULL,
    city                VARCHAR(40) NOT NULL,
    telephone           VARCHAR(15),
    postal_code         VARCHAR(10)
);

-- =========================================================
-- STAFF
-- =========================================================
CREATE TABLE public.staff
(
    staff_id            INTEGER PRIMARY KEY,
    first_name          VARCHAR(50) NOT NULL,
    last_name           VARCHAR(50) NOT NULL,
    position            VARCHAR(50) NOT NULL,
    start_date          DATE NOT NULL,
    sales_outlet_id     INTEGER NOT NULL,
    CONSTRAINT fk_staff_sales_outlet
        FOREIGN KEY (sales_outlet_id)
        REFERENCES public.sales_outlet (sales_outlet_id)
);

-- =========================================================
-- CUSTOMER
-- =========================================================
CREATE TABLE public.customer
(
    customer_id         INTEGER PRIMARY KEY,
    customer_name       VARCHAR(50) NOT NULL,
    email               VARCHAR(100) UNIQUE,
    reg_date            DATE,
    card_number         VARCHAR(15) UNIQUE,
    date_of_birth       DATE,
    gender              CHAR(1),
    CONSTRAINT chk_customer_gender
        CHECK (gender IN ('M', 'F', 'O') OR gender IS NULL)
);

-- =========================================================
-- PRODUCT TYPE
-- =========================================================
CREATE TABLE public.product_type
(
    product_type_id     INTEGER PRIMARY KEY,
    product_type        VARCHAR(50) NOT NULL,
    product_category    VARCHAR(50) NOT NULL
);

-- =========================================================
-- PRODUCT
-- =========================================================
CREATE TABLE public.product
(
    product_id          INTEGER PRIMARY KEY,
    product_name        VARCHAR(100) NOT NULL,
    description          VARCHAR(250),
    price                DECIMAL(10,2) NOT NULL,
    product_type_id     INTEGER NOT NULL,
    CONSTRAINT chk_product_price
        CHECK (price >= 0),
    CONSTRAINT fk_product_product_type
        FOREIGN KEY (product_type_id)
        REFERENCES public.product_type (product_type_id)
);

-- =========================================================
-- SALES TRANSACTION
-- =========================================================
CREATE TABLE public.sales_transaction
(
    transaction_id          INTEGER PRIMARY KEY,
    transaction_timestamp   TIMESTAMP NOT NULL,
    sales_outlet_id         INTEGER NOT NULL,
    staff_id                INTEGER NOT NULL,
    customer_id             INTEGER,
    payment_method          VARCHAR(30) NOT NULL,
    total_amount            DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_transaction_total
        CHECK (total_amount >= 0),
    CONSTRAINT fk_transaction_sales_outlet
        FOREIGN KEY (sales_outlet_id)
        REFERENCES public.sales_outlet (sales_outlet_id),
    CONSTRAINT fk_transaction_staff
        FOREIGN KEY (staff_id)
        REFERENCES public.staff (staff_id),
    CONSTRAINT fk_transaction_customer
        FOREIGN KEY (customer_id)
        REFERENCES public.customer (customer_id)
);

-- =========================================================
-- SALES DETAIL
-- =========================================================
CREATE TABLE public.sales_detail
(
    sales_detail_id     INTEGER PRIMARY KEY,
    transaction_id      INTEGER NOT NULL,
    product_id          INTEGER NOT NULL,
    quantity            INTEGER NOT NULL,
    unit_price          DECIMAL(10,2) NOT NULL,
    CONSTRAINT chk_sales_detail_quantity
        CHECK (quantity > 0),
    CONSTRAINT chk_sales_detail_unit_price
        CHECK (unit_price >= 0),
    CONSTRAINT fk_sales_detail_transaction
        FOREIGN KEY (transaction_id)
        REFERENCES public.sales_transaction (transaction_id),
    CONSTRAINT fk_sales_detail_product
        FOREIGN KEY (product_id)
        REFERENCES public.product (product_id)
);

COMMIT;
