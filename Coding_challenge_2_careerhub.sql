-- task 1: Provide a SQL script that initializes the database for the Job Board scenario “CareerHub”. 
-- task 4: Ensure the script handles potential errors, such as if the database or tables already exist.
CREATE DATABASE IF NOT EXISTS CareerHub;
USE CareerHub;

-- task 2: Create tables for Companies, Jobs, Applicants and Applications.
-- task 3: Define appropriate primary keys, foreign keys, and constraints.
CREATE TABLE Companies (
    CompanyID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyName VARCHAR(255) NOT NULL,
    Location VARCHAR(255) NOT NULL
);
CREATE TABLE Jobs (
    JobID INT PRIMARY KEY AUTO_INCREMENT,
    CompanyID INT,
    JobTitle VARCHAR(255) NOT NULL,
    JobDescription TEXT,
    JobLocation VARCHAR(255),
    Salary DECIMAL(10, 2),
    JobType VARCHAR(50),
    PostedDate DATETIME,
    FOREIGN KEY (CompanyID) REFERENCES Companies(CompanyID)
);
CREATE TABLE Applicants (
    ApplicantID INT PRIMARY KEY AUTO_INCREMENT,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(255),
    Phone VARCHAR(20),
    Resume TEXT
);
CREATE TABLE Applications (
    ApplicationID INT PRIMARY KEY AUTO_INCREMENT,
    JobID INT,
    ApplicantID INT,
    ApplicationDate DATETIME,
    CoverLetter TEXT,
    FOREIGN KEY (JobID) REFERENCES Jobs(JobID),
    FOREIGN KEY (ApplicantID) REFERENCES Applicants(ApplicantID)
);
-- Inserting data to the tables:
INSERT INTO Companies (CompanyName, Location)
VALUES 
('Tata Consultancy Services', 'Mumbai'),
('Infosys', 'Bengaluru'),
('Wipro', 'Hyderabad'),
('HCL Technologies', 'Noida'),
('Tech Mahindra', 'Pune');
INSERT INTO Jobs (CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate)
VALUES
(1, 'Software Developer', 'Develop and maintain software systems.', 'Mumbai', 700000, 'Full-time', '2024-09-15 10:30:00'),
(2, 'Data Analyst', 'Analyze data to help companies make informed decisions.', 'Bengaluru', 600000, 'Full-time', '2024-09-18 09:45:00'),
(3, 'Cloud Engineer', 'Manage and monitor cloud infrastructure.', 'Hyderabad', 800000, 'Full-time', '2024-09-20 11:00:00'),
(4, 'QA Engineer', 'Ensure software quality through testing.', 'Noida', 550000, 'Contract', '2024-09-25 12:00:00'),
(5, 'DevOps Engineer', 'Maintain CI/CD pipelines and automate processes.', 'Pune', 900000, 'Full-time', '2024-09-22 14:30:00');
INSERT INTO Applicants (FirstName, LastName, Email, Phone, Resume)
VALUES
('Arjun', 'Sharma', 'arjun.sharma@example.com', '9876543210', 'Resume for Software Developer role'),
('Sanjana', 'Rao', 'sanjana.rao@example.com', '9876512345', 'Resume for Data Analyst position'),
('Vikram', 'Singh', 'vikram.singh@example.com', '9876532109', 'Resume for Cloud Engineer position'),
('Nisha', 'Verma', 'nisha.verma@example.com', '9876567890', 'Resume for QA Engineer role'),
('Raj', 'Kapoor', 'raj.kapoor@example.com', '9876589023', 'Resume for DevOps Engineer role');
INSERT INTO Applications (JobID, ApplicantID, ApplicationDate, CoverLetter)
VALUES
(1, 1, '2024-09-16 09:00:00', 'I am interested in the Software Developer role at TCS.'),
(2, 2, '2024-09-19 10:00:00', 'I am applying for the Data Analyst role at Infosys.'),
(3, 3, '2024-09-21 13:30:00', 'I would like to apply for the Cloud Engineer position at Wipro.'),
(4, 4, '2024-09-26 11:45:00', 'I am interested in the QA Engineer role at HCL Technologies.'),
(5, 5, '2024-09-23 15:00:00', 'I am applying for the DevOps Engineer position at Tech Mahindra.');


/* task 5: Write an SQL query to count the number of applications received for each job listing in the "Jobs" table. 
Display the job title and the corresponding application count. 
Ensure that it lists all jobs, even if they have no applications. */
SELECT j.JobTitle,
       COUNT(a.ApplicationID) AS ApplicationCount
FROM Jobs j
LEFT JOIN Applications a ON j.JobID = a.JobID
GROUP BY j.JobTitle;

/* task 6: Develop an SQL query that retrieves job listings from the "Jobs" table within a specified salary 
range. Allow parameters for the minimum and maximum salary values. Display the job title, 
company name, location, and salary for each matching job.*/
SELECT j.JobTitle, 
       c.CompanyName, 
       j.JobLocation, 
       j.Salary
FROM Jobs j
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE j.Salary BETWEEN 600000 AND 800000;

/* task 7: Write an SQL query that retrieves the job application history for a specific applicant. Allow a 
parameter for the ApplicantID, and return a result set with the job titles, company names, and 
application dates for all the jobs the applicant has applied to.*/
SELECT j.JobTitle, 
       c.CompanyName, 
	   a.ApplicationDate
FROM Applications a
JOIN Jobs j ON a.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE a.ApplicantID = 1;
    
/* task 8: Create an SQL query that calculates and displays the average salary offered by all companies for 
job listings in the "Jobs" table. Ensure that the query filters out jobs with a salary of zero.*/
SELECT AVG(Salary) AS AverageSalary
FROM Jobs
WHERE Salary > 0;

/* task 9: Write an SQL query to identify the company that has posted the most job listings. Display the 
company name along with the count of job listings they have posted. Handle ties if multiple 
companies have the same maximum count. */
SELECT c.CompanyName, 
       COUNT(j.JobID) AS JobCount
FROM Jobs j
JOIN Companies c ON j.CompanyID = c.CompanyID
GROUP BY c.CompanyName
HAVING JobCount = (
        SELECT MAX(JobCount)
        FROM (
            SELECT COUNT(JobID) AS JobCount
            FROM Jobs
            GROUP BY CompanyID
        ) AS MaxJobCounts
    );
    
/* task 10: Find the applicants who have applied for positions in companies located in 'CityX' and have at 
least 3 years of experience. */
ALTER TABLE Applicants
ADD YearsOfExperience INT;
UPDATE Applicants
SET YearsOfExperience = 2 WHERE ApplicantID = 1; 
UPDATE Applicants
SET YearsOfExperience = 4 WHERE ApplicantID = 2;
UPDATE Applicants
SET YearsOfExperience = 3 WHERE ApplicantID = 3;  
UPDATE Applicants
SET YearsOfExperience = 5 WHERE ApplicantID = 4;  
UPDATE Applicants
SET YearsOfExperience = 6 WHERE ApplicantID = 5;  

SELECT a.FirstName, 
       a.LastName, 
       a.YearsOfExperience, 
       c.CompanyName, 
       c.Location
FROM Applications ap
JOIN Applicants a ON ap.ApplicantID = a.ApplicantID
JOIN Jobs j ON ap.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE c.Location = 'Pune'
AND a.YearsOfExperience >= 3;

/* task 11: Retrieve a list of distinct job titles with salaries between 600000 and $800000.*/
SELECT DISTINCT JobTitle
FROM Jobs
WHERE Salary BETWEEN 600000 AND 800000;

/* task 12: Find the jobs that have not received any applications.*/
SELECT j.JobTitle
FROM Jobs j
LEFT JOIN Applications a
ON j.JobID = a.JobID
WHERE a.ApplicationID = NULL;

/* task 13: Retrieve a list of job applicants along with the companies they have applied to and the positions 
they have applied for.*/
SELECT a.FirstName, 
       a.LastName, 
       c.CompanyName, 
       j.JobTitle
FROM Applications ap
JOIN Applicants a ON ap.ApplicantID = a.ApplicantID
JOIN Jobs j ON ap.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID;

/* task 14: Retrieve a list of companies along with the count of jobs they have posted, even if they have not 
received any applications.*/
SELECT c.CompanyName, 
       COUNT(j.JobID) AS JobCount
FROM Companies c
LEFT JOIN Jobs j ON c.CompanyID = j.CompanyID
GROUP BY c.CompanyName;

/* task 15: List all applicants along with the companies and positions they have applied for, including those 
who have not applied.*/
SELECT a.FirstName, 
       a.LastName, 
       c.CompanyName, 
       j.JobTitle
FROM Applicants a
LEFT JOIN Applications ap ON a.ApplicantID = ap.ApplicantID
LEFT JOIN Jobs j ON ap.JobID = j.JobID
LEFT JOIN Companies c ON j.CompanyID = c.CompanyID;
    
/* task 16: Find companies that have posted jobs with a salary higher than the average salary of all jobs.*/
SELECT c.CompanyName
FROM Companies c
JOIN Jobs j
ON c.CompanyID = j.CompanyID
WHERE j.Salary > (
	SELECT AVG(Salary)
    FROM Jobs
);

/* task 17: Display a list of applicants with their names and a concatenated string of their city and state.*/
ALTER TABLE Applicants
ADD COLUMN City VARCHAR(100),
ADD COLUMN State VARCHAR(100);

UPDATE Applicants 
SET City = 'Mumbai', State = 'Maharashtra' 
WHERE ApplicantID = 1;

UPDATE Applicants 
SET City = 'Bengaluru', State = 'Karnataka' 
WHERE ApplicantID = 2;

UPDATE Applicants 
SET City = 'Hyderabad', State = 'Telangana' 
WHERE ApplicantID = 3;

UPDATE Applicants 
SET City = 'Noida', State = 'Uttar Pradesh' 
WHERE ApplicantID = 4;

UPDATE Applicants 
SET City = 'Pune', State = 'Maharashtra' 
WHERE ApplicantID = 5;

SELECT CONCAT(FirstName, ' ', LastName) AS FullName,
       CONCAT(City, ', ', State) AS Location
FROM Applicants;

/* task 18: Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'.*/
SELECT JobTitle
FROM Jobs
WHERE JobTitle LIKE '%Developer%' OR JobTitle LIKE '%Engineer%';

/* task 19: Retrieve a list of applicants and the jobs they have applied for, including those who have not 
applied and jobs without applicants. */
SELECT a.FirstName, 
       a.LastName, 
       j.JobTitle
FROM Applicants a
LEFT JOIN Applications ap ON a.ApplicantID = ap.ApplicantID
LEFT JOIN Jobs j ON ap.JobID = j.JobID;

/* task 20: List all combinations of applicants and companies where the company is in a specific city and the 
applicant has more than 2 years of experience. For example: city=Chennai */
SELECT a.FirstName, 
       a.LastName, 
       c.CompanyName
FROM Applicants a
JOIN Applications ap ON a.ApplicantID = ap.ApplicantID
JOIN Jobs j ON ap.JobID = j.JobID
JOIN Companies c ON j.CompanyID = c.CompanyID
WHERE c.Location = 'Pune' AND a.YearsOfExperience > 2;



