# This script estimates the number of hours flown by a given model
# of sailplanes by scraping data from a variety of sources. See the
# directory Readme for more information.

makeCode='230'         # Wings and Wheels make code (in URL)
modelCode='565'        # Wings and Wheels model code (in URL)
modelName='ASK-21'     # registry.faa.gov model name
totalNumAircraft='994' # estimate of the total number of gliders manufactured.

gawk -f saleRecords.awk $makeCode $modelCode
exit 0

# II. estimate the utilization rate of the aircraft model
utilRate=$(gawk -f saleRecords.awk $makeCode $modeCode \
  | tail --lines=1)

echo "estimated utilization rate: $utilRate"

# I. estimate the age distribution of a sample of aircraft
gawk -f registration.awk $modelName \
  | tail --lines=+2 \
  | cut --fields=2 --delimiter=' ' \
  | sort \
  | grep . \
  | gawk -v totalNumAircraft=$totalNumAircraft -v utilizationRate=$utilRate -f hours.awk

echo "done"
