import json
import os
import spotipy
from spotipy.oauth2 import SpotifyClientCredentials
from spotipy.oauth2 import SpotifyOAuth
import boto3
from datetime import datetime

def lambda_handler(event, context):
    client_id = os.environ.get('client_id')
    client_secret = os.environ.get('client_secret')
    client_credentials_manager = SpotifyClientCredentials(client_id=client_id, client_secret=client_secret)
    sp = spotipy.Spotify(client_credentials_manager = client_credentials_manager)
    playlists = sp.user_playlists('spotify')
    
    playlist_link = "https://open.spotify.com/playlist/37i9dQZEVXbMDoHDwVN2tF"
    playlist_URI = playlist_link.split("/")[-1].split("?")[0]
    
    spotify_data = sp.playlist_tracks(playlist_URI)
    
    filename = "spotify_raw_" + str(datetime.now()) + ".json"
    
    # upload json file to an s3 object
    client = boto3.client('s3')
    
    client.put_object(
        Bucket='spotify-etl-walker',
        Key='raw_data/to_processed/' + filename,
        Body=json.dumps(spotify_data)
    )
    # connect our lambda func for data extraction to our glue job deploying data transformation
    glue = boto3.client('glue')
    gluejobname = "spotify_transformation_job"

    try:
        glue.start_job_run(Jobname=gluejobname)
        status = glue.get_job_run(Jobname=gluejobname, RunId=runId['JobRunId'])
        print("Job Status : ", status['JobRun']['JobRunState'])
    except Exception as e:
        print(e)
