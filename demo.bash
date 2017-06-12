#!/bin/bash
if [ -d caltechauthors ]; then
    rm -fR caltechauthors
fi
if [ -d caltechdata ]; then
    rm -fR caltechdata
fi
if [ -d caltechauthors.bleve ]; then
    rm -fR caltechauthors.bleve
fi
if [ -d caltechdata.bleve ]; then
    rm -fR caltechdata.bleve
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
python3 caltechdata_feeds.py

echo ""
echo "Run dsindexer to index our collections based on our definition in caltechauthors.json and caltechdata.json"
read -p "Press any key to run command, ctrl-C to exit" NEXT
dsindexer -c caltechauthors caltechauthors.json
dsindexer -c caltechdata caltechdata.json

echo ""
echo "Run dsws for a web searchable version of our collection"
read -p "Press any key to run command, ctrl-C to exit" NEXT
echo ""
echo "Open your web browser and go to http://localhost:8011"
echo ""
dsws -dev-mode=true -t templates caltechauthors.bleve caltechdata.bleve


