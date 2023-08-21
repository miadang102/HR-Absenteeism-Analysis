-- Create a join table
SELECT * 
FROM absenteeism_at_work a 
LEFT JOIN compensation c ON a.ID = c.ID
LEFT JOIN reasons r ON a.`Reason for absence` = r.number; 

-- Find the healthiest for the bonus
-- assumed criteria is dont smoke and dont drink, body mass index < 25 and absent hour < average ansent hour of all employees
SELECT * FROM absenteeism_at_work
WHERE `Social drinker` = 0 
AND `Social smoker` = 0 
AND `Body mass index` < 25
AND `absenteeism time in hours` < (SELECT AVG(`absenteeism time in hours`) FROM absenteeism_at_work); 


-- compensation rate increase for non-smokers
-- given budget of $983,221 for all non-smokers 
-- work 8 x 5 x 52 = 2080 working hours per year compensation
SELECT COUNT(*) as non_smokers
FROM absenteeism_at_work a 
WHERE `social smoker` = 0; 

-- Optimize query before creating dashboard 
-- selective columns that we want to use in Power BI
SELECT a.ID, 
		r.Reason, 
        `month of absence`, 
        CASE WHEN `month of absence` IN (12, 1, 2) THEN 'Winter' 
			 WHEN `month of absence` IN (3, 4, 5) THEN 'Spring' 
             WHEN `month of absence` IN (6, 7, 8) THEN 'Summer'
             WHEN `month of absence` IN (9, 10, 11) THEN 'Autumn'
             ELSE 'Unknown' END as `Seasons Name`, 
		`body mass index`,
        CASE WHEN `body mass index` < 18.5 THEN 'Underweight' 
			 WHEN `body mass index` BETWEEN 18.5 AND 25 THEN 'Healthy'
			 WHEN `body mass index` BETWEEN 25 AND 30 THEN 'Overweight'
			 WHEN `body mass index` > 30 THEN 'Obese' END AS `BMI`, 
		`day of the week`, 
        `transportation expense`, 
        `distance from residence to work`, 
        `service time`, 
        `age`, 
        `disciplinary failure`, 
        `social drinker`, 
        `social smoker`, 
        `pet`, 
        `work load average/day`, 
        `absenteeism time in hours`
FROM absenteeism_at_work a 
LEFT JOIN compensation c ON a.ID = c.ID
LEFT JOIN reasons r ON a.`Reason for absence` = r.number; 
