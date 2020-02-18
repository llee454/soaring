# This gawk script parses aircraft registration information from
#
# https://registry.faa.gov/aircraftinquiry/AcftRef_Results.aspx?
#   Mfrtxt=&Modeltxt=ASK-21&PageNo=1
#
# and prints this information as a dat file that can be parsed
# by Maxima.

function searchURL(urlPrefix, modelName, pageNumber) {
  return urlPrefix "AcftRef_Results.aspx?Mfrtxt=&Modeltxt=" modelName "&PageNo=" pageNumber
}

function fetchURL(outputFileName, url) {
  cmd = "wget --quiet -O \"" outputFileName "\" '" url "'"
  system(cmd)
  close("wget")
}

BEGIN {
  urlPrefix = "https://registry.faa.gov/aircraftinquiry/"
  currentPage = 1
  modelName = ARGV[1]

  ("mktemp" | getline searchResultsFileName)
  close("mktemp")
  ("mktemp" | getline makeModelFileName)
  close("mktemp")
  ("mktemp" | getline regFileName)
  close("mktemp")

  fetchURL(searchResultsFileName, searchURL(urlPrefix, modelName, currentPage))

  numMakeModelURLs = 0
  maxPageNum = 10
  while ((getline currentLine < searchResultsFileName) > 0) {
    if (match(currentLine, "Mms_Results.aspx\\?Mmstxt=([^&]*)", searchResultsMatches)) {
      makeModelNum = searchResultsMatches[1]
      for (pageNum = 1; pageNum <= maxPageNum; pageNum ++) {
        makeModelURL = "Mms_results.aspx?Mmstxt=" makeModelNum "&conVal=0&PageNo=" pageNum
        makeModelURLs[numMakeModelURLs] = makeModelURL
        numMakeModelURLs ++
      }
    }
  }
  close(searchResultsFileName)
   
  print "Registration YearManufactured"

  makeModelURLIndex = 0
  while (makeModelURLIndex < numMakeModelURLs) {
    makeModelURL = makeModelURLs[makeModelURLIndex]
    makeModelURLIndex ++

    fetchURL(makeModelFileName, urlPrefix makeModelURL)
    while ((getline makeModelCurrentLine < makeModelFileName) > 0) {
      regNum  = ""
      manYear = ""

      # goto aircraft registration page
      if (match (makeModelCurrentLine, "NNum_Results.aspx\\?NNumbertxt=([^\"]*)", makeModelMatches)) {
        regNum = makeModelMatches[1]
        regURL = makeModelMatches[0]

        fetchURL(regFileName, urlPrefix regURL)
        while ((getline regCurrentLine < regFileName) > 0) {
          if (match (regCurrentLine, "<span id=\"ctl00_content_Label17\" class=\"Results_DataText\">([^<]*)</span>", matches)) {
            if (matches[1] != "None") {
              manYear = matches[1];
            }
            break
          }
        }
        close(regFileName)
        print regNum " " manYear
      }
    }
    close(makeModelFileName)
  }
}
