library(shiny)          # For shiny app
library(shinydashboard) # For dashboard ui framework
library(googleway)      # For mapping

server <- shinyServer(function(input, output, session) {
  
  customers <- readRDS("customers.RDS")
  
  output$map <- renderGoogle_map({
    google_map(
      search_box = FALSE,
      # zoom_control = FALSE,
      street_view_control = FALSE,
      key = key,
      styles = dark.style
    )
  })
  
  observeEvent(input$generate_n_data,
               googleway::google_map_update(map_id="map") %>% 
                 clear_markers %>% 
                 googleway::add_markers(
                   data=sample_n(customers, input$n_data),
                   cluster = T,
                   lat="lat",
                   lon="lon"
                 )
  ) 
  
  
})

dark.style <- '[
{
  "elementType": "geometry",
  "stylers": [
  {
  "color": "#1d2c4d"
  }
  ]
},
  {
  "elementType": "labels.text.fill",
  "stylers": [
  {
  "color": "#8ec3b9"
  }
  ]
  },
  {
  "elementType": "labels.text.stroke",
  "stylers": [
  {
  "color": "#1a3646"
  }
  ]
  },
  {
  "featureType": "administrative.country",
  "elementType": "geometry.stroke",
  "stylers": [
  {
  "color": "#4b6878"
  }
  ]
  },
  {
  "featureType": "administrative.land_parcel",
  "elementType": "labels.text.fill",
  "stylers": [
  {
  "color": "#64779e"
  }
  ]
  },
  {
  "featureType": "administrative.province",
  "elementType": "geometry.stroke",
  "stylers": [
  {
  "color": "#4b6878"
  }
  ]
  },
  {
  "featureType": "landscape.man_made",
  "elementType": "geometry.stroke",
  "stylers": [
  {
  "color": "#334e87"
  }
  ]
  },
  {
  "featureType": "landscape.natural",
  "elementType": "geometry",
  "stylers": [
  {
  "color": "#023e58"
  }
  ]
  },
  {
  "featureType": "poi",
  "elementType": "geometry",
  "stylers": [
  {
  "color": "#283d6a"
  }
  ]
  },
  {
  "featureType": "poi",
  "elementType": "labels.text.fill",
  "stylers": [
  {
  "color": "#6f9ba5"
  }
  ]
  },
  {
  "featureType": "poi",
  "elementType": "labels.text.stroke",
  "stylers": [
  {
  "color": "#1d2c4d"
  }
  ]
  },
  {
  "featureType": "poi.park",
  "elementType": "geometry.fill",
  "stylers": [
  {
  "color": "#023e58"
  }
  ]
  },
  {
  "featureType": "poi.park",
  "elementType": "labels.text.fill",
  "stylers": [
  {
  "color": "#3C7680"
  }
  ]
  },
  {
  "featureType": "road",
  "elementType": "geometry",
  "stylers": [
  {
  "color": "#304a7d"
  }
  ]
  },
  {
  "featureType": "road",
  "elementType": "labels.text.fill",
  "stylers": [
  {
  "color": "#98a5be"
  }
  ]
  },
  {
  "featureType": "road",
  "elementType": "labels.text.stroke",
  "stylers": [
  {
  "color": "#1d2c4d"
  }
  ]
  },
  {
  "featureType": "road.highway",
  "elementType": "geometry",
  "stylers": [
  {
  "color": "#2c6675"
  }
  ]
  },
  {
  "featureType": "road.highway",
  "elementType": "geometry.stroke",
  "stylers": [
  {
  "color": "#255763"
  }
  ]
  },
  {
  "featureType": "road.highway",
  "elementType": "labels.text.fill",
  "stylers": [
  {
  "color": "#b0d5ce"
  }
  ]
  },
  {
  "featureType": "road.highway",
  "elementType": "labels.text.stroke",
  "stylers": [
  {
  "color": "#023e58"
  }
  ]
  },
  {
  "featureType": "transit",
  "elementType": "labels.text.fill",
  "stylers": [
  {
  "color": "#98a5be"
  }
  ]
  },
  {
  "featureType": "transit",
  "elementType": "labels.text.stroke",
  "stylers": [
  {
  "color": "#1d2c4d"
  }
  ]
  },
  {
  "featureType": "transit.line",
  "elementType": "geometry.fill",
  "stylers": [
  {
  "color": "#283d6a"
  }
  ]
  },
  {
  "featureType": "transit.station",
  "elementType": "geometry",
  "stylers": [
  {
  "color": "#3a4762"
  }
  ]
  },
  {
  "featureType": "water",
  "elementType": "geometry",
  "stylers": [
  {
  "color": "#0e1626"
  }
  ]
  },
  {
  "featureType": "water",
  "elementType": "labels.text.fill",
  "stylers": [
  {
  "color": "#4e6d70"
  }
  ]
  }
  ]'
  