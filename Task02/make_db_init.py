with open('db_init.sql', 'w') as f:
    f.write('drop table if exists movies;\n')
    f.write('drop table if exists ratings;\n')
    f.write('drop table if exists tags;\n')
    f.write('drop table if exists users;\n')
    f.write('create table movies(\n'
            'id integer primary key,\n'
            'title text,\n'
            'year integer,\n'
            'genres text\n'
            ');\n')
    f.write('create table ratings(\n'
            'id integer primary key,\n'
            'user_id integer,\n'
            'movie_id integer,\n'
            'rating real,\n'
            'timestamp integer\n'
            ');\n')
    f.write('create table tags(\n'
            'id integer primary key,\n'
            'user_id integer,\n'
            'movie_id integer,\n'
            'tag text,\n'
            'timestamp integer\n'
            ');\n')
    f.write('create table users(\n'
            'id integer primary key,\n'
            'name text,\n'
            'email text,\n'
            'gender text,\n'
            'register_date text,\n'
            'occupation text\n'
            ');\n')
    f.write('insert into movies(id, title, year, genres) values\n')
    with open('movies.csv', 'r') as movies_csv:
        movies_data = movies_csv.readlines()
        first = True
        for line in movies_data[1:-1]:
            if not first:
                f.write(',\n')
            first = False
            split_line = line.split(',')
            id = int(split_line[0])
            genres = split_line[-1][:-1]
            title_parts = split_line[1:-1]
            title = ""
            title += title_parts[0]
            for part in title_parts[1:]:
                title += ', ' + part
            title = title.rstrip()
            if title[0] == '"' and title[-1] == '"':
                title = title[1:-1]
            title = title.rstrip()
            year = title[-5:-1]
            try:
                year = int(year)
            except:
                year = 'NULL'
            else:
                title = title[:-7]
            title = f'"{title}"'
            genres = f'"{genres}"'
            f.write(f'({id}, {title}, {year}, {genres})')
        f.write(';\n')

    f.write('insert into ratings(id, user_id, movie_id, rating, timestamp) values\n')
    with open('ratings.csv', 'r') as ratings_csv:
        ratings_data = ratings_csv.readlines()
        first = True
        id = 0
        for line in ratings_data[1:-1]:
            id += 1
            if not first:
                f.write(',\n')
            first = False
            split_line = line.split(',')
            user_id = int(split_line[0])
            movie_id = int(split_line[1])
            rating = float(split_line[2])
            timestamp = int(split_line[3])
            f.write(f'({id}, {user_id}, {movie_id}, {rating}, {timestamp})')
        f.write(';\n')

        f.write('insert into tags(id, user_id, movie_id, tag, timestamp) values\n')
        with open('tags.csv', 'r') as tags_csv:
            tags_data = tags_csv.readlines()
            first = True
            id = 0
            for line in tags_data[1:-1]:
                id += 1
                if not first:
                    f.write(',\n')
                first = False
                split_line = line.split(',')
                user_id = int(split_line[0])
                movie_id = int(split_line[1])
                tag = '"' + split_line[2].replace('"', '') + '"'
                timestamp = int(split_line[3])
                f.write(f'({id}, {user_id}, {movie_id}, {tag}, {timestamp})')
            f.write(';\n')

        f.write('insert into users(id, name, email, gender, register_date, occupation) values\n')
        with open('users.txt', 'r') as users_txt:
            users_data = users_txt.readlines()
            first = True
            for line in users_data:
                if not first:
                    f.write(',\n')
                first = False
                split_line = line.split('|')
                id = int(split_line[0])
                name = '"' + split_line[1] + '"'
                email = '"' + split_line[2] + '"'
                gender = '"' + split_line[3] + '"'
                register_date = '"' + split_line[4] + '"'
                occupation = '"' + split_line[5].rstrip() + '"'
                f.write(f'({id}, {name}, {email}, {gender}, {register_date}, {occupation})')
            f.write(';\n')