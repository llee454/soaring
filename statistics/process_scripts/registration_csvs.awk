# This gawk script downloads aircraft registration records into a CSV file.
#
# Accepts a modelCode for example: 3801539, 38015GY, and 3801548 are ASK 21s.

function genRecordsURL(fileName, modelCode, stateAbbrev) {
  return "https://registry.faa.gov/aircraftinquiry/BusinessLogic/CreateMMSExcelCSV?FileName=" fileName "&mms=" modelCode "&state=" stateAbbrev "&country=US"
}

function getRecordsURL(fileName) {
  # cmd = "date +%m-%d-%Y"
  # (cmd | getline date)
  # close(cmd)
  date = "01-27-2021"

  return "https://registry.faa.gov/AircraftInquiry/SpreadSheets/" date "/" fileName date ".csv"
}

function callURL(url) {
  cmd = "wget --quiet '" url "'"
  system(cmd)
  close("wget")
}

function fetchURL(outputFileName, url) {
  cmd = "wget --quiet -O \"registration_records/" outputFileName ".csv\" '" url "'"
  system(cmd)
  close("wget")
}

BEGIN {
  askModelCodes = "3801539 38015GY 3801548"

  numModelCodes = split(askModelCodes, modelCodes)

  numStateAbbrevs = split("AL AK AZ AR CA CO CT DE FL GA HI ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY", stateAbbrevs)

  for (i = 1; i <= numModelCodes; i ++) {
    for (j = 1; j <= numStateAbbrevs; j++) {
      recordsFile = "records_" modelCodes[i] "_" stateAbbrevs[j]
      callURL(genRecordsURL(recordsFile, modelCodes[i], stateAbbrevs[j]))
      fetchURL(recordsFile, getRecordsURL(recordsFile))
    }
  }
}
