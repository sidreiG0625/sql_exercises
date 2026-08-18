INSERT INTO Workers
(
    worker_id,
    worker_name,
    contractor_id
)
VALUES
(1, 'John', 100),
(2, 'Sarah', 100),
(3, 'Mike', 200),
(4, 'Jane', 200),
(5, 'David', 300);


INSERT INTO Contractors
(
    contractor_id,
    contractor_name
)
VALUES
(100, 'ABC Mining'),
(200, 'XYZ Resources'),
(300, 'Global Energy');

INSERT INTO Certifications
(
    cert_id,
    cert_name
)
VALUES
(10, 'First Aid'),
(20, 'Working at Heights'),
(30, 'Site Induction');

INSERT INTO Worker_Certifications
(
    worker_id,
    cert_id,
    expiry_date
)
VALUES
(1, 10, '2026-05-01'),
(1, 20, '2026-01-10'),
(2, 10, '2026-02-05'),
(2, 30, '2026-12-31'),
(3, 10, '2025-12-31'),
(4, 20, '2026-03-01'),
(5, 30, '2027-01-01');
