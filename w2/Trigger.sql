--EX 1:
CREATE OR REPLACE FUNCTION fn_set_rental_date()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.rental_date IS NULL THEN
        NEW.rental_date = CURRENT_TIMESTAMP;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_set_rental_date ON rental;

CREATE TRIGG

-- BƯỚC 2: Tạo Trigger gắn vào bảng
-- Xóa trigger cũ nếu đã tồn tại để tránh lỗi
DROP TRIGGER IF EXISTS trg_set_rental_date ON rental;

CREATE TRIGGER trg_set_rental_date
BEFORE INSERT ON rental
FOR EACH ROW
EXECUTE FUNCTION fn_set_rental_date()