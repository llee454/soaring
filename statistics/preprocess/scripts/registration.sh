# This gawk script downloads aircraft registration records into a CSV file.
#
# Accepts a modelCode for example: 3801539, 38015GY, and 3801548 are ASK 21s.

# Accepts one argument, $cmd, a bash command
# string, executes the command and returns an
# error message if it fails.
function execute () {
  local cmd=$1
  if [[ $verbose == 1 ]]
  then
    echo -e "Notice: $cmd" >&2
  fi
  eval $cmd
  [ $? == 0 ] || error "An error occured while trying to execute the following command: \"$cmd\"."
}

function genRecordsURL {
  local fileName=$1
  local modelCode=$2
  local stateAbbrev=$3

  echo "https://registry.faa.gov/aircraftinquiry/BusinessLogic/CreateMMSExcelCSV?FileName=$fileName&mms=$modelCode&state=$stateAbbrev&country=US"
}

function getRecordsURL {
  local fileName=$1
  # cmd = "date +%m-%d-%Y"
  # (cmd | getline date)
  # close(cmd)
  local date="01-27-2021"

  echo "https://registry.faa.gov/AircraftInquiry/SpreadSheets/$date/${fileName}${date}.csv"
}

function callURL {
  local url=$1
  cmd="wget --quiet '$url'"
  execute "$cmd"
}

function fetchURL {
  local outputFileName=$1
  local url=$2
  cmd="wget --quiet -O \"registration_records/${outputFileName}.csv\" '$url'"
  execute "$cmd"
}

resultFile="registration_records/all.csv"

for modelCode in "3801539" "38015GY" "3801548"
do
  for stateAbbrev in "AL" "AK" "AZ" "AR" "CA" "CO" "CT" "DE" "FL" "GA" "HI" "ID" "IL" "IN" "IA" "KS" "KY" "LA" "ME" "MD" "MA" "MI" "MN" "MS" "MO" "MT" "NE" "NV" "NH" "NJ" "NM" "NY" "NC" "ND" "OH" "OK" "OR" "PA" "RI" "SC" "SD" "TN" "TX" "UT" "VT" "VA" "WA" "WV" "WI" "WY"
  do
    recordsFile="records_${modelCode}_${stateAbbrev}"
    callURL $(getRecordsURL $recordsFile $modelCode $stateAbbrev)
    fetchURL $recordsFile $(getRecordsURL $recordsFile)
    tail --lines +6 registration_records/$recordsFile.csv >> $resultFile
  done
done
