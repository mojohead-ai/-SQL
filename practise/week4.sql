-- ========================================
-- НЕДЕЛЯ 4: Соединения таблиц (JOIN)
-- ========================================

-- Схема базы данных интернет-магазина (см. week1.sql)
-- Таблицы: customers, categories, products, orders, order_items

-- ========================================
-- ПРАКТИЧЕСКИЕ ЗАДАНИЯ
-- ========================================

-- Задание 1: Получить информацию о заказах с данными клиентов и товарами
SELECT o.order_id,
       o.order_date,
       c.first_name,
       c.last_name,
       p.product_name,
       oi.quantity,
       oi.price
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;

-- Задание 2: Показать каждого клиента с общей суммой его покупок
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       COALESCE(SUM(o.total_amount), 0) AS total_spent
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- Задание 3: Найти товары, которые ни разу не были заказаны
SELECT p.product_id, p.product_name, p.price
FROM products p
LEFT JOIN order_items oi ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;
