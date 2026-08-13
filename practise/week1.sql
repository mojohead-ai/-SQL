-- ========================================
-- НЕДЕЛЯ 1: Основы SQL - SELECT, WHERE
-- ========================================

-- Схема базы данных интернет-магазина
-- 
-- Таблица: customers (клиенты)
-- - customer_id (INT, PRIMARY KEY) - уникальный идентификатор клиента
-- - first_name (VARCHAR(50)) - имя клиента  
-- - last_name (VARCHAR(50)) - фамилия клиента
-- - email (VARCHAR(100)) - email адрес
-- - phone (VARCHAR(20)) - номер телефона
-- - city (VARCHAR(50)) - город проживания
--
-- Таблица: categories (категории товаров)
-- - category_id (INT, PRIMARY KEY) - уникальный идентификатор категории
-- - category_name (VARCHAR(100)) - название категории
--
-- Таблица: products (товары)
-- - product_id (INT, PRIMARY KEY) - уникальный идентификатор товара
-- - product_name (VARCHAR(200)) - название товара
-- - category_id (INT, FOREIGN KEY) - ссылка на категорию
-- - price (DECIMAL(10,2)) - цена товара
-- - stock (INT) - количество на складе
--
-- Таблица: orders (заказы)
-- - order_id (INT, PRIMARY KEY) - уникальный идентификатор заказа
-- - customer_id (INT, FOREIGN KEY) - ссылка на клиента
-- - order_date (DATE) - дата заказа
-- - total_amount (DECIMAL(10,2)) - общая сумма заказа
--
-- Таблица: order_items (позиции заказа)
-- - order_item_id (INT, PRIMARY KEY) - уникальный идентификатор позиции
-- - order_id (INT, FOREIGN KEY) - ссылка на заказ
-- - product_id (INT, FOREIGN KEY) - ссылка на товар
-- - quantity (INT) - количество товара
-- - price (DECIMAL(10,2)) - цена за единицу товара в заказе

-- ========================================
-- ПРАКТИЧЕСКИЕ ЗАДАНИЯ
-- ========================================

-- Задание 1: Выбрать всех клиентов из города "Москва"
SELECT customer_id, first_name, last_name, email, phone
FROM customers
WHERE city = 'Москва';

-- Задание 2: Найти все товары с ценой больше 1000 рублей
SELECT product_id, product_name, price, stock
FROM products
WHERE price > 1000;

-- Задание 3: Выбрать заказы, сделанные после 1 января 2024 года
SELECT order_id, customer_id, order_date, total_amount
FROM orders
WHERE order_date > '2024-01-01';