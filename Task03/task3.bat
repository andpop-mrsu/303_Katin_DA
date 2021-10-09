#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Составить список фильмов, имеющих хотя бы одну оценку. Список фильмов отсортировать по году выпуска и по названиям. В списке оставить первые 10 фильмов."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT * FROM movies where (SELECT COUNT(*) FROM ratings where movie_id == movies.id) > 0 ORDER BY year, title LIMIT 10;"

echo "2. Вывести список всех пользователей, фамилии (не имена!) которых начинаются на букву 'A'. Полученный список отсортировать по дате регистрации. В списке оставить первых 5 пользователей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT * FROM users WHERE name LIKE '%% A%%' ORDER BY register_date LIMIT 5;"

echo "3. Написать запрос, возвращающий информацию о рейтингах в более читаемом формате: имя и фамилия эксперта, название фильма, год выпуска, оценка и дата оценки в формате ГГГГ-ММ-ДД. Отсортировать данные по имени эксперта, затем названию фильма и оценке. В списке оставить первые 50 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT users.name, movies.title, movies.year, rating, DATE(timestamp, 'unixepoch') as date FROM ratings INNER JOIN users ON users.id == user_id INNER JOIN movies ON movies.id == movie_id ORDER BY users.name, movies.title, rating LIMIT 50"

echo "4. Вывести список фильмов с указанием тегов, которые были им присвоены пользователями. Сортировать по году выпуска, затем по названию фильма, затем по тегу. В списке оставить первые 40 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT movies.*, tags.tag FROM movies INNER JOIN tags ON movies.id == movie_id ORDER BY movies.year, movies.title, tags.tag LIMIT 40;"

echo "5. Вывести список самых свежих фильмов. В список должны войти все фильмы последнего года выпуска, имеющиеся в базе данных. Запрос должен быть универсальным, не зависящим от исходных данных (нужный год выпуска должен определяться в запросе, а не жестко задаваться)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT * FROM movies WHERE year == (SELECT MAX(year) FROM movies);"

echo "6. Найти все комедии, выпущенные после 2000 года, которые понравились мужчинам (оценка не ниже 4.5). Для каждого фильма в этом списке вывести название, год выпуска и количество таких оценок. Результат отсортировать по году выпуска и названию фильма."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT DISTINCT movies.title, movies.year, COUNT(DISTINCT ratings.id) FROM movies INNER JOIN ratings ON movies.id == movie_id INNER JOIN users ON ratings.user_id == users.id WHERE movies.year > 2000 AND movies.genres LIKE '%%Comedy%%' AND users.gender == 'male' and ratings.rating >= 4.5 GROUP BY movies.title ORDER BY movies.year, movies.title;"

echo "7. Провести анализ занятий (профессий) пользователей - вывести количество пользователей для каждого рода занятий. Найти самую распространенную и самую редкую профессию посетитетей сайта."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT occupation, COUNT(DISTINCT id) as number FROM users GROUP BY occupation;"
sqlite3 movies_rating.db -box -echo "SELECT occupation, max(number) FROM (SELECT occupation, COUNT(DISTINCT id) as number FROM users GROUP BY occupation);"
sqlite3 movies_rating.db -box -echo "SELECT occupation, min(number) FROM (SELECT occupation, COUNT(DISTINCT id) as number FROM users GROUP BY occupation);"