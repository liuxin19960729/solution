CREATE TABLE shop (
    article INT UNSIGNED  DEFAULT '0000' NOT NULL,
    dealer  CHAR(20)      DEFAULT ''     NOT NULL,
    price   DECIMAL(16,2) DEFAULT '0.00' NOT NULL,
    PRIMARY KEY(article, dealer));
INSERT INTO shop VALUES
    (1,'A',3.45),(1,'B',3.99),(2,'A',10.99),(3,'B',1.45),
    (3,'C',1.69),(3,'D',1.25),(4,'D',19.95);
    
show tables;


describe shop;
select * from shop;


-- 当前列的最大数
select  max(article) from shop;

-- 最贵价格的行 1
select * from shop where price = (select max(price) from shop );

-- 最贵价格的行 2
-- left join 满足条件数据 + left bale重来不满足条件的数据 + s2 null 
SELECT s1.article, s1.dealer, s1.price
FROM shop s1
LEFT JOIN shop s2 ON s1.price < s2.price
WHERE s2.article IS NULL;


-- 最贵价格的行 降序排序 取第一条 
select * from shop order by price desc limit 1;

select * from shop;
-- 找到每篇文章的最高价格。
select article,max(price) from shop  group by article order by article;


-- 对于每件商品，找到价格最贵的经销商

select * from shop s1
    where price = (
      select max(s2.price) from shop s2 where s1.article=s2.article
    )
order by article;



select * from shop s1 
join(
  select article,max(price) as price from shop group by article
) as s2
on s1.article=s2.article and s1.price=s2.price
order by  s1.article;

SELECT s1.article, s1.dealer, s1.price
FROM shop s1
LEFT JOIN shop s2 ON s1.article = s2.article AND s1.price < s2.price
WHERE s2.article IS NULL
ORDER BY s1.article;

