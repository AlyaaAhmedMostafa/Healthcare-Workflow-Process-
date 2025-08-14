SELECT *
FROM [Healthcare].[dbo].[Workflow Process]

--Change Last_Review_Date to DATE Data Type
ALTER TABLE [Healthcare].[dbo].[Workflow Process]
ALTER COLUMN Last_Review_Date DATE;

-- Count of processes by Workflow Type
SELECT Workflow_Type, COUNT(*) AS Process_Count
FROM [Healthcare].[dbo].[Workflow Process]
GROUP BY Workflow_Type
ORDER BY Process_Count DESC;

-- Count of processes by Department
SELECT Department, COUNT(*) AS Dept_Count
FROM [Healthcare].[dbo].[Workflow Process]
GROUP BY Department
ORDER BY Dept_Count DESC;

-- Average and total process time by workflow
SELECT Workflow_Type,
       AVG(Total_Process_Time_Min) AS Avg_Process_Time,
       MAX(Total_Process_Time_Min) AS Max_Process_Time,
       MIN(Total_Process_Time_Min) AS Min_Process_Time,
       SUM(Total_Process_Time_Min) AS Total_Time_All_Instances
FROM [Healthcare].[dbo].[Workflow Process]
GROUP BY Workflow_Type
ORDER BY Avg_Process_Time DESC;

-- Average bottlenecks and handoff count by workflow
SELECT Workflow_Type,
       AVG(Bottlenecks_Identified) AS Avg_Bottlenecks,
       AVG(Handoffs_Count) AS Avg_Handoffs
FROM [Healthcare].[dbo].[Workflow Process]
GROUP BY Workflow_Type
ORDER BY Avg_Bottlenecks DESC, Avg_Handoffs DESC;

-- Average automation level and percent SOP compliant by workflow
SELECT Workflow_Type,
       AVG(Automation_Level) AS Avg_Automation,
       SUM(CASE WHEN Compliance_SOP = 1 THEN 1 ELSE 0 END)*100.0/COUNT(*) AS Percent_Compliance
FROM [Healthcare].[dbo].[Workflow Process]
GROUP BY Workflow_Type
ORDER BY Avg_Automation ASC, Percent_Compliance ASC;

-- Top 10 slowest processes and their characteristics
SELECT TOP 10
    Process_ID, Department, Workflow_Type, Steps_Count, Total_Process_Time_Min,
    Bottlenecks_Identified, Automation_Level, Compliance_SOP
FROM [Healthcare].[dbo].[Workflow Process]
ORDER BY Total_Process_Time_Min DESC;

-- Processes without compliant SOP
SELECT Process_ID, Department, Workflow_Type, Compliance_SOP
FROM [Healthcare].[dbo].[Workflow Process]
WHERE Compliance_SOP = 0;

--Count of Non-Compliant SOP Processes Grouped by Workflow Type
SELECT Workflow_Type, COUNT(*) workflowtype_count
FROM [Healthcare].[dbo].[Workflow Process]
WHERE Compliance_SOP = 0
GROUP BY Workflow_Type
ORDER BY  workflowtype_count DESC

-- Processes overdue for review (define your cutoff, e.g. > 1 year ago)
SELECT Process_ID, Department, Workflow_Type, Last_Review_Date
FROM [Healthcare].[dbo].[Workflow Process]
WHERE Last_Review_Date < DATEADD(year, -1, GETDATE());
