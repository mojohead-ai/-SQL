-- ========================================
-- НЕДЕЛЯ 8: Индексы и оптимизация
-- ========================================

-- Схема базы данных интернет-магазина (см. week1.sql)
-- Таблицы: customers, categories, products, orders, order_items

-- ========================================
-- ПРАКТИЧЕСКИЕ ЗАДАНИЯ
-- ========================================

-- Задание 1: Найти медленные запросы и создать необходимые индексы
-- Типовой "медленный" запрос: поиск заказов конкретного клиента за период
EXPLAIN SELECT *
FROM orders
WHERE customer_id = 42
  AND order_date BETWEEN '2024-01-01' AND '2024-12-31';

-- Оптимизация: создаём составной индекс (клиент + дата) под этот запрос
CREATE INDEX idx_orders_customer_date ON orders (customer_id, order_date);

-- Дополнительно индексируем внешние ключи, используемые в JOIN
CREATE INDEX idx_order_items_order_id ON order_items (order_id);
CREATE INDEX idx_order_items_product_id ON order_items (product_id);
CREATE INDEX idx_products_category_id ON products (category_id);

-- Проверяем план после создания индексов
EXPLAIN SELECT *
FROM orders
WHERE customer_id = 42
  AND order_date BETWEEN '2024-01-01' AND '2024-12-31';

-- Задание 2: Переписать сложный запрос для улучшения производительности
-- "До": подзапрос в WHERE выполняется для каждой строки
SELECT p.product_id, p.product_name, p.price
FROM products p
WHERE p.price > (
    SELECT AVG(p2.price)
    FROM products p2
    WHERE p2.category_id = p.category_id
);

-- "После": вычисляем среднее один раз через JOIN с агрегатом
SELECT p.product_id, p.product_name, p.price
FROM products p
JOIN (
    SELECT category_id, AVG(price) AS avg_price
    FROM products
    GROUP BY category_id
) cat_avg ON p.category_id = cat_avg.category_id
WHERE p.price > cat_avg.avg_price;

-- Задание 3: Создать запросы для контроля производительности базы данных
-- Топ-10 товаров по количеству проданных единиц (для контроля спроса)
SELECT p.product_id, p.product_name, SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_sold DESC
LIMIT 10;

-- Товары, которых почти нет на складе (риск дефицита)
SELECT product_id, product_name, stock
FROM products
WHERE stock < 5
ORDER BY stock ASC;
