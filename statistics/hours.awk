# This gawk script accepts a sorted list of manufacturing years from
# aircraft registrations and returns the estimated proportion of
# aircraft having the given age.
#
# generate source data using:
#
# gawk -f registration.awk 'ASK-21' | tail --lines=+2 | cut --fields=2 --delimiter=' ' | sort | grep .
#
# process using:
#
# gawk -v totalNumAircraft=997 -v utilizationRate=100 -f ageDistribution.awk data.dat


BEGIN {
  numAircraft = 0
  maxAge      = 0
  prevAge     = 0
}
/([0-9])*/ {
  numAircraft = numAircraft + 1
  currAge = 2020 - $1
  if (currAge == prevAge) {
    ages[prevAge] = ages[prevAge] + 1
  } else {
    prevAge = currAge
    ages[currAge] = 1
    if (maxAge < currAge) {
      maxAge = currAge
    }
  }
}
END {
  # totalNumAircraft = ARGV[1]
  # utilizationRate  = ARGV[2]

  totalHours = 0
  for (i = 0; i < maxAge; i ++) {
    # the total number of aircraft aged i
    numAircraftAge = (ages[i] / numAircraft) * totalNumAircraft
    # the number of hours flown in aircraft aged i
    numHours = i * utilizationRate
    
    totalHours = totalHours + (numAircraftAge * numHours)
  }
  print "estimated total number of hours: " totalHours
}
