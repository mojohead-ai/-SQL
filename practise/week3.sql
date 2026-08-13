-- ========================================
-- НЕДЕЛЯ 3: Агрегатные функции и GROUP BY
-- ========================================

-- Схема базы данных интернет-магазина (см. week1.sql)
-- Таблицы: customers, categories, products, orders, order_items

-- ========================================
-- ПРАКТИЧЕСКИЕ ЗАДАНИЯ
-- ========================================

-- Задание 1: Подсчитать количество товаров и среднюю цену в каждой категории
SELECT c.category_name,
       COUNT(p.product_id) AS products_count,
       AVG(p.price) AS avg_price
FROM categories c
LEFT JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name;

-- Задание 2: Найти топ-5 городов по количеству активных клиентов
SELECT city, COUNT(customer_id) AS customer_count
FROM customers
GROUP BY city
ORDER BY customer_count DESC
LIMIT 5;

-- Задание 3: Рассчитать общую сумму заказов по месяцам за текущий год
SELECT EXTRACT(YEAR FROM order_date) AS order_year,
       EXTRACT(MONTH FROM order_date) AS order_month,
       SUM(total_amount) AS monthly_revenue
FROM orders
WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY order_month;
