var SearchMap = null;
var SearchMarkers = [];
var SearchInfoWindow = null;

function initializeSearchMap() {
  var dfltLoc = new google.maps.LatLng(36.114646, -115.172816);

  SearchMap = new google.maps.Map(document.getElementById("map-canvas"), {
    zoom:       12,
    mapTypeId:  google.maps.MapTypeId.ROADMAP,
  });
  SearchInfoWindow = new google.maps.InfoWindow({ content: '' })

  // map.setCenter(new google.maps.LatLng(lat, lng));

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(function(loc) {
      // Location found...
      // setSearchLocation(new google.maps.LatLng(loc.coords.latitude, loc.coords.longitude));
      setSearchLocation(dfltLoc);
    },
    function(error) {
      // Could not find location.
      // TODO: Notify the user?
      setSearchLocation(dfltLoc);
    },
    {
      enableHighAccuracy: true,
      timeout:            5000,
      maximumAge:         0,
    });
  } else {
    setSearchLocation(dfltLoc);
  }
}

function setSearchLocation(latLng) {
  SearchMap.setCenter(latLng);
  clearSearchMarkers();
  addSearchMarker(latLng, 'Your Location', 'http://maps.google.com/mapfiles/ms/icons/green-dot.png');

  // Find the locations for the new map asynchronously.
  $.ajax({
    url:    "/search/locations",
    data:   { lat: latLng.lat(), lng: latLng.lng() },
  })
  .done(function(rs) {
    $(rs).each(function(i, md) {
      var latLng = new google.maps.LatLng(md.lat, md.lng);
      addSearchMarker(latLng, md.title, null, function(marker) {
        html = _.template(
          "<b><%- md.title %></b><br/><br/><%- md.desc %>",
          { md: md }
        );

        SearchInfoWindow.setContent(html);
        SearchInfoWindow.open(SearchMap, marker);
      });
    });
  })
  .error(function(rs) {
    alert("Error: " + rs.responseJSON.error);
  });
}

function addSearchMarker(latLng, title, iconUrl, clickCallback) {
  var marker = new google.maps.Marker({
    position:   latLng,
    title:      title,
    map:        SearchMap,
    animation:  google.maps.Animation.DROP,
  });

  SearchMarkers.push(marker);

  if (iconUrl) {
    marker.setIcon(iconUrl);
  }

  if (clickCallback) {
    google.maps.event.addListener(marker, 'click', function() {
      clickCallback(marker);
    });
  }
}

function clearSearchMarkers() {
  var tmpMarkers = SearchMarkers;
  SearchMarkers = [];

  $(tmpMarkers).each(function(i, sm) {
    sm.setMap(null);
  })
}

function getLocationForZip(zipCode, callBack) {
  $.ajax({
      url:    "http://maps.googleapis.com/maps/api/geocode/json",
      data: {
        sensor:   'true',
        address:  zipCode,
      },
    })
    .done(function(rs) {
      if (rs && rs.status && rs.status=='OK' && rs.results) {
        callBack(rs.results[0]);
      } else {
        alert("Error retrieving the address, please try again later.");
      }
    })
    .error(function(e) {
      alert("Error: " + e);
    });
}


function handleSearchForZip(e) {
  e.stopPropagation();

  var zipCode = $('#search-zip').val();

  if (!zipCode || zipCode == '') {
    alert("Please fill in the zip code first!");
  } else {
    console.log("Should search for " + zipCode);
    getLocationForZip(zipCode, function(addr) {
      if (addr && addr.geometry && addr.geometry.location) {
        var loc    = addr.geometry.location;
        var latLng = new google.maps.LatLng(loc.lat, loc.lng);
        setSearchLocation(latLng);
      } else {
        alert("Could not get the location for " + zipCode + "!");
      }
    });
  }

  return false;
}

function handleSearchNearMe(e) {
  e.stopPropagation();

  navigator.geolocation.getCurrentPosition(function(loc) {
    setSearchLocation(new google.maps.LatLng(loc.coords.latitude, loc.coords.longitude));
  },
  function(error) {
    alert("Could not get your current location.");
  },
  {
    enableHighAccuracy: true,
    timeout:            5000,
    maximumAge:         0,
  });

  return false;
}
