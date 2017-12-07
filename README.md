[![Travis build statis:](https://travis-ci.org/mikeappell/polling-api-challenge.svg?branch=master)](https://travis-ci.org/mikeappell/polling-api-challenge)

# Auto-Updating Weather Report (polls OpenWeatherMaps API)

This is the solution to a code challenge, the requirements being:

- Collect data from an API which generates data on an interval
- Build a web app which displays this data in both chart and report format
- Deploy somewhere free (I've chosen [Heroku](https://polling-api-challenge.herokuapp.com/))

Note: Gaps in data (e.g. data points skipping from 23:15 to 7:45) represent periods when the Rails server wasn't running, and so new data wasn't being collected.

----

### The solution

The Rails back-end has a wrapper for the OpenWeatherMaps API, making it easy to poll the current data (currently locked to NYC as the location). Polling this returns a JSON object in the following format (see [here](https://openweathermap.org/current) for an explanation of values):

```
{"coord"=>
  {"lon"=>-74.01, "lat"=>40.71},
"weather"=>
  [{"id"=>800, "main"=>"Clear", "description"=>"clear sky", "icon"=>"01d"}],
"base"=>"stations",
"main"=>
  {"temp"=>38.89, "pressure"=>1017, "humidity"=>51, "temp_min"=>33.8, "temp_max"=>42.8},
"visibility"=>16093,
"wind"=>
  {"speed"=>9.17, "deg"=>290},
"clouds"=>
  {"all"=>1},
"dt"=>1512656100, // Timestamp in seconds since epoch
"sys"=>
  {"type"=>1, "id"=>1969, "message"=>0.0049, "country"=>"US", "sunrise"=>1512648435, "sunset"=>1512682109},
"id"=>5128581,
"name"=>"New York",
"cod"=>200}
```

The only data model present is called DataPoint; it encapsulates the data returned by this specific API (so it isn't general to other potential APIs unfortunately). It has utility methods to return `date_and_time` as a date object/`time` as a string/`weather` as a slightly better formatted weather description.

[Sidekiq](https://github.com/mperham/sidekiq/) is used to encapsulate the logic of polling the API and saving a new DataPoint in a background job. If the API returns a data point with a timestamp which is already persisted, no new object is created (the API only seems to return new data every ~30 minutes or so.)

I use the [Sidekiq-cron](https://github.com/ondrejbartas/sidekiq-cron/) gem to create a schedule which polls the API every five minutes (a bit optimistic considering how often the API actually updates its data.) As long as the rails server is running, the cron job is running, and new data is being created.

The front-end is a single React component, ChartAndReport.jsx. It encapsulates two React components: Uber's [React-vis](https://github.com/uber/react-vis/) library for creating data visualizations (i.e. charts), and React Tools' [React-table](https://github.com/react-tools/react-table) library for displaying this data in table format.

A Rails API controller was created to send the 20 most recent DataPoints as JSON; every five minutes, the front-end polls this API to update the current weather data. There's a timer shown to let the user know when the next update is coming (most updates don't result in new data, again because of how infrequently OpenWeatherMaps' API returns new data.)

----

### Run it yourself

You'll need to create an account on [OpenWeatherMaps](https://openweathermap.org/) in order to receive an API key. Once available, make sure to export this in your local environment as `OPENWEATHERMAP_API_KEY` (e.g. `export 'OPENWEATHERMAP_API_KEY=yourapikeyhere'`)

Run `bundle install` and `npm install`.

From there, simply run `foreman start -f Procfile.dev` to run the Procfile intended for local development (runs rails server/postgres/redis/sidekiq/webpack). Immediately, you should see a cron job entitled `update_weather` loaded into Sidekiq.

At first, you won't have many data points; these will be created in time as the API returns new data which is imported into postgres.

----

### Things I'd love to improve

- More tests! There are some model tests for DataPoint present, but more are needed, as well as controller and feature tests. Jest should be used to test the main React component as well.
- Make this API-agnostic (either generalize DataPoint to other APIs (tricky) or rename it to `OpenWeatherMapDataPoint` and create models for other API's JSON signatures.) New wrappers would need to be created for each API.
- Make this location-agnostic: right now, it's specific to NYC, but it would be great if that weren't the case. This would require a pretty significant rewrite though, as data points are currently being polled/created progressively through time, so switching to a new location would leave a gap in time for that location/stop collecting data points for the old location.
- It would be nice if the Rails back end pushed new data causing the front end to update, rather than polling the back end on a timer for new updates.
- Lots of other small stuff. Could be prettier, could include weather icons, could change colors to represent different weather conditions, could do your laundry for you. I could think of a million changes I'd like to make but c'est la vie.

----

Hope you like it!