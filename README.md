# Spark-Snowflake-Pipeline

understand music industry
analyze top global songs availble on spotify playlist called "top songs - global"
extract from spotify api

extract data and apply trasnformation logic with apache spark, before loading into snowflake

write our extraction code in python and deploy it on AWS Lambda. on top of that we will apply Amazon CloudWatch (daily trigger) to schedule when our code should run. it will run our lambda function to extract data from the spotify api and put the raw data on Amazon S3, which will trigger our transformation logic written in apache spark to be performed on this raw data.

on the spotify api we have artists, album info, and track info available
