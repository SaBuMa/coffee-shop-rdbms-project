-- =========================================================
-- VIEW: STAFF LOCATIONS
-- Lists staff and the outlet they work at (payroll company use)
-- =========================================================
CREATE VIEW public.staff_locations_view AS
SELECT
    s.staff_id,
    CONCAT(s.first_name, ' ', s.last_name) AS staff_name,
    so.sales_outlet_name AS location_name,
    so.address,
    so.city
FROM public.staff AS s
INNER JOIN public.sales_outlet AS so
    ON s.sales_outlet_id = so.sales_outlet_id;

-- =========================================================
-- MATERIALIZED VIEW: PRODUCT INFORMATION
-- Product catalog with category/type (marketing consultant use)
-- =========================================================
CREATE MATERIALIZED VIEW public.product_info_mview AS
SELECT
    p.product_id,
    p.product_name,
    pt.product_category,
    pt.product_type,
    p.price
FROM public.product AS p
INNER JOIN public.product_type AS pt
    ON p.product_type_id = pt.product_type_id;

-- Refresh whenever underlying product data changes:
-- REFRESH MATERIALIZED VIEW public.product_info_mview;
