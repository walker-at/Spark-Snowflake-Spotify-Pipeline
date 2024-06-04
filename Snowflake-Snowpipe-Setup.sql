CREATE DATABASE spotify_db;

create or replace storage integration s3_init
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::211125689893:role/spark-snowflake-role'
STORAGE_ALLOWED_LOCATIONS = ('s3://spotify-etl-walker')
COMMENT = 'Creating connection to s3'

DESC integration s3_init;

// create file format object
CREATE OR REPLACE file format csv_fileformat
    type = csv
    field_delimiter = ','
    skip_header = 1
    null_if = ('NULL','null')
    empty_field_as_null = TRUE;

CREATE OR REPLACE stage spotify_stage
    URL = 's3://spotify-etl-walker/transformed_data/'
    STORAGE_INTEGRATION = s3_init
    FILE_FORMAT = csv_fileformat

LIST @spotify_stage/songs_data;

CREATE OR REPLACE TABLE tbl_album (
    album_id STRING,
    name STRING,
    release_date DATE,
    total_tracks INT,
    url STRING
);

CREATE OR REPLACE TABLE tbl_artists (
    album_id STRING,
    name STRING,
    url STRING
);

CREATE OR REPLACE TABLE tbl_songs (
    song_id STRING,
    song_name STRING,
    duration_ms INT,
    url STRING,
    popularity INT,
    song_added DATE,
    album_id STRING,
    artist_id STRING
);

COPY INTO tbl_songs
FROM @spotify_stage/songs_data/songs_transformed_2024-06-04/run-1717509899160-part-r-00000

select * from tbl_songs

COPY INTO tbl_artists
FROM @spotify_stage/songs_data/songs_transformed_2024-06-04/run-1717509899160-part-r-00000

-- create snowpipe
CREATE OR REPLACE SCHEMA pipe;

CREATE OR REPLACE pipe pipe.tbl_songs_pipe
auto_ingest = TRUE
AS
COPY INTO spotify_db.public.tbl_songs
FROM @spotify_db.public.spotify_stage/songs_data/;

CREATE OR REPLACE pipe pipe.tbl_artists_pipe
auto_ingest = TRUE
AS
COPY INTO spotify_db.public.tbl_artists
FROM @spotify_db.public.spotify_stage/artists_data/;

CREATE OR REPLACE pipe pipe.tbl_album_pipe
auto_ingest = TRUE
AS
COPY INTO spotify_db.public.tbl_album
FROM @spotify_db.public.spotify_stage/album_data/;

DESC pipe pipe.tbl_songs_pipe

select count(*) from tbl_songs
