#!/bin/bash
if [ -d caltechauthors ]; then
    rm -fR caltechauthors
fi
if [ -d caltechauthors.bleve ]; then
    rm -fR caltechauthors.bleve
fi

echo "Run dataset command and create our collection from our CaltechAUTHORS sample"
read -p "Press any key to run command, ctrl-C to exit" NEXT
$(dataset init caltechauthors)
for ITEM in $(ls authors/*.json); do
    ID=$(jsoncols -i "${ITEM}" .id)
    dataset -i "${ITEM}" create "${ID}";
    echo "ID: ${ID}, Item: ${ITEM}"
done

echo "Grab records from CaltechDATA and create collection"
read -p "Press any key to run command, ctrl-C to exit" NEXT
$(dataset init caltechdata)
python caltechdata_feeds.py

echo ""
echo "Run dsindexer to index our collection based on our definition in caltechauthors.json"
read -p "Press any key to run command, ctrl-C to exit" NEXT
dsindexer -c caltechauthors caltechauthors.json
dsindexer -c caltechdata caltechdata.json

#echo "Run dsfind to generate a CSV table from id, title, authors_id, orcid searching for Singh-C"
#read -p "Press any key to run command, ctrl-C to exit" NEXT
#dsfind -c authors -fields="id,title,authors_id,orcid" -csv 'Singh-C'

echo ""
echo "Run dsws for a web searchable version of our collection"
read -p "Press any key to run command, ctrl-C to exit" NEXT
echo "Open your web browser and go to http://localhost:8011"
dsws -dev-mode=true -t templates caltechauthors.bleve caltechdata.bleve


