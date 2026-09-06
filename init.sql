CREATE TABLE IF NOT EXISTS accounts (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  balance NUMERIC(12, 2) NOT NULL DEFAULT 0
);

INSERT INTO accounts (name, balance) VALUES
  ('王小明', 15000.00),
  ('陳大華', 82300.50),
  ('林美玲', 4200.75);
