CREATE INDEX idx_order_product_fk_product_order ON order_product(product_id, order_id);
CREATE INDEX idx_orders_pk ON orders(id);
CREATE INDEX idx_product_pk ON product(id);
