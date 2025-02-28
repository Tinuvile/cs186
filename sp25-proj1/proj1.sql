-- Before running drop any existing views
DROP VIEW IF EXISTS q0;
DROP VIEW IF EXISTS q1i;
DROP VIEW IF EXISTS q1ii;
DROP VIEW IF EXISTS q1iii;
DROP VIEW IF EXISTS q1iv;
DROP VIEW IF EXISTS q2i;
DROP VIEW IF EXISTS q2ii;
DROP VIEW IF EXISTS q2iii;
DROP VIEW IF EXISTS q3i;
DROP VIEW IF EXISTS q3ii;
DROP VIEW IF EXISTS q3iii;
DROP VIEW IF EXISTS q4i;
DROP VIEW IF EXISTS q4ii;
DROP VIEW IF EXISTS q4iii;
DROP VIEW IF EXISTS q4iv;
DROP VIEW IF EXISTS q4v;

-- Question 0
CREATE VIEW q0(era)
AS
  SELECT MAX(ERA) As era
  FROM pitching
;

-- Question 1i
CREATE VIEW q1i(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear
  FROM people
  WHERE weight > 300;
;

-- Question 1ii
CREATE VIEW q1ii(namefirst, namelast, birthyear)
AS
  SELECT namefirst, namelast, birthyear
  FROM people
  WHERE namefirst LIKE '% %'
  ORDER BY namefirst, namelast;
;

-- Question 1iii
CREATE VIEW q1iii(birthyear, avgheight, count)
AS
  SELECT birthyear, AVG(height) AS avgheight, COUNT(*) AS count
  FROM people
  GROUP BY birthyear
  ORDER BY birthyear;
;

-- Question 1iv
CREATE VIEW q1iv(birthyear, avgheight, count)
AS
  SELECT birthyear, avgheight, count
  FROM q1iii
  WHERE avgheight > 70
  ORDER BY birthyear;
;

-- Question 2i
CREATE VIEW q2i(namefirst, namelast, playerid, yearid)
AS
  SELECT p.namefirst, p.namelast, p.playerid, h.yearid
  FROM halloffame h JOIN people p ON h.playerID = p.playerID
  WHERE h.inducted = 'Y'
  ORDER BY h.yearid DESC, p.playerID;
;

-- Question 2ii
CREATE VIEW q2ii(namefirst, namelast, playerid, schoolid, yearid)
AS
  SELECT p.namefirst, p.namelast, p.playerID, cp.schoolID, h.yearid
  FROM halloffame h
      JOIN people p ON h.playerID = p.playerID
      JOIN collegeplaying cp ON p.playerID = cp.playerID
      JOIN schools s ON cp.schoolID = s.schoolID
  WHERE h.inducted = 'Y' AND s.state = 'CA'
  ORDER BY h.yearid DESC, cp.schoolID, p.playerID;
;

-- Question 2iii
CREATE VIEW q2iii(playerid, namefirst, namelast, schoolid)
AS
  SELECT p.playerID, p.namefirst, p.namelast, cp.schoolID
  FROM halloffame h
      JOIN people p ON h.playerID = p.playerID
      LEFT JOIN collegeplaying cp ON p.playerID = cp.playerID
  WHERE h.inducted = 'Y'
  ORDER BY p.playerID DESC, cp.schoolID;
;

-- Question 3i
CREATE VIEW q3i(playerid, namefirst, namelast, yearid, slg)
AS
  SELECT p.playerid, p.nameFirst, p.nameLast, b.yearID,
         CAST((b.H + b.H2B + 2 * b.H3B + 3 * b.HR) AS FLOAT) / nullif(b.AB, 0) AS slg
  FROM batting b JOIN people p ON b.playerID = p.playerID
  WHERE b.AB > 50
  ORDER BY slg DESC, b.yearID, b.playerID
  LIMIT 10;
;

-- Question 3ii
CREATE VIEW q3ii(playerid, namefirst, namelast, lslg)
AS
  SELECT b.playerID, p.nameFirst, p.nameLast,
         CAST((SUM(b.H) + SUM(b.H2B) + 2 * SUM(b.H3B) + 3 * SUM(b.HR)) AS FLOAT) / nullif(SUM(b.AB), 0) AS lslg
  FROM batting b JOIN people p ON b.playerID = p.playerID
  GROUP BY b.playerID, p.nameFirst, p.nameLast
  HAVING SUM(b.AB) > 50
  ORDER BY lslg DESC, b.playerID
  LIMIT 10;
;

-- Question 3iii
CREATE VIEW q3iii(namefirst, namelast, lslg)
AS
WITH willie_mays_lslg AS (
    SELECT CAST((SUM(bm.H) + SUM(bm.H2B) + 2 * SUM(bm.H3B) + 3 * SUM(bm.HR)) AS FLOAT) / nullif(SUM(bm.AB), 0) AS lslg
    FROM batting bm
    WHERE bm.playerID = 'mayswi01'
--     HAVING SUM(bm.AB) > 50
)
  SELECT p.nameFirst, p.nameLast,
         CAST((SUM(b.H) + SUM(b.H2B) + 2 * SUM(b.H3B) + 3 * SUM(b.HR)) AS FLOAT) / nullif(SUM(b.AB), 0) AS lslg
  FROM batting b JOIN people p ON b.playerID = p.playerID
  GROUP BY p.playerID, p.nameFirst, p.nameLast
  HAVING
      SUM(b.AB) > 50
     AND (CAST((SUM(b.H) + SUM(b.H2B) + 2 * SUM(b.H3B) + 3 * SUM(b.HR)) AS FLOAT) / NULLIF(SUM(b.AB), 0) >
          (SELECT lslg FROM willie_mays_lslg))
;

-- Question 4i
CREATE VIEW q4i(yearid, min, max, avg)
AS
  SELECT yearID, MIN(salary) AS min, MAX(salary) AS max, AVG(salary) AS avg
  FROM salaries
  GROUP BY yearID
  ORDER BY yearID
;

-- Question 4ii
CREATE VIEW q4ii(binid, low, high, count)
AS
    WITH salary_range AS (
    SELECT
        MIN(salary) AS min_salary,
        MAX(salary) AS max_salary
    FROM
        salaries
    WHERE
        yearid = 2016
),
    bins AS (
    SELECT
        0 AS binid,
        min_salary AS low,
        min_salary + (max_salary - min_salary) / 10.0 AS high
    FROM
        salary_range
    UNION ALL
    SELECT
        1,
        min_salary + (max_salary - min_salary) / 10.0,
        min_salary + 2 * (max_salary - min_salary) / 10.0
    FROM
        salary_range
    UNION ALL
    SELECT
        2,
        min_salary + 2 * (max_salary - min_salary) / 10.0,
        min_salary + 3 * (max_salary - min_salary) / 10.0
    FROM
        salary_range
    UNION ALL
    SELECT
        3,
        min_salary + 3 * (max_salary - min_salary) / 10.0,
        min_salary + 4 * (max_salary - min_salary) / 10.0
    FROM
        salary_range
    UNION ALL
    SELECT
        4,
        min_salary + 4 * (max_salary - min_salary) / 10.0,
        min_salary + 5 * (max_salary - min_salary) / 10.0
    FROM
        salary_range
    UNION ALL
    SELECT
        5,
        min_salary + 5 * (max_salary - min_salary) / 10.0,
        min_salary + 6 * (max_salary - min_salary) / 10.0
    FROM
        salary_range
    UNION ALL
    SELECT
        6,
        min_salary + 6 * (max_salary - min_salary) / 10.0,
        min_salary + 7 * (max_salary - min_salary) / 10.0
    FROM
        salary_range
    UNION ALL
    SELECT
        7,
        min_salary + 7 * (max_salary - min_salary) / 10.0,
        min_salary + 8 * (max_salary - min_salary) / 10.0
    FROM
        salary_range
    UNION ALL
    SELECT
        8,
        min_salary + 8 * (max_salary - min_salary) / 10.0,
        min_salary + 9 * (max_salary - min_salary) / 10.0
    FROM
        salary_range
    UNION ALL
    SELECT
        9,
        min_salary + 9 * (max_salary - min_salary) / 10.0,
        max_salary + 1  -- 这里加1以确保最大值包含在最后一个区间中
    FROM
        salary_range
)
SELECT
    b.binid,
    b.low,
    b.high,
    COUNT(s.salary) AS count
FROM
    bins b
LEFT JOIN
    salaries s ON s.salary >= b.low AND s.salary < b.high AND s.yearid = 2016
GROUP BY
    b.binid, b.low, b.high
ORDER BY
    b.binid
;

-- Question 4iii
CREATE VIEW q4iii(yearid, mindiff, maxdiff, avgdiff)
AS
    WITH yearly_salaries AS (
        SELECT yearid, MIN(salary) AS min_salary, MAX(salary) AS max_salary, AVG(salary) AS avg_salary
        FROM salaries
        GROUP BY yearid
    ),
    salary_differences AS (
        SELECT current.yearid,
               current.min_salary - previous.min_salary AS mindiff,
               current.max_salary - previous.max_salary AS maxdiff,
               current.avg_salary - previous.avg_salary AS avgdiff
        FROM yearly_salaries current JOIN yearly_salaries previous ON current.yearID = previous.yearID + 1
    )
  SELECT yearid, mindiff, maxdiff, avgdiff
  FROM salary_differences
  ORDER BY yearid;
;

-- Question 4iv
CREATE VIEW q4iv(playerid, namefirst, namelast, salary, yearid)
AS
    WITH max_salaries AS (
        SELECT yearID, MAX(salary) AS max_salary
        FROM salaries
        WHERE yearID IN (2000,2001)
        GROUP BY yearID
    )
  SELECT s.playerID, p.namefirst, p.namelast, s.salary, s.yearID
  FROM salaries s
      JOIN max_salaries m ON s.yearID = m.yearID AND s.salary = m.max_salary
      JOIN people p ON s.playerID = p.playerID
  WHERE s.yearID IN (2000,2001)
  ORDER BY s.yearID, s.playerID
;

-- Question 4v
CREATE VIEW q4v(team, diffAvg) AS
  SELECT a.teamid, ROUND(MAX(COALESCE(s.salary, 0)) - MIN(COALESCE(s.salary, 0)), 4) AS diffAvg
  FROM allstarfull a JOIN salaries s ON a.playerID = s.playerID
  WHERE s.yearID = 2016
  GROUP BY a.teamid
  HAVING COUNT(*) > 0;
;

