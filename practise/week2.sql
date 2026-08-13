-- ========================================
-- НЕДЕЛЯ 2: Фильтрация и сортировка данных
-- ========================================

-- Схема базы данных интернет-магазина (см. week1.sql)
-- Таблицы: customers, categories, products, orders, order_items

-- ========================================
-- ПРАКТИЧЕСКИЕ ЗАДАНИЯ
-- ========================================

-- Задание 1: Найти все товары, названия которых содержат слово "телефон" или "смартфон"
SELECT product_id, product_name, price
FROM products
WHERE product_name LIKE '%телефон%'
   OR product_name LIKE '%смартфон%';

-- Задание 2: Получить уникальные города клиентов, которые совершили заказы в последние 30 дней
SELECT DISTINCT c.city
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL 30 DAY;

-- Задание 3: Показать 10 самых дорогих товаров в категории "Электроника"
SELECT p.product_id, p.product_name, p.price
FROM products p
JOIN categories c ON p.category_id = c.category_id
WHERE c.category_name = 'Электроника'
ORDER BY p.price DESC
LIMIT 10;
