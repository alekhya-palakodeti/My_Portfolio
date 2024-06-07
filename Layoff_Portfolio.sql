---SELECT COUNT(*) FROM dbo.layoffs;

SELECT * FROM Layoff_staging
---1 Remove Duplicates

 SELECT * INTO Layoff_staging FROM layoffs WHERE 1 = 0;

 INSERT INTO Layoff_staging SELECT * FROM layoffs;

 SELECT *,
	ROW_NUMBER () OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date' ORDER BY company ) AS Row_Number
 FROM Layoff_staging;

		 WITH DuplicateSelection AS
		 (SELECT *,
			ROW_NUMBER () OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date' , stage, country , funds_raised_millions
			ORDER BY company ) AS Row_Number
		 FROM Layoff_staging)

		 SELECT * FROM DuplicateSelection
		 WHERE ROW_NUMBER>1;


 SELECT * from Layoff_staging where company = 'Better.com';

  WITH DuplicateSelection AS
 (SELECT *,
	ROW_NUMBER () OVER (PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date' , stage, country , funds_raised_millions
	ORDER BY company ) AS Row_Number
 FROM Layoff_staging)

 DELETE FROM DuplicateSelection
 WHERE ROW_NUMBER>1;

 ----2 Standardize data

 SELECT company , TRIM(company) AS TRIM
 FROM Layoff_staging

 UPDATE Layoff_staging
 SET company = TRIM(company);

 
 SELECT industry , TRIM(industry) AS TRIM
 FROM Layoff_staging
 ORDER BY 1;

 UPDATE Layoff_staging
 SET industry = TRIM(industry);

 UPDATE Layoff_staging
 SET industry = 'Crypto'
 WHERE industry LIKE 'crypto%';

 SELECT DISTINCT country FROM Layoff_staging ORDER BY 1

 SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
 FROM Layoff_staging
 ORDER BY 1;

SELECT date,
    CONVERT(VARCHAR(10), CONVERT(DATE, date, 101), 23) AS ConvertedDate
FROM Layoff_staging;

UPDATE Layoff_staging
SET date = CONVERT(VARCHAR(10), CONVERT(DATE, date, 101), 23);

----3 Null values

SELECT * FROM Layoff_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

SELECT * FROM Layoff_staging
WHERE industry IS NULL
OR industry = '';

SELECT * FROM Layoff_staging
WHERE industry = ' ' OR industry IS NULL;

UPDATE t1
SET t1.industry = t2.industry
FROM layoff_staging t1
JOIN layoff_staging t2
    ON t1.company = t2.company
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

DELETE FROM Layoff_staging
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

----4.Remove unnecessary columns
ALTER TABLE Layoff_staging
DROP column Row_number;

SELECT * FROM Layoff_staging;