--DataLemur: Teams Power Users
-- Dialect: Postgree SQL
--Level: Easy 
--Tables: messages(message_id,sender_id,receiver_id,content,sent_date)
--Concepts: Limit, Extract, Group by, Order by

SELECT 
count(message_id) as count_messages,
sender_id
FROM messages
where extract(year from sent_date)=2022 and extract(month from sent_date)=08
group by 2
order by 1 desc
limit 2