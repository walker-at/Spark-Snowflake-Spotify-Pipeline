# Spark-Snowflake-Pipeline

# Business Objective
Understand the music industry by analyzing the weekly-updated top 50 global songs on the spotify playlist called "Top Songs - Global" 

extract from spotify api
explain the split into album artist song
on the spotify api we have artists, album info, and track info available
using json file
The data from the Spotify API comes as a .json file with 3 key fields: information on the album, the artist(s), and the song. I will create 3 different tables based on this.


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
Snowpipe - for integration from S3 into Snowflake

# Workflow
1. Lambda function to extract data from the spotify api and moves it to the "raw_data/to_processed" folder in my S3 bucket. I schedule this to run on a weekly basis with Amazon CloudWatch.
2. This lambda function then triggers an ETL job in AWS Glue to perform our Spark transformations on the data.
3. The transformed data is put into the "transformed_data/album_data" or "transformed_data/songs_data" or "transformed_data/artist_data" depending on which it is.
4. The spark code in AWS Glue then moves the original file from "raw_data/to_processed" to "raw_data/processed".
5. Snowpipe is triggered when files are deposited in any of the 3 transformed_data folders in my S3 bucket. I have 3 different snowpipes which put the data into either the "tbl_album" table, the "tbl_artist" table, or the "tbl_songs" table in Snowflake where it is ready to be queried for further analysis.

code inside lambda function for data extraction triggers the AWS Glue transformation

extract data and apply trasnformation logic with apache spark, before loading into snowflake

write our extraction code in python and deploy it on AWS Lambda. on top of that we will apply Amazon CloudWatch (daily trigger) to schedule when our code should run. it will run our lambda function to extract data from the spotify api and put the raw data on Amazon S3, which will trigger our transformation logic written in apache spark to be performed on this raw data.

Use AWS Glue to run a spark engine for our transformation job

snowflake:
copy STORAGE_AWS_IAM_USER_ARN value and paste it in the IAM trust policy key called AWS
copy STORAGE_AWS_EXTERNAL_ID value and aste it in the IAM trust policy key called sts:ExternalId:

creating event notifications in S3 to connect our Snowpipe: one for each folder in the bucket (album_data, songs_data, artist_data)
to connect the snowpipe: Run DESC pipe pipe.tbl_songs_pipe and copy the notification_channel value, go to your s3 bucket, create an event notification, under Destination select SQS Queue and select enter SQS queue ARN and paste in this value there.

add tirgger in lambda function

add CloudWatch trigger on top of our whole pipeline to run according to our business needs, whether that be every minute, hour, day, or week.

errors:
iam role
snowflake schema specification for pipes
