-- ========================================
-- НЕДЕЛЯ 6: Оконные функции
-- ========================================

-- Схема базы данных интернет-магазина (см. week1.sql)
-- Таблицы: customers, categories, products, orders, order_items

-- ========================================
-- ПРАКТИЧЕСКИЕ ЗАДАНИЯ
-- ========================================

-- Задание 1: Создать рейтинг товаров по продажам внутри каждой категории
SELECT p.product_id,
       p.product_name,
       c.category_name,
       SUM(oi.quantity) AS total_sold,
       ROW_NUMBER() OVER (PARTITION BY c.category_id ORDER BY SUM(oi.quantity) DESC) AS rank_in_category
FROM products p
JOIN categories c ON p.category_id = c.category_id
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, c.category_id, c.category_name
ORDER BY c.category_name, rank_in_category;

-- Задание 2: Показать ежемесячную выручку с накопительным итогом
SELECT EXTRACT(YEAR FROM order_date) AS order_year,
       EXTRACT(MONTH FROM order_date) AS order_month,
       SUM(total_amount) AS monthly_revenue,
       SUM(SUM(total_amount)) OVER (ORDER BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)) AS cumulative_revenue
FROM orders
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY order_year, order_month;

-- Задание 3: Сравнить продажи текущего месяца с предыдущим для каждого товара
WITH monthly_sales AS (
    SELECT p.product_id,
           p.product_name,
           EXTRACT(YEAR FROM o.order_date) AS order_year,
           EXTRACT(MONTH FROM o.order_date) AS order_month,
           SUM(oi.quantity) AS total_sold
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY p.product_id, p.product_name, EXTRACT(YEAR FROM o.order_date), EXTRACT(MONTH FROM o.order_date)
)
SELECT product_id,
       product_name,
       order_year,
       order_month,
       total_sold,
       LAG(total_sold) OVER (PARTITION BY product_id ORDER BY order_year, order_month) AS prev_month_sold
FROM monthly_sales
ORDER BY product_id, order_year, order_month;
