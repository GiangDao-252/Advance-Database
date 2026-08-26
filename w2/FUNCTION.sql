--EX 1:

DROP FUNCTION IF EXISTS get_customer_fullname(INT);

CREATE FUNCTION get_customer_fullname(p_customer_id INT)
RETURNS TEXT AS $$
DECLARE
	v_fullname TEXT;
BEGIN 
	SELECT first_name ||' '|| last_name INTO v_fullname
	FROM customer
	WHERE customer_id = p_customer_id;
	RETURN v_fullname;
END;
$$ LANGUAGE plpgsql;

SELECT get_customer_fullname(1);

--EX 2:

DROP FUNCTION IF EXISTS get_films_by_categoy(TEXT);

CREATE FUNCTION get_films_category(p_category_name TEXT)
RETURNS TABLE(
	film_id INT,
	title VARCHAR,
	release_year INT,
	rental_rate NUMERIC
) AS $$
BEGIN
	RETURN QUERY
	SELECT
		f.film_id::INT,
		f.title::VARCHAR,
		f.release_year::INT,
		f.rental_rate::NUMERIC
	FROM film f
	JOIN film_category fc ON f.film_id =fc.film_id
	JOIN category c ON fc.category_id = c.category_id
	WHERE c.name= p_category_name;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_films_category('Action')

-- EX 3:
DROP FUNCTION IF EXISTS calculate_rental_duration(INT);

CREATE FUNCTION calculate_rental_duration(p_rental_id INT)
RETURNS INT AS $$
DECLARE 
	v_duration INT;
BEGIN
	SELECT
		DATE_PART ('day', COALESCE(return_date, CURRENT_DATE) - rental_date)::INT
		INTO v_duration
	FROM rental
	WHERE rental_id=p_rental_id;
	RETURN v_duration;
END;
$$ LANGUAGE plpgsql;

SELECT calculate_rental_duration(1)

--EX 4:
DROP FUNCTION IF EXISTS get_customer_total_payment(INT);

CREATE FUNCTION get_customer_total_payment(p_customer_id INT)
RETURNS NUMERIC AS $$
DECLARE 
	v_total_payment NUMERIC;
BEGIN
	SELECT COALESCE(SUM(amount),0) INTO v_total_payment
	FROM payment
	WHERE customer_id = p_customer_id;
	RETURN v_total_payment;
END;
$$ LANGUAGE plpgsql;

SELECT get_customer_total_payment(2)

--EX 5:
DROP FUNCTION IF EXISTS get_top_customers(INT);

CREATE FUNCTION get_top_customers(p_limit INT)
RETURNS TABLE(
	customer_id INT,
	full_name TEXT,
	total_payment NUMERIC
) AS $$
BEGIN 
	RETURN QUERY
	SELECT 
		c.customer_id::INT,
		(c.first_name || ' ' || c.last_name)::TEXT,
		SUM(p.amount)::NUMERIC
	FROM customer c
	JOIN payment p ON c.customer_id = p.customer_id
	GROUP BY
		c.customer_id,
		c.first_name,
		c.last_name
	ORDER BY 
		SUM(p.amount) DESC
	LIMIT p_limit;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM get_top_customers(10);