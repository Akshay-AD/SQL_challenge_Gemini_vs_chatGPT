#1)What are the average scores for each capability on both the Gemini Ultra and GPT-4 models?
SELECT c.CapabilityName,
	round(avg(ScoreGemini)) AS 'Gemini score',
	round(avg(ScoreGPT4)) AS 'GPT4 Score' 
FROM benchmarks b 
INNER JOIN capabilities c ON c.CapabilityID=b.CapabilityID
GROUP BY c.CapabilityName;


#2)Which benchmarks does Gemini Ultra outperform GPT-4 in terms of scores?
SELECT BenchmarkName
FROM benchmarks b
INNER JOIN models m
ON m.ModelID=b.ModelID
WHERE ScoreGemini>ScoreGPT4;


#3)What are the highest scores achieved by Gemini Ultra and GPT-4 for each benchmark in the Image capability?
SELECT BenchmarkName,
	MAX(ScoreGemini) AS 'Gemini Max Score',
	MAX(ScoreGPT4) AS 'GPT Max Score'
FROM benchmarks B
INNER JOIN Capabilities C 
ON C.CapabilityID=B.CapabilityID
WHERE CapabilityName='Image'
GROUP BY BenchmarkName;

#4)Calculate the percentage improvement of Gemini Ultra over GPT-4 for each benchmark?
SELECT BenchmarkName,
ROUND((ScoreGemini-ScoreGPT4)/ScoreGPT4*100,2)
FROM BENCHMARKS
WHERE ScoreGPT4 IS NOT NULL 

#5)Retrieve the benchmarks where both models scored above the average for their respective models? 
SELECT BenchmarkName,ScoreGemini,ScoreGPT4 
FROM benchmarks
WHERE 
ScoreGemini>(SELECT AVG(ScoreGemini) FROM benchmarks)
AND
ScoreGPT4>(SELECT AVG(ScoreGPT4) FROM benchmarks);

#6)Which benchmarks show that Gemini Ultra is expected to outperform GPT-4 based on the next score?
SELECT BenchmarkName,ScoreGemini,ScoreGPT4
FROM benchmarks
WHERE ScoreGemini>ScoreGPT4;

#7)Classify benchmarks into performance categories based on score ranges?
SELECT BenchmarkName,
CASE 
WHEN ScoreGemini<= 90 THEN 'Excellent'
WHEN ScoreGemini<= 80 THEN 'Great'
WHEN ScoreGemini<= 70 THEN 'Moderate'
WHEN ScoreGemini<= 60 THEN 'Low'
END AS 'Gemini Score',
CASE 
WHEN ScoreGPT4<= 90 THEN 'Excellent'
WHEN ScoreGPT4<= 80 THEN 'Great'
WHEN ScoreGPT4<= 70 THEN 'Moderate'
WHEN ScoreGPT4<= 60 THEN 'Low'
END AS 'GPT4 Score'
FROM benchmarks
WHERE ScoreGPT4 IS NOT NULL;

#8) Retrieve the rankings for each capability based on Gemini Ultra scores?
SELECT  C.CapabilityName,
		B.BenchmarkName,
		ROUND(SUM(ScoreGemini)) AS 'SUM',
        RANK() OVER (PARTITION BY CapabilityName ORDER BY ROUND(SUM(ScoreGemini)) DESC) AS 'RANK'
FROM BENCHMARKS B
INNER JOIN Capabilities C 
ON B.CapabilityID=C.CapabilityID 
GROUP BY C.CapabilityName,B.BenchmarkName;

#9)Convert the Capability and Benchmark names to uppercase?
SELECT
UPPER(C.CapabilityName) AS 'CapabilityName',
UPPER(B.BenchmarkName) AS 'BenchmarkName'
FROM Benchmarks B
INNER JOIN Capabilities C 
ON C.CapabilityID=B.CapabilityID 
GROUP BY CapabilityName,BenchmarkName;

#10) Can you provide the benchmarks along with their descriptions in a concatenated format?
SELECT DISTINCT(CONCAT(BenchmarkName,' - ',Description)) AS 'Benchmark_info'
FROM benchmarks;

