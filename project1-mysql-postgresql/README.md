# Project 1 — Practical Build: PostgreSQL → MySQL

A hands-on implementation of the coffee shop database: from raw source data to a normalized schema in PostgreSQL, with reporting objects exported and migrated into MySQL for two external partners.

## Workflow

### 1. Identify entities & attributes
Reviewed sample data from five source systems (staff spreadsheet, outlet spreadsheet, POS sales CSV, CRM customer CSV, supplier product spreadsheet) to identify the entities and attributes needed for the schema.

<img src="./screenshots/01-entities-identified.png" width="500" alt="Entities identified from source data">
<img src="./screenshots/02-sales-transaction-attributes.png" width="500" alt="Sales transaction attributes identified">

### 2. Build the initial ERD
Created a new `COFFEE` database in pgAdmin and modeled the `sales_transaction` and `product` tables in the ERD tool, choosing data types and naming conventions valid across RDBMS.

<img src="./screenshots/03a-erd-sales-transaction-table.png" width="500" alt="ERD with sales_transaction table">
<img src="./screenshots/03b-erd-product-table.png" width="500" alt="ERD with product table">

### 3. Normalize to 2NF
Split repeating groups out of `sales_transaction` into a new `sales_detail` table, and separated redundant category/type data out of `product` into a new `product_type` table.

<img src="./screenshots/04a-erd-normalized-sales-detail.png" width="500" alt="ERD after normalizing sales_detail">
<img src="./screenshots/04b-erd-normalized-product-type.png" width="500" alt="ERD after normalizing product_type">

### 4. Define keys & relationships
Assigned primary keys to every table, then defined the relationships between `sales_detail` ↔ `sales_transaction`, `sales_detail` ↔ `product`, and `product` ↔ `product_type`.

<img src="./screenshots/05a-erd-primary-keys.png" width="500" alt="ERD with primary keys">
<img src="./screenshots/05b-erd-relationships.png" width="500" alt="ERD with relationships defined">

### 5. Generate schema & load data
Generated the SQL script from the finished ERD, ran it to create the schema, and loaded the sample dataset.

<img src="./screenshots/06a-schema-created-tables.png" width="500" alt="Tables created in COFFEE database">
<img src="./screenshots/06b-sales-detail-query-output.png" width="500" alt="sales_detail query output after data load">

### 6. Create reporting objects
Built a **view** (`staff_locations_view`) for the external payroll company, excluding the CEO/CFO, and a **materialized view** (`product_info_m-view`) for a marketing consultant, joining product and category data. Exported both to CSV.

<img src="./screenshots/07-staff-locations-view.png" width="500" alt="staff_locations_view output">
<img src="./screenshots/08-product-info-materialized-view.png" width="500" alt="product_info_m-view output">

### 7. Migrate to MySQL
Imported the two exported CSVs into a MySQL instance via phpMyAdmin, one database per partner (`STAFF_LOCATIONS` and `coffee_shop_products`), simulating handoff to external systems.

<img src="./screenshots/09-mysql-staff-locations-import.png" width="500" alt="Staff locations imported into MySQL">
<img src="./screenshots/10-mysql-coffee-shop-products-import.png" width="500" alt="Product data imported into MySQL">

---
[← Back to main README](../README.md)
