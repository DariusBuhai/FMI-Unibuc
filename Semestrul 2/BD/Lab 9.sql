--8
select city
from locations l
where exists (select 1
              from departments
              where location_id = l.location_id); 
              
select city
from locations l
where location_id in (select location_id
              from departments);

--9
select department_name
from departments d  
where not exists (select 1
                  from employees
                  where department_id = d.department_id);

--10
WITH val_dep AS (select department_name, sum(salary) total
                 from employees join departments using (department_id)
                 group by department_id, department_name),
val_medie AS (select avg(total) medie
              from val_dep)
SELECT *
FROM val_dep
WHERE total > (SELECT medie
               FROM val_medie)
ORDER BY department_name;


--11
with steven_id as ( select employee_id
                    from employees
                    where first_name = 'Steven' and last_name = 'King'),
subalterni_steven as (select *
                    from employees
                    where manager_id = (select employee_id
                                        from steven_id)),
vechime_max as (select min(hire_date) minh
                from subalterni_steven)
select employee_id, first_name, last_name, job_id, hire_date
from employees 
where manager_id = (select employee_id from subalterni_steven, vechime_max where hire_date = minh);

--12
--v1
select first_name, salary from (select first_name, salary from employees order by salary desc) where rownum <= 10;
--v2
select first_name, salary from employees e where (select count(*) from employees where salary >e.salary) < 10;

--13
--v1
select job_title from 
(select job_title from jobs j order by (select avg(salary) from employees where job_id = j.job_id) asc)
where rownum <=3;
--v2
with tab_medie as (select job_id, avg(salary) medie from employees group by job_id)
select job_title 
from (select job_title from jobs j join tab_medie using(job_id) order by medie asc) 
where rownum <=3;


