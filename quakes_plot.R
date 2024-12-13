library(ggplot2)
library(ggspatial)
library(sf)

data <- read.csv("quakes.csv")
data$class <- ifelse(data$long > 175, "Tonga trench", "Plate junction") ## separate the two groups of events


## transform to sf object
quakes_sf <- st_as_sf(data , coords =c ("long","lat") , crs = 4326) |> 
  st_transform(crs=3994)

## get countries
world <- rnaturalearth::ne_countries(scale = "medium", returnclass = "sf")
fiji <- subset(world, sovereignt == "Fiji", select= "geometry")
NZ <- subset(world, sovereignt == "New Zealand", select= "geometry")
samoa <- subset(world, sovereignt == "Samoa", select= "geometry")
tonga <- subset(world, sovereignt == "Tonga", select= "geometry")
VT <- subset(world, sovereignt == "Vanuatu", select= "geometry")
AU <- subset(world, sovereignt == "Australia", select= "geometry")

ggplot(quakes_sf) + 
  geom_sf(data= fiji |> st_transform(crs=3994))+
  geom_sf(data= NZ |> st_transform(crs=3994))+
  geom_sf(data= samoa |> st_transform(crs=3994))+
  geom_sf(data= tonga |> st_transform(crs=3994))+
  geom_sf(data= VT |> st_transform(crs=3994))+
  geom_sf(data= AU |> st_transform(crs=3994))+
  #nnotation_map_tile(zoomin = -1, zoom = 3, type = "osm") +
  geom_sf(aes(color = class, shape = class), alpha = 0.1)  + theme_bw() + 
  guides(colour = guide_legend(override.aes = list(alpha = 1))) + 
  theme(legend.position = "bottom", legend.title = element_blank(),
        legend.box.spacing = unit(0, "pt"))


ggsave(filename = "map.pdf", width = 4, height = 4)
