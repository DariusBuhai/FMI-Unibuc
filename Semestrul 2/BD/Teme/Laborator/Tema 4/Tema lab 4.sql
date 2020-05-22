--enrollment
--course_section
--term
--course
--student
--faculty
--location

select * from enrollment;
select * from course_section;
select * from term;
select * from course;
select * from student;
select * from faculty;
select * from location;
--1
select s.s_last from student s where '(null)' not in (select grade from enrollment where s_id = s.s_id);

--2
select bldg_code from location 
where bldg_code not in 
(select bldg_code from location where loc_id not in (select distinct loc_id from course_section));

--3
select f.f_id, f.f_last from faculty f
where (select count(1) from student s where s.f_id = f.f_id and (select count(1) from enrollment where grade = 'A' and s_id = s.s_id)) > 0
and (select count(1) from course_section where f_id = f.f_id  and course_no = 'MIS 441');


