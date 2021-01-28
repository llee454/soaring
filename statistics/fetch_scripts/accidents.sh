# This script refers to the Aviation Safety Network to estimate
# the number of accidents that an aircraft model has been involved in.
#
# https://aviation-safety.net/wikibase/dblist2.php?at=SZD-48&re=&pc=G&op=&fa=0&lo=&co=&ph=&na=&submit=Submit

modelName="ASK-21"

accidentsFileName=$(mktemp)

wget --no-check-certificate -O $accidentsFileName 'https://aviation-safety.net/wikibase/dblist2.php?at='$modelName'&re=&pc=G&op=&fa=0&lo=&co=&ph=&na=&submit=Submit'

vim $accidentsFileName

grep --extended '([0-9]*) occurrences in the ASN safety database' $accidentsFileName \
  | cut --fields=1 
