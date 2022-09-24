--1.	List the student ID of the student that has enrolled in the most sections of 100 level courses (100 - 199).
--SELECT s.student_id, COUNT(DISTINCT e.section_id) AS "Most Sections Taken"
--	FROM student s, enrollment e
--WHERE (s.student_id = e.student_id)
--	AND (e.section_id BETWEEN 100 AND 199)
--GROUP BY s.student_id
--ORDER BY "Most Sections Taken" DESC;

--SELECT student_id, COUNT(section_id) AS "Most Sections Taken"
--	FROM enrollment
--WHERE section_id BETWEEN 100 AND 199
--HAVING COUNT(student_id) = 
--		(SELECT MAX(COUNT(student_id))
--			FROM enrollment
--		GROUP BY student_id)
--GROUP BY student_id;

--SELECT student_id, section_id
--	FROM enrollment
--ORDER BY student_id, section_id;

--2.	Provide the student_id and name of the student(s) that scored highest on the final exam (FI) in course 230 section 99.
--SELECT s.student_id, s.first_name, s.last_name, t.course_no, t.section_id, 
--	   MAX(g.numeric_grade) AS "Highest Final Exam"
--	FROM student s, grade g, section t
--WHERE s.student_id = g.student_id 
--	AND g.section_id = t.section_id
--	AND g.numeric_grade =
--		(SELECT MAX(numeric_grade)
--			FROM grade
--		WHERE grade_type_code = 'FI')
--	AND g.grade_type_code = 'FI'
--	AND t.section_id = '99'
--	AND t.course_no = '230'
--GROUP BY s.student_id, s.first_name, s.last_name, t.course_no, t.section_id
--ORDER BY s.student_id;

--SELECT STUDENT_ID, FIRST_NAME, LAST_NAME
--FROM STUDENT
--WHERE STUDENT_ID = (
--SELECT STUDENT_ID FROM (
--  SELECT * FROM (
--    SELECT GRADE.STUDENT_ID, GRADE.NUMERIC_GRADE
--    FROM GRADE, SECTION
--    WHERE (GRADE.SECTION_ID = SECTION.SECTION_ID) AND (GRADE.SECTION_ID = 99) AND (SECTION.COURSE_NO = 230) AND (GRADE_TYPE_CODE = 'FI')
--    ORDER BY GRADE.NUMERIC_GRADE DESC
--  ) 
--  WHERE ROWNUM=1
--));

--3.	List the name and phone number of instructors who have never taught a course section.
--SELECT instructor_id, first_name, last_name
--	FROM instructor
--WHERE instructor_id NOT IN 
--	(SELECT instructor_id
--		FROM section)
--ORDER BY instructor_id;

--4.	Generate an alphabetic listing containing the last names and final exam grade (FI) of students who scored above average on the final exam for section 89.
--SELECT g.section_id, s.last_name, 
--	   g.grade_type_code, g.numeric_grade
--	FROM student s, grade g
--WHERE (s.student_id = g.student_id) 
--	AND (g.section_id = 89)
--	AND (g.grade_type_code = 'FI')
--	AND (g.numeric_grade > 
--		(SELECT AVG(numeric_grade)
--			FROM grade))
--ORDER BY s.last_name;

--5.	List the course number and course description of the course with the highest number of enrolled students.
--SELECT course_no, description
--	FROM course
--WHERE course_no =	
--	(SELECT course_no
--		FROM section 
--	WHERE section_id IN 
--	(SELECT DISTINCT section_id
--		FROM enrollment)
--		GROUP BY course_no
--		HAVING COUNT(course_no) =
--		(SELECT MAX(COUNT(course_no))
--			FROM section 
--		WHERE section_id IN 
--		(SELECT DISTINCT section_id
--			FROM enrollment)
--	GROUP BY course_no));

--6.	List course number and course description for all courses that don’t have at least one 9:30AM section.  Sort by course number.
--SELECT course_no, description
--	FROM course 
--WHERE course_no NOT IN 
--	(SELECT course_no
--		FROM section 
--	WHERE TO_CHAR(start_date_time, 'HH:MI') = '9:30')
--ORDER BY course_no;

--7.	List the student_id and last name of the students who received an above average grade on Quiz #3 in section 120.
--SELECT s.student_id, s.last_name, g.numeric_grade
--	FROM grade g, student s
--WHERE g.student_id = s.student_id
--	AND grade_type_code = 'QZ'
--	AND g.grade_code_occurrence = '3'
--	AND g.section_id = 120
--	AND g.numeric_grade > 
--	(SELECT AVG(numeric_grade)
--		FROM grade
--	WHERE grade_type_code = 'QZ'
--		AND grade_code_occurrence = 3
--		AND section_id = 120)
--ORDER BY s.student_id;

--8.	List the student id, last name and the final exam grade for students in section 142.
--SELECT s.student_id, g.section_id, 
--	   s.last_name, g.numeric_grade	
--	FROM student s, grade g
--WHERE s.student_id = g.student_id
--	AND s.student_id IN 
--		(SELECT e.student_id
--			FROM enrollment e, section s
--		WHERE e.section_id = s.section_id)
--	AND g.grade_type_code = 'FI'
--	AND g.section_id = 142;

--9.	List the names of students who have taken both the Systems Analysis class and the Project Management class.
--SELECT last_name, first_name
--	FROM student
--WHERE student_id IN 
--	(SELECT DISTINCT student_id
--		FROM enrollment 
--	WHERE section_id IN
--		(SELECT section_id
--			FROM section
--		WHERE course_no IN 
--		(SELECT course_no
--			FROM course
--		WHERE description = 'Systems Analysis' 
--			AND description = 'Project Management')))
--ORDER BY last_name;

--10.	List the instructor name, course number and course description of the Java courses that have been taught by the Instructor that has taught the most Java courses.
--SELECT s.course_no, i.instructor_id, i.last_name, i.first_name
--	FROM instructor i, section s
--WHERE s.instructor_id = i.instructor_id
--	AND s.course_no IN
--		(SELECT course_no
--			FROM course
--		WHERE description LIKE '%Java')
--GROUP BY s.course_no, i.instructor_id, i.last_name, i.first_name
--ORDER BY i.instructor_id, s.course_no;

--11.	List the names of instructors who have not used projects (PJ) as a basis for grading in their courses.
--SELECT last_name, first_name 
--	FROM instructor
--WHERE instructor_id NOT IN 
--	(SELECT s.instructor_id
--		FROM section s, grade g
--	WHERE s.section_id = g.section_id
--		AND g.grade_type_code = 'PJ')
--ORDER BY last_name;

--12.	Determine the number of students who received a below average grade on the final exam (FI) in section 86.
--SELECT COUNT(*) AS "Total Student Below Average"
--	FROM grade
--WHERE section_id = 86
--	AND grade_type_code = 'FI'
--	AND numeric_grade < 
--	(SELECT AVG(numeric_grade)
--		FROM grade
--	WHERE grade_type_code = 'FI'
--		AND section_id = 86);

--13.	List the city and state that have the highest number of students enrolled.
--SELECT city, state 
--	FROM zipcode
--WHERE zip = 
--	(SELECT zip
--		FROM student
--	WHERE student_id IN 
--		(SELECT DISTINCT student_id
--			FROM enrollment)
--	GROUP BY zip
--	HAVING COUNT(zip) = 
--		(SELECT MAX(COUNT(zip))
--			FROM student
--		WHERE student_id IN 
--			(SELECT DISTINCT student_id
--				FROM enrollment)
--		GROUP BY zip));

--14.	Provide the student_id, name and final exam grade of the student(s) that scored highest on the final exam (FI) in course section 81.
--SELECT s.student_id, s.last_name, s.first_name, g.numeric_grade AS "Highest Final Exam"
--	FROM student s, grade g
--WHERE s.student_id = g.student_id
--	AND s.student_id = 
--		(SELECT student_id
--			FROM grade
--		WHERE numeric_grade = 
--			(SELECT MAX(numeric_grade)
--				FROM grade
--			WHERE section_id = 81
--				AND grade_type_code = 'FI')
--		AND section_id = 81
--		AND grade_type_code = 'FI')
--	AND section_id = 81
--	AND grade_type_code = 'FI';

--15.	List the student id and name of students who have taken the same course more than once .
--SELECT student_id, last_name, first_name 
--	FROM student
--WHERE student_id IN 
--	(SELECT e.student_id
--		FROM enrollment e, section s
--	WHERE s.section_id = e.section_id
--		HAVING COUNT(s.course_no) > 1
--	GROUP BY e.student_id, s.course_no)
--ORDER BY student_id, last_name;