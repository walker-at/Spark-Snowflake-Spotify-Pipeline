# Spark-Snowflake-Pipeline

understand music industry
analyze top global songs availble on spotify playlist called "top songs - global"
extract from spotify api

extract data and apply trasnformation logic with apache spark, before loading into snowflake

write our extraction code in python and deploy it on AWS Lambda. on top of that we will apply Amazon CloudWatch (daily trigger) to schedule when our code should run. it will run our lambda function to extract data from the spotify api and put the raw data on Amazon S3, which will trigger our transformation logic written in apache spark to be performed on this raw data.

on the spotify api we have artists, album info, and track info available

using json file

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
