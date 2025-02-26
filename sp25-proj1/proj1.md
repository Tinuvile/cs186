# 2025/2/26

## 环境配置

```gitexclude
git clone https://github.com/berkeley-cs186/sp25-proj1.git
```
其余配置见[cs186.gitbook](https://cs186.gitbook.io/project/assignments/proj1/getting-started)

## 一些简单尝试

```commandline
(base) PS F:\cs186\sp25-proj1> python test.py
FAIL q0 see diffs/q0.txt
FAIL q1i see diffs/q1i.txt
FAIL q1ii see diffs/q1ii.txt
FAIL q1iii see diffs/q1iii.txt
FAIL q1iv see diffs/q1iv.txt
FAIL q2i see diffs/q2i.txt
FAIL q2ii see diffs/q2ii.txt
FAIL q2iii see diffs/q2iii.txt
FAIL q3i see diffs/q3i.txt
FAIL q3ii see diffs/q3ii.txt
FAIL q3iii see diffs/q3iii.txt
FAIL q4i see diffs/q4i.txt
FAIL q4ii_bins_0_to_8 see diffs/q4ii_bins_0_to_8.txt
FAIL q4ii_bin_9 see diffs/q4ii_bin_9.txt
FAIL q4iii see diffs/q4iii.txt
FAIL q4iv see diffs/q4iv.txt
FAIL q4v see diffs/q4v.txt

(base) PS F:\cs186\sp25-proj1> sqlite3 -header lahman.db
SQLite version 3.45.3 2024-04-15 13:34:05 (UTF-16 console I/O)
Enter ".help" for usage hints.

sqlite> .schema people
CREATE TABLE IF NOT EXISTS "people" (
        "playerID" VARCHAR(9) NOT NULL,
        "birthYear" INTEGER NULL,
        "birthMonth" INTEGER NULL,
        "birthDay" INTEGER NULL,
        "birthCountry" VARCHAR(255) NULL,
        "birthState" VARCHAR(255) NULL,
        "birthCity" VARCHAR(255) NULL,
        "deathYear" INTEGER NULL,
        "deathMonth" INTEGER NULL,
        "deathDay" INTEGER NULL,
        "deathCountry" VARCHAR(255) NULL,
        "deathState" VARCHAR(255) NULL,
        "deathCity" VARCHAR(255) NULL,
        "nameFirst" VARCHAR(255) NULL,
        "nameLast" VARCHAR(255) NULL,
        "nameGiven" VARCHAR(255) NULL,
        "weight" INTEGER NULL,
        "height" INTEGER NULL,
        "bats" VARCHAR(255) NULL,
        "throws" VARCHAR(255) NULL,
        "debut" VARCHAR(255) NULL,
        "finalGame" VARCHAR(255) NULL,
        "retroID" VARCHAR(255) NULL,
        "bbrefID" VARCHAR(255) NULL,
        "birth_date" DATE NULL,
        "debut_date" DATE NULL,
        "finalgame_date" DATE NULL,
        "death_date" DATE NULL,
        PRIMARY KEY ("playerID")
);

sqlite> SELECT playerid, namefirst, namelast FROM people;
此处省略···

sqlite> SELECT COUNT(*) FROM fielding;                   
COUNT(*)
143046
```

## 一个问题

按照`gitbook`的步骤修改`proj1.sql`后，运行`test.py`可以看到`PASS`。

```sql
CREATE VIEW q0(era)
AS
  SELECT MAX(ERA) As era
  FROM pitching
;
```

但是按照教程中使用`python3 test.py -q 0`命令无输出

```commandline
(base) PS F:\cs186\sp25-proj1> python test.py
PASS q0
FAIL q1i see diffs/q1i.txt
FAIL q1ii see diffs/q1ii.txt
FAIL q1iii see diffs/q1iii.txt
FAIL q1iv see diffs/q1iv.txt
FAIL q2i see diffs/q2i.txt
FAIL q2ii see diffs/q2ii.txt
FAIL q2iii see diffs/q2iii.txt
FAIL q3i see diffs/q3i.txt
FAIL q3ii see diffs/q3ii.txt
FAIL q3iii see diffs/q3iii.txt
FAIL q4i see diffs/q4i.txt
FAIL q4ii_bins_0_to_8 see diffs/q4ii_bins_0_to_8.txt
FAIL q4ii_bin_9 see diffs/q4ii_bin_9.txt
FAIL q4iii see diffs/q4iii.txt
FAIL q4iv see diffs/q4iv.txt
FAIL q4v see diffs/q4v.txt
(base) PS F:\cs186\sp25-proj1> python3 test.py -q 0
(base) PS F:\cs186\sp25-proj1>
```

经检查`/your_output/q0.txt`中的输出正确，此错误应该是`test.py`的设计问题。

## Task1:Basics

- i. In the `people` table, find the `namefirst`, `namelast` and 
`birthyear` for all players with weight greater than 300 pounds.

- ii. Find the `namefirst`, `namelast` and `birthyear` of all players 
whose `namefirst` field contains a space. Order the results by `namefirst`, 
breaking ties with `namelast` both in ascending order

