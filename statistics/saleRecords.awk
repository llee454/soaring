# THis gawk script parses glider ads on Wings and Wheels to sample
# the number of hours accumulated on various glider models.
#
# https://wingsandwheels.com/classifieds/gliders.html?make=230&marketplace_status=6188&model=570
#

# Accepts two arguments: outputFileName, a string that represents
# a file name; and url, a string that represents a URL; fetches the
# resource referenced by URL and stores its contents in outputFileName.
function fetchURL(outputFileName, url) {
  cmd = "wget --quiet --no-check-certificate -O \"" outputFileName "\" '" url "'"
  system(cmd)
  close("wget")
}

# Accepts three arguments: makeCode, a string that represents the
# manufacturer's code; modelCode, a string that represents the model's
# code; and pageNumber, an integer; and returns the URL that should
# be fetched to retreive the associated listings.
function listingsURL(makeCode, modelCode, pageNumber) {
  return "https://wingsandwheels.com/classifieds/gliders.html?make=" makeCode "&model=" modelCode "&p=" pageNumber
}

# Creates a new temp file and returns its name as a string.
function createTempFile() {
  ("mktemp" | getline fileName)
  close("mktemp")
  return fileName
}

BEGIN {
  makeCode  = ARGV[1]
  modelCode = ARGV[2]

  listingsFileName = createTempFile()

  numListings = 0
  numScannedListings = 0
  pageNumber = 1

  do {
    inYear  = 0
    inHours = 0
    year  = ""

    fetchURL(listingsFileName, listingsURL(makeCode, modelCode, pageNumber))

    while ((getline currentLine < listingsFileName) > 0) {
      if (match(currentLine, "<span class=\"toolbar-number\">([0-9]*)</span>", matches)) {
        numListings = matches[1]
      }
      if (match(currentLine, "<strong>YEAR: </strong>")) { inYear = 1 }
      if (inYear && match(currentLine, "<span>([0-9]*)</span>", matches)) {
        inYear = 0
        year = matches[1]
      }
      if (match(currentLine, "<strong>TOTAL TIME: </strong>")) { inHours = 1 }
      if (inHours && match(currentLine, "<span>([0-9]*)</span>", matches)) {
        inHours = 0
        utilization = matches[1] / (2020 - year)
        utilizations[numScannedListings] = utilization
        numScannedListings = numScannedListings + 1
        print year " " matches[1] " " utilization
      }
    }
    pageNumber = pageNumber + 1
    close (listingsFileName)
  } while (numScannedListings < numListings)

  totalUtilization = 0.0
  for (i = 0; i < numScannedListings; i ++) {
    totalUtilization = totalUtilization + utilizations[i]
  }
  print "average hours/year: "
  print (totalUtilization / numScannedListings)
}
