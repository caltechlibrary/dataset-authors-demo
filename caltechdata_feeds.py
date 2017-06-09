import argparse
import urllib.request
import urllib.parse
import urllib.error
import ssl
import json
import os

def read_records(data):
    #read records in 'hits' structure
    for record in data:
        rid = str(record['id'])

        outstr = json.dumps(record)

        #Replace single quotes with complicated escape
        outstr = outstr.replace("'","'\\''")

        os.system("dataset create "+str(record['id'])+'.json'+" '"+outstr+"'")
        print(str(rid))

if __name__ == "__main__":

    parser = argparse.ArgumentParser(description=\
    "caltechdata_read queries the caltechDATA (Invenio 3) API\
    and adds metadata to dataset for library feeds")

    os.environ["DATASET"] = "caltechdata"

    args = parser.parse_args()

    api_url = "https://caltechdata.tind.io/api/records/"

    req = urllib.request.Request(api_url)
    s = ssl.SSLContext(ssl.PROTOCOL_SSLv23)
    response = urllib.request.urlopen(req,context=s)
    data = json.JSONDecoder().decode(response.read().decode('UTF-8'))

    read_records(data['hits']['hits'])

    #if we have more pages of data
    while 'next' in data['links']:
        req = urllib.request.Request(data['links']['next'])
        response = urllib.request.urlopen(req,context=s)
        data = json.JSONDecoder().decode(response.read().decode('UTF-8'))

        read_records(data['hits']['hits'])


