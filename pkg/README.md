# HomeRange
R package created to load, visualize and explore the HomeRange data set.

## Usage
```R
# Install HomeRange
library('devtools')
install_github("SHoeks/HomeRange")

# Load HomeRange
library('HomeRange')

# Use HomeRange functions
HomeRange<-getData()
map<-getMap()
getStats(HomeRange)
visualize(data = HomeRange, map = map, CountryBorder = FALSE, GeographicZoom = TRUE)
extract(HomeRange)
```
