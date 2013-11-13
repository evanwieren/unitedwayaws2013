# config/initializers/geocoder.rb
Geocoder.configure(

    # geocoding service:
    :lookup => :mapquest,

    # to use an API key:
    :api_key => 'Fmjtd%7Cluubn9ualu%2Cax%3Do5-9022qw',

    :licensed => true,

    # caching (see below for details):
    :cache => Redis.new,
    :cache_prefix => 'map',

    # geocoding service request timeout, in seconds (default 3):
    :timeout => 5,

    # set default units to kilometers:
    :units => :m,
)

