# Project 2 — Design Document & SQL

![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat&logo=postgresql&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-3NF%20Schema-informational)

**Purpose:** Design a relational database for a coffee shop sales system, normalize it, define keys and relationships, and implement it in SQL.

**Scenario:** A coffee shop needs a database to track sales receipts (transactions), the items purchased on each receipt (line items), product information (including category/type), and staff working at store locations.

## Section 1 — Entities & Business Rules

**Entities:** `staff`, `sales_outlet`, `sales_transaction`, `sales_detail`, `product`, `product_type`, `customer`

**Business rules:**
1. Each sales transaction must be associated with exactly one staff member and one sales outlet.
2. Each sales detail record must reference exactly one sales transaction and exactly one product.
3. A sales transaction can contain multiple sales detail records, allowing a receipt to contain multiple products.
4. Each product belongs to exactly one product type, while a product type can contain multiple products.
5. Each staff member is assigned to one sales outlet, while a sales outlet can have multiple staff members.

## Section 2 — Normalized Logical Schema (3NF)

| Table | Primary Key | Foreign Keys |
|---|---|---|
| `sales_outlet` | `sales_outlet_id` | — |
| `staff` | `staff_id` | `sales_outlet_id` → `sales_outlet` |
| `customer` | `customer_id` | — |
| `product_type` | `product_type_id` | — |
| `product` | `product_id` | `product_type_id` → `product_type` |
| `sales_transaction` | `transaction_id` | `sales_outlet_id` → `sales_outlet`, `staff_id` → `staff`, `customer_id` → `customer` |
| `sales_detail` | `sales_detail_id` | `transaction_id` → `sales_transaction`, `product_id` → `product` |

Full column-level definitions (data types and constraints) are in [`schema.sql`](./schema.sql).

## Section 3 — Relationship Definitions

- **sales_transaction → sales_detail** (1:N) — one transaction can contain multiple line items; each line item belongs to exactly one transaction. FK: `sales_detail.transaction_id → sales_transaction.transaction_id`
- **product → sales_detail** (1:N) — one product can appear in many line items; each line item references exactly one product. FK: `sales_detail.product_id → product.product_id`
- **product_type → product** (1:N) — one product type can contain multiple products; each product belongs to one type. FK: `product.product_type_id → product_type.product_type_id`
- **staff → sales_outlet** (N:1) — multiple staff can work at the same outlet; each staff member is assigned to one outlet. FK: `staff.sales_outlet_id → sales_outlet.sales_outlet_id`

## Section 4 — SQL Implementation

- [`schema.sql`](./schema.sql) — all `CREATE TABLE` statements with PK/FK/CHECK constraints
- [`views.sql`](./views.sql) — `staff_locations_view` (view) and `product_info_mview` (materialized view)

**Normalization choice:** Product category and type information is stored separately in the `product_type` table instead of being repeated in every product record. This reduces redundant data and ensures that changes to a product category or type only need to be made in one location, supporting a 3NF design.

**Integrity constraint:** The `sales_detail.quantity` column uses a `CHECK (quantity > 0)` constraint to prevent invalid sales records containing zero or negative quantities. Foreign key constraints are also used throughout the schema to ensure that sales details, products, staff, customers, and locations reference valid records.

---
[← Back to main README](../README.md)
