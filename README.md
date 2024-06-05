# Spark-Snowflake-Pipeline
This project implements an ETL pipeline using Apache Spark to ingest data on Spotify's top songs on a weekly basis into Snowflake. AWS is used for project management. Specifically, I deploy my python code for extracting the data from the Spotify API as a Lambda function and set Amazon CloudWatch to schedule this to be performed weekly, the same frequency that Spotify updates their playlist of top songs. This lambda function writes the json file to an S3 bucket while also triggering the spark code written as an etl job in AWS Glue. The data is transformed, split under 3 headings (album, artist, song), and then deposited into 3 corresponding folders within the bucket. Once here, a snowpipe triggers and loads the data into their respective Snowflake tables.

# Business Objective
Understand the music industry by analyzing the weekly-updated top 50 global songs on the spotify playlist called "Top Songs - Global" 

# Data 
The Data is extracted from the Spotify. The data from the Spotify API comes as a .json file with 3 key fields: information on the album, the artist(s), and the song. I will create 3 different tables based on this.

# Tools
* IAM roles with permissions
* Amazon CloudWatch
* AWS Lambda Function - data extraction (written in python)
* AWS Glue - data transformation (written in Apache Spark)
* Amazon S3 bucket - The folder structure within my bucket will look like the following:
  * raw_data
      * to_processed
      * processed
  * transformed_data
      * album_data
      * artist_data
      * songs_data
* Snowpipe - for integration from S3 into Snowflake

# Workflow
1. Lambda function to extract data from the spotify api and moves it to the "raw_data/to_processed" folder in my S3 bucket. I schedule this to run on a weekly basis with Amazon CloudWatch.
2. This lambda function then triggers an ETL job in AWS Glue to perform the Spark transformations on the data.
3. The spark code in my Glue job then puts the transformed data into the "transformed_data/album_data" or "transformed_data/songs_data" or "transformed_data/artist_data," depending on which it is.
4. The spark code in my Glue job then moves the original file from "raw_data/to_processed" to "raw_data/processed".
5. Snowpipe is triggered when files are deposited in any of the 3 transformed_data folders in my S3 bucket. I have a snowpipe for each (3 total); they load the data into either the "tbl_album" table, the "tbl_artist" table, or the "tbl_songs" table in Snowflake where it is ready to be queried for further analysis.

# Connecting Snowflake to AWS
Snowflake:
Copy STORAGE_AWS_IAM_USER_ARN value and paste it in the IAM trust policy key called "AWS"
Copy STORAGE_AWS_EXTERNAL_ID value and aste it in the IAM trust policy key called "sts:ExternalId:"

To connect our Snowpipe: 
There ia a snowpipe for each sub-folder in the "transformed_data" folder in the S3 bucket (album_data, songs_data, artist_data)
To connect the snowpipe: Run DESC pipe pipe.tbl_songs_pipe and copy the notification_channel value, go to your s3 bucket, create an event notification, under Destination select SQS Queue and select enter SQS queue ARN and paste in this value there. Repeat this for tbl_album_pipe and tbl_artist_pipe.


Errors Encountered:
IAM role permission
Snowflake schema specification for pipes
