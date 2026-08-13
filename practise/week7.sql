-- ========================================
-- НЕДЕЛЯ 7: Модификация данных и транзакции
-- ========================================

-- Схема базы данных интернет-магазина (см. week1.sql)
-- Таблицы: customers, categories, products, orders, order_items

-- ========================================
-- ПРАКТИЧЕСКИЕ ЗАДАНИЯ
-- ========================================

-- Задание 1: Добавить новые товары и обновить цены существующих
-- Добавляем новый товар в категорию "Электроника"
INSERT INTO products (product_name, category_id, price, stock)
VALUES ('Смарт-часы X200', 1, 4999.00, 25);

-- Обновляем цену товара (например, повышаем цену на 10% для всех товаров дешевле 1000)
UPDATE products
SET price = price * 1.10
WHERE price < 1000;

-- Задание 2: Создать новый заказ с несколькими позициями в транзакции
BEGIN TRANSACTION;

-- Создаём заказ для клиента
INSERT INTO orders (customer_id, order_date, total_amount)
VALUES (1, CURRENT_DATE, 0);

-- Получаем ID созданного заказа
SET @new_order_id = LAST_INSERT_ID();

-- Добавляем позиции заказа
INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (@new_order_id, 1, 2, 4999.00);

INSERT INTO order_items (order_id, product_id, quantity, price)
VALUES (@new_order_id, 2, 1, 999.00);

-- Обновляем общую сумму заказа
UPDATE orders
SET total_amount = (
    SELECT SUM(quantity * price)
    FROM order_items
    WHERE order_id = @new_order_id
)
WHERE order_id = @new_order_id;

COMMIT;

-- Если что-то пошло не так: ROLLBACK;

-- Задание 3: Перенести старые заказы в архивную таблицу
-- Создаём архивную таблицу
CREATE TABLE IF NOT EXISTS orders_archive (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2)
);

-- Копируем заказы старше 1 года в архив
INSERT INTO orders_archive (order_id, customer_id, order_date, total_amount)
SELECT order_id, customer_id, order_date, total_amount
FROM orders
WHERE order_date < CURRENT_DATE - INTERVAL 1 YEAR;

-- Удаляем их из основной таблицы (в транзакции для безопасности)
BEGIN TRANSACTION;

DELETE FROM order_items
WHERE order_id IN (
    SELECT order_id FROM orders WHERE order_date < CURRENT_DATE - INTERVAL 1 YEAR
);

DELETE FROM orders
WHERE order_date < CURRENT_DATE - INTERVAL 1 YEAR;

COMMIT;
