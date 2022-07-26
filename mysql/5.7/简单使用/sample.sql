-- 查询数据库-- 
show databases;
-- 使用数据库
use liuxin_test;
-- 显示数据库的表
show tables;

-- 创建表
create table pet (
name varchar(20),
ower varchar(20),
species varchar(20) ,
sex char(1),
birth date,
death date
);

-- 查看表描述
describe pet;

-- 删除整张表
drop table pet;

select * from pet;

-- 删除表所有数据
-- truncate table pet;
insert into pet values ("cat","cat","s","f","2020-01-01",null);

delete from pet;



CREATE TABLE event (name VARCHAR(20), date DATE,
       type VARCHAR(15), remark VARCHAR(255));