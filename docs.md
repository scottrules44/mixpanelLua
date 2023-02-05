# Setup

1. Setup a Mixpanel Account
2. Create a Project (the drop down in the top right)
3. Go to settings dropdown > Project Settings> Select project you want to use
4. In overview page you need: Project ID (under "Project Details" for query.*),
Project Token(under "Access Keys" for ingestion.*)
5. In the Project Settings section you need a "Service Account" for all query.* api (and ingestion.import()),
I recommend an admin account for the query.* api.
6. In the same folder look for "mixpanelRequest.lua" file and drag into your project.

# Initializing (Init)

Initializing the plugin is completely optional but is recommend.
As you will see you can pass in each of these params into each request (expect location)

Here is an example
```
local mixpanelR = require "mixpanelRequest"
mixpanelR.init({projectId=00000000, --Number
  listener=mixpanelCallback,--(function) is global callback for all mixpanel events (See #Events)
	username="service account username", --String
	password="service account password",--String
	token="your project token", --String
	location="eu",--(String) remove if want data stored in US instead EU
  workspaceId =000000, --Number, The id of the workspace if applicable
})
```


# Functions

### mixpanelR.init() --See Section Above #Initializing



## mixpanelRequest.query.*

### .insight(params)
Get data from your Insights reports.
(https://developer.mixpanel.com/reference/insights-query)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.bookmarkId(Number)(required)
^The ID of your Insights report can be found from the url: https://mixpanel.com/report/1/insights#report/<YOUR_BOOKMARK_ID>/example-report


### .funnel(params)
Get data for a funnel.
(https://developer.mixpanel.com/reference/funnels-query)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.funnelId(Number)(required)
^The funnel that you wish to get data for

params.fromDate(String)(required)
^The date in yyyy-mm-dd format to begin querying from. This date is inclusive.

params.toDate(String)(required)
^The date in yyyy-mm-dd format to query to. This date is inclusive.

params.length(Number)(optional)
^The number of units (defined by length_unit) each user has to complete the funnel, starting from the time they triggered the first step in the funnel. May not be greater than 90 days. Note that we will query for events past the end of to_date to look for funnel completions. This defaults to the value that was previously saved in the UI for this funnel.

params.lengthUnit(String)(optional)
^The unit applied to the length parameter can be "second", "minute", "hour", or "day". Defaults to the value that was previously saved in the UI for this funnel.


params.interval(Number)(optional)
^The number of days you want each bucket to contain. The default value is 1.


params.unit(String)(optional)
^This is an alternate way of specifying interval and can be "day", "week", or "month".

params.on(String)(optional)
^The property expression to segment the event on. See the expression to segment below. (https://developer.mixpanel.com/reference/segmentation-expressions)

params.where(String)(optional)
^An expression to filter events by. See the expression to segment below. (https://developer.mixpanel.com/reference/segmentation-expressions)

params.limit(Number)(optional)
^Return the top property values. Defaults to 255 if not explicitly included. Maximum value 10,000. This parameter does nothing if "on" is not specified.




### .funnelList(params)
Get the names and funnelIds of your funnels.
(https://developer.mixpanel.com/reference/funnels-list-saved)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())



### .retention(params)
Get cohort analysis.
(https://developer.mixpanel.com/reference/retention-query)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())


params.fromDate(String)(required)
^The date in yyyy-mm-dd format to begin querying from. This date is inclusive.

params.toDate(String)(required)
^The date in yyyy-mm-dd format to query to. This date is inclusive.

params.retentionType(String)(optional)
^Must be either "birth" or "compounded". Defaults to "birth". The “birth” retention type corresponds to first time retention. The “compounded” retention type corresponds to recurring retention. See the Types of Retention article for more information. (https://help.mixpanel.com/hc/en-us/articles/360001370146)

params.bornEvent(String)(optional)
^The first event a user must do to be counted in a birth retention cohort. Required when retention_type is "birth"; ignored otherwise.

params.event(String)(optional)
^The event to generate returning counts for. Applies to both birth and compounded retention. If not specified, we look across all events.

params.bornWhere(String)(optional)
^An expression to filter born_events by. See the expressions section above.(https://developer.mixpanel.com/reference/segmentation-expressions)

params.interval(Number)(optional)
^The number of units (can be specified in either days, weeks, or months) that you want per individual bucketed interval. May not be greater than 90 days if days is the specified unit. The default value is 1.

params.intervalCount(Number)(optional)
^The number of individual buckets, or intervals, that are returned; defaults to 1. Note that we include a "0th" interval for events that take place less than one interval after the initial event.

params.unboundedRetention(Boolean)(optional)
^A counting method for retention queries where retention values accumulate from right to left, i.e. day N is equal to users who retained on day N and any day after. The default value of false does not perform this accumulation. (https://help.mixpanel.com/hc/en-us/articles/360045484191)

params.unit(String)(optional)
^This is an alternate way of specifying interval and can be "day", "week", or "month".

params.on(String)(optional)
^The property expression to segment the event on. See the expression to segment below. (https://developer.mixpanel.com/reference/segmentation-expressions)

params.where(String)(optional)
^An expression to filter events by. See the expression to segment below. (https://developer.mixpanel.com/reference/segmentation-expressions)

params.limit(Number)(optional)
^Return the top limit segmentation values. This parameter does nothing if "on" is not specified.

### .retentionAddiction(params)
Get data about how frequently users are performing events.
(https://developer.mixpanel.com/reference/retention-frequency-query)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.fromDate(String)(required)
^The date in yyyy-mm-dd format to begin querying from. This date is inclusive.

params.toDate(String)(required)
^The date in yyyy-mm-dd format to query to. This date is inclusive.

params.unit(String)(required)
^This is an alternate way of specifying interval and can be "day", "week", or "month".

params.addictionUnit(String)(required)
^The granularity to return frequency of actions at can be "hour" or "day".

params.event(String)(optional)
^The event to generate returning counts for.

params.on(String)(optional)
^The property expression to segment the event on. See the expression to segment below. (https://developer.mixpanel.com/reference/segmentation-expressions)

params.where(String)(optional)
^An expression to filter events by. See the expression to segment below. (https://developer.mixpanel.com/reference/segmentation-expressions)

params.limit(Number)(optional)
^Return the top limit segmentation values. This parameter does nothing if "on" is not specified.

### .segmentation(params)
Get data for an event, segmented and filtered by properties.
(https://developer.mixpanel.com/reference/segmentation-query)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.fromDate(String)(required)
^The date in yyyy-mm-dd format to begin querying from. This date is inclusive.

params.toDate(String)(required)
^The date in yyyy-mm-dd format to query to. This date is inclusive.

params.event(String)(required)
^The event that you wish to get data for. Note: this is a single event name, not an array.

params.unit(String)(optional)
^This can be "minute", "hour", "day", or "month". This determines the buckets into which the property values that you segment on are placed. The default value is "day".

params.interval(Number)(optional)
^Optional parameter in lieu of 'unit' when 'type' is not 'general'. Determines the number of days your results are bucketed into can be used with or without 'from_date' and 'to_date' parameters.

params.type(String)(optional)
^This can be "general", "unique", or "average". If this is set to "unique", we return the unique count of events or property values. If set to "general", we return the total, including repeats. If set to "average", we return the average count. The default value is "general".

params.format(String)(optional)
^Can be set to "csv".

params.on(String)(optional)
^The property expression to segment the event on. See the expression to segment below. (https://developer.mixpanel.com/reference/segmentation-expressions)

params.where(String)(optional)
^An expression to filter events by. See the expression to segment below. (https://developer.mixpanel.com/reference/segmentation-expressions)

params.limit(Number)(optional)
^Return the top property values. Defaults to 60. Maximum value 10,000. This parameter does nothing if "on" is not specified.

### .segmentationNumeric(params)
Get data for an event, segmented and filtered by properties, with values placed into numeric buckets.
(https://developer.mixpanel.com/reference/segmentation-numeric-query)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.fromDate(String)(required)
^The date in yyyy-mm-dd format to begin querying from. This date is inclusive.

params.toDate(String)(required)
^The date in yyyy-mm-dd format to query to. This date is inclusive.

params.on(String)(required)
^The property expression to segment the event on. This expression must be a numeric property (https://developer.mixpanel.com/reference/segmentation-expressions)

params.event(String)(required)
^The event that you wish to get data for. Note: this is a single event name, not an array.

params.unit(String)(optional)
^This can be "hour" or "day". This determines the buckets into which the property values that you segment on are placed. The default value is "day".

params.type(String)(optional)
^This can be "hour" or "day". This determines the buckets into which the property values that you segment on are placed. The default value is "day".

params.where(String)(optional)
^An expression to filter events by. See the expression to segment below. (https://developer.mixpanel.com/reference/segmentation-expressions)

### .segmentationSum(params)
Sums an expression for events per unit time.
(https://developer.mixpanel.com/reference/segmentation-sum-query)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.fromDate(String)(required)
^The date in yyyy-mm-dd format to begin querying from. This date is inclusive.

params.toDate(String)(required)
^The date in yyyy-mm-dd format to query to. This date is inclusive.

params.on(String)(required)
^The expression to sum per unit time. The result of the expression should be a numeric value. If the expression is not numeric, a value of 0.0 is assumed. (https://developer.mixpanel.com/reference/segmentation-expressions)

params.event(String)(required)
^The event that you wish to get data for. Note: this is a single event name, not an array.

params.unit(String)(optional)
^This can be "hour" or "day". This determines the buckets into which the property values that you segment on are placed. The default value is "day".

params.where(String)(optional)
^An expression to filter events by. See the expression to segment below. (https://developer.mixpanel.com/reference/segmentation-expressions)

### .segmentationAverage(params)
Averages an expression for events per unit time.
(https://developer.mixpanel.com/reference/segmentation-query-average)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.fromDate(String)(required)
^The date in yyyy-mm-dd format to begin querying from. This date is inclusive.

params.toDate(String)(required)
^The date in yyyy-mm-dd format to query to. This date is inclusive.

params.on(String)(required)
^The expression to sum per unit time. The result of the expression should be a numeric value. If the expression is not numeric, a value of 0.0 is assumed. (https://developer.mixpanel.com/reference/segmentation-expressions)

params.event(String)(required)
^The event that you wish to get data for. Note: this is a single event name, not an array.

params.unit(String)(optional)
^This can be "hour" or "day". This determines the buckets into which the property values that you segment on are placed. The default value is "day".

params.where(String)(optional)
^An expression to filter events by. See the expression to segment below. (https://developer.mixpanel.com/reference/segmentation-expressions)



### .userActivity(params)
This endpoint returns the activity feed for specified users.
(https://developer.mixpanel.com/reference/activity-stream-query)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.fromDate(String)(required)
^The date in yyyy-mm-dd format to begin querying from. This date is inclusive.

params.toDate(String)(required)
^The date in yyyy-mm-dd format to query to. This date is inclusive.

params.distinctIds(Array of Strings)(required)
^A array of strings representing the distinctIds to return activity feeds for.

### .listCohorts(params)
The list endpoint returns all of the cohorts in a given project. The JSON formatted return contains the cohort name, id, count, description, creation date, and visibility for every cohort in the project.
(https://developer.mixpanel.com/reference/cohorts-list)
(Query user profile data and return list of users that fit specified parameters.)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())


### .profilesQuery(params)
Query user profile data and return list of users that fit specified parameters.
(https://developer.mixpanel.com/reference/engage-query)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.fromDate(String)(required)
^The date in yyyy-mm-dd format to begin querying from. This date is inclusive.

params.toDate(String)(required)
^The date in yyyy-mm-dd format to query to. This date is inclusive.

params.distinctIds(Array of Strings)(optional)
^A array of strings representing the distinctIds to retrieve profiles for.

params.distinctId(String)(optional)
^A unique identifier used to distinguish an individual profile.

params.where(String)(optional)
^An expression to filter events by. See the expression to segment below. (https://developer.mixpanel.com/reference/segmentation-expressions)

params.outputProperties(Array of Strings)(optional)
^A array of names of properties you want returned.
This parameter can drastically reduce the amount of data returned by the API when you're not interested in all properties and can speed up queries significantly.

params.sessionId(String)(optional)
^A string id provided in the results of a previous query. Using a sessionId speeds up api response, and allows paging through results.

params.page(Number)(optional)
^Which page of the results to retrieve. Pages start at zero. If the "page" parameter is provided, the session_id parameter must also be provided.

params.behaviors(Number)(optional)
^If you are exporting user profiles using an event selector, you use a behaviors parameter in your request. behaviors and filterByCohort are mutually exclusive.

params.asOfTimestamp(Number)(optional)
^This parameter is only useful when also using behaviors.
If you try to export more than 1k profiles using a behaviors parameter and you don't included the parameter asTfTimestamp, you'll see the following error:

request for page in uncached query for params

params.filterByCohort(String)(optional)
^Takes a JSON object with a single key called id whose value is the cohort ID. behaviors and filterByCohort are mutually exclusive.

params.includeAllUsers(Boolean)(optional)
^includeAllUsers=True means that the Engage API will include distinctIds that don’t have a user profile. This is the default.

includeAllUsers=False means that the Engage API will only include distinctIds with user profiles.

*this parameter is only applied when combined with filterByCohort


### .totalEvents(params)
Get unique, total, or average data for a set of events over N days, weeks, or months.
(https://developer.mixpanel.com/reference/list-recent-events)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.fromDate(String)(required)
^The date in yyyy-mm-dd format to begin querying from. This date is inclusive.

params.toDate(String)(required)
^The date in yyyy-mm-dd format to query to. This date is inclusive.

params.event(String)(required)
^The event or events that you wish to get data for, encoded as a JSON array. Example format: "["play song", "log in", "add playlist"]".

params.type(String)(required)
^The analysis type you would like to get data for - such as general, unique, or average events. Valid values: "general", "unique", or "average".

params.unit(String)(required)
^This can be "minute", "hour", "day", "week", or "month". It determines the level of granularity of the data you get back. Note that you cannot get hourly uniques.

params.interval(Number)(optional)
^The number of "units" to return data for - minutes, hours, days, weeks, or months. 1 will return data for the current unit (minute, hour, day, week or month). 2 will return the current and previous units, and so on. Specify either interval or fromDate and toDate.

params.format(String)(optional)
^The data return format, such as JSON or CSV. Options: "json" (default), "csv".


### .topEvents(params)
Get the top events for today, with their counts and the normalized percent change from yesterday.
(https://developer.mixpanel.com/reference/query-top-events)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.type(String)(required)
^The analysis type you would like to get data for - such as general, unique, or average events. Valid values: "general", "unique", or "average".

params.limit(number)(optional)
^The maximum number of events to return. Defaults to 100.

### .topEventNames(params)
Get a list of the most common events over the last 31 days.
(https://developer.mixpanel.com/reference/query-months-top-event-names)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.type(String)(required)
^The analysis type you would like to get data for - such as general, unique, or average events. Valid values: "general", "unique", or "average".

params.limit(number)(optional)
^The maximum number of values to return. Defaults to 255.

### .eventProperties(params)
Get unique, total, or average data for of a single event and property over days, weeks, or months.
(https://developer.mixpanel.com/reference/query-event-properties)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.event(String)(required)
^The event that you wish to get data for. Note: this is a single event name, not an array.

params.name(String)(required)
^The name of the property you would like to get data for.

params.type(String)(required)
^The analysis type you would like to get data for - such as general, unique, or average events. Valid values: "general", "unique", or "average".

params.unit(String)(required)
^This can be "minute", "hour", "day", "week", or "month". It determines the level of granularity of the data you get back. Note that you cannot get hourly uniques.

params.values(Array of Strings)(optional)
^The specific property values that you would like to get data for

params.fromDate(String)(required)
^The date in yyyy-mm-dd format to begin querying from. This date is inclusive.

params.toDate(String)(required)
^The date in yyyy-mm-dd format to query to. This date is inclusive.

params.interval(Number)(optional)
^The number of "units" to return data for - minutes, hours, days, weeks, or months. 1 will return data for the current unit (minute, hour, day, week or month). 2 will return the current and previous units, and so on. Specify either interval or from_date and to_date.

params.format(String)(optional)
^The data return format, such as JSON or CSV. Options: "json" (default), "csv".

params.limit(Number)(optional)
^The maximum number of values to return. Defaults to 255.

### .topEventProperties(params)
Get the top property names for an event.
(https://developer.mixpanel.com/reference/query-events-top-properties)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.event(String)(required)
^The event that you wish to get data for. Note: this is a single event name, not an array.

params.limit(Number)(optional)
^The maximum number of properties to return. Defaults to 10.

### .topEventPropertyValues(params)
Get the top values for a property.
(https://developer.mixpanel.com/reference/query-events-top-property-values)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.event(String)(required)
^The event that you wish to get data for. Note: this is a single event name, not an array.

params.name(String)(required)
^The name of the property you would like to get data for.

params.limit(Number)(optional)
^The maximum number of values to return. Defaults to 255.

### .jql(params)
The HTTP API is the lowest-level way to use JQL. At its core, the API is very simple: you write a script, and you post it to an API endpoint with some authentication parameters.
(https://developer.mixpanel.com/reference/query-jql)
params(Table):
params.projectId(number), params.workspaceId(number)(optional), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.script(String)(required)
^The script to run.

params.params(String)(optional)
^A JSON-encoded object that will be made available to the script as the params global variable.


## mixpanelRequest.ingestion.*

### .track(params)
Track events to Mixpanel from client devices.
(https://developer.mixpanel.com/reference/track-event)
params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.event(string)(required)
^The name of the event.

params.properties(Table)(required)
^containing properties of the event. Can contain params.properties.distinctId which the unique identifier of the user who performed the event. Note that  params.properties.time(The time at which the event occurred, in seconds or milliseconds since UTC epoch), params.properties.token(add if skipped .init())


params.ip(Number)(optional)
^If present and equal to 1, Mixpanel will use the ip address of the incoming request and compute a distinct_id using a hash function if no distinct_id is provided. This is different from providing a properties.ip value in the Event Object.

params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

params.redirect(string)(optional)
^If present, Mixpanel will serve a redirect to the given url as a response to the request. This is useful to add link tracking in notifications.

params.img(number)(optional)
^If present and equal to 1, Mixpanel will serve a 1x1 transparent pixel image as a response to the request. This is useful for adding Pixel Tracking in places that javascript is not supported.

params.callback(string)(optional)
^If present, Mixpanel will return a content-type: text/javascript with a body that calls a function by value provided. This is useful for creating local callbacks to a successful track call in JavaScript.


### .setProfile(params)
Takes a table containing names and values of profile properties. If the profile does not exist, it creates it with these properties. If it does exist, it sets the properties to these values, overwriting existing values.
(https://developer.mixpanel.com/reference/profile-set)
params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.distinctId(String)(required)

params.set(Table)(required)
^names and values to set profile properties

params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

params.redirect(string)(optional)
^If present, Mixpanel will serve a redirect to the given url as a response to the request. This is useful to add link tracking in notifications.

params.callback(string)(optional)
^If present, Mixpanel will return a content-type: text/javascript with a body that calls a function by value provided. This is useful for creating local callbacks to a successful track call in JavaScript.

### .setProfileOnce(params)
Like .setProfile except it will not overwrite existing property values. This is useful for properties like "First login date".
(https://developer.mixpanel.com/reference/profile-set-property-once)
params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.distinctId(String)(required)

params.setOnce(Table)(required)
^names and values to set profile properties

params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

params.redirect(string)(optional)
^If present, Mixpanel will serve a redirect to the given url as a response to the request. This is useful to add link tracking in notifications.

params.callback(string)(optional)
^If present, Mixpanel will return a content-type: text/javascript with a body that calls a function by value provided. This is useful for creating local callbacks to a successful track call in JavaScript.

### .profileAddNum(params)
will increment the value of a user profile property. When processed, the property values are added to the existing values of the properties on the profile. If the property is not present on the profile, the value will be added to 0. This is useful for maintaining the values of properties like "Number of Logins" or "Files Uploaded".
(https://developer.mixpanel.com/reference/profile-numerical-add)
(This is useful for maintaining the values of properties like "Number of Logins" or "Files Uploaded".)
params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.distinctId(String)(required)

params.add(Table)(required)

params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

params.redirect(string)(optional)
^If present, Mixpanel will serve a redirect to the given url as a response to the request. This is useful to add link tracking in notifications.

params.callback(string)(optional)
^If present, Mixpanel will return a content-type: text/javascript with a body that calls a function by value provided. This is useful for creating local callbacks to a successful track call in JavaScript.

### .profileListUnion(params)
Adds the specified values to a list property on a user profile and ensures that those values only appear once. The profile is created if it does not exist.
(https://developer.mixpanel.com/reference/user-profile-union)

params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.distinctId(String)(required)

params.union(Table)(required)

params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

params.redirect(string)(optional)
^If present, Mixpanel will serve a redirect to the given url as a response to the request. This is useful to add link tracking in notifications.

params.callback(string)(optional)
^If present, Mixpanel will return a content-type: text/javascript with a body that calls a function by value provided. This is useful for creating local callbacks to a successful track call in JavaScript.

### .profileListAppend(params)
Takes a table containing keys and values, and appends each to a list associated with the corresponding property name. appending to a property that doesn't exist will result in assigning a list with one element to that property.
(https://developer.mixpanel.com/reference/profile-append-to-list-property)

params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.distinctId(String)(required)

params.append(Table)(required)

params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

params.redirect(string)(optional)
^If present, Mixpanel will serve a redirect to the given url as a response to the request. This is useful to add link tracking in notifications.

params.callback(string)(optional)
^If present, Mixpanel will return a content-type: text/javascript with a body that calls a function by value provided. This is useful for creating local callbacks to a successful track call in JavaScript.

### .profileListRemove(params)
Takes a table containing keys and values. The value in the request is removed from the existing list on the user profile. If it does not exist, no updates are made.
(https://developer.mixpanel.com/reference/profile-remove-from-list-property)

params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.distinctId(String)(required)

params.remove(Table)(required)

params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

params.redirect(string)(optional)
^If present, Mixpanel will serve a redirect to the given url as a response to the request. This is useful to add link tracking in notifications.

params.callback(string)(optional)
^If present, Mixpanel will return a content-type: text/javascript with a body that calls a function by value provided. This is useful for creating local callbacks to a successful track call in JavaScript.

### .profileDeleteProperty(params)
Takes a table containing keys and values, permanently removes the properties and their values from a profile.
(https://developer.mixpanel.com/reference/profile-delete-property)

params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.distinctId(String)(required)

params.unset(Table)(required)

params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

params.redirect(string)(optional)
^If present, Mixpanel will serve a redirect to the given url as a response to the request. This is useful to add link tracking in notifications.

params.callback(string)(optional)
^If present, Mixpanel will return a content-type: text/javascript with a body that calls a function by value provided. This is useful for creating local callbacks to a successful track call in JavaScript.

### .updateProfiles(params)
Send a batch of profile updates. Instead of sending a single JSON object as the data query parameter, send a JSON list of object
(https://developer.mixpanel.com/reference/profile-batch-update)

params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.data(Table)(required)
See Mixpanel docs for details
https://developer.mixpanel.com/reference/profile-batch-update

Example you can pass in:
```
{
    {
        ["$token"]= "YOUR_PROJECT_TOKEN",
        ["$distinct_id"]= "13793",
        ["$add"]= { ["Coins Gathered"]= 12 }
    },
    {
      ["$token"]= "YOUR_PROJECT_TOKEN",
      ["$distinct_id"]= "13794",
        ["$add"]= { ["Coins Gathered"]= 13 }
    }
}

```


params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

params.redirect(string)(optional)
^If present, Mixpanel will serve a redirect to the given url as a response to the request. This is useful to add link tracking in notifications.

params.callback(string)(optional)
^If present, Mixpanel will return a content-type: text/javascript with a body that calls a function by value provided. This is useful for creating local callbacks to a successful track call in JavaScript.


### .deleteProfile(params)
Permanently delete the profile from Mixpanel, along with all of its properties. The delete object value is ignored - the profile is determined by the distinctId from the request itself.

If you have duplicate profiles, use property ignoreAlias set to true so that you don't delete the original profile when trying to delete the duplicate (as they pass in the alias as the distinctId).
(https://developer.mixpanel.com/reference/delete-profile)

params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.distinctId(String)(required)

params.delete(string)(required)

params.ignoreAlias(boolean)(optional)


params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

params.redirect(string)(optional)
^If present, Mixpanel will serve a redirect to the given url as a response to the request. This is useful to add link tracking in notifications.

params.callback(string)(optional)
^If present, Mixpanel will return a content-type: text/javascript with a body that calls a function by value provided. This is useful for creating local callbacks to a successful track call in JavaScript.

### .groupUpdate(params)
Updates or adds properties to a group profile. The profile is created if it does not exist.
(https://developer.mixpanel.com/reference/group-set-property)

params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.distinctId(String)(required)

params.set(table)(required)

params.groupKey(string)(required)

params.groupId(string)(required)


params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

### .groupUpdateOnce(params)
Adds properties to a group only if the property is not already set. The profile is created if it does not exist.
(https://developer.mixpanel.com/reference/group-set-property-once)

params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.distinctId(String)(required)

params.setOnce(table)(required)

params.groupKey(string)(required)

params.groupId(string)(required)

params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

### .groupDeleteProperty(params)
Unsets specific properties on the group profile.
(https://developer.mixpanel.com/reference/group-delete-property)

params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.distinctId(String)(required)

params.unset(table)(required)

params.groupKey(string)(required)

params.groupId(string)(required)

params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

### .groupListRemove(params)
Removes a specific value in a list property.
(https://developer.mixpanel.com/reference/group-remove-from-list-property)

params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.distinctId(String)(required)

params.remove(table)(required)

params.groupKey(string)(required)

params.groupId(string)(required)

params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

### .groupBatchUpdate(params)
Send a batch of group profile updates. Instead of sending a single JSON object as the data query parameter
(https://developer.mixpanel.com/reference/group-batch-update)

params(Table):
params.listener(function (See #Events)) (add if skipped .init())

params.data(Table)(required)
See mixpanel docs for details
https://developer.mixpanel.com/reference/group-batch-update

Here is example of what you can pass in:
```
{
    {
        ["$token"]= "YOUR_PROJECT_TOKEN",
        []"$group_key"]= "Company",
        ["$group_id"]= "Mixpanel",
        ["$set"]= {
            Address= "1313 Mockingbird Lane"
        }
    },
    {
        ["$token"]= "YOUR_PROJECT_TOKEN",
        ["$group_key"]= "Company",
        ["$group_id"]= "Wayne Enterprises",
        ["$set_once"]= {
            Address= "Wayne Tower, Gotham City"
        }
    }
}

```

params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

### .groupListUnion(params)
Adds the specified values to a list property on a group profile and ensures that those values only appear once. The profile is created if it does not exist.
(https://developer.mixpanel.com/reference/group-union)

params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.distinctId(String)(required)

params.union(table)(required)

params.groupKey(string)(required)

params.groupId(string)(required)

params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.

### .deleteGroup(params)
Deletes a group profile from Mixpanel.
(https://developer.mixpanel.com/reference/delete-group)

params(Table):
params.token(string), params.listener(function (See #Events)) (add if skipped .init())

params.distinctId(String)(required)

params.groupKey(string)(required)

params.groupId(string)(required)

params.delete(string)(optional)

params.verbose(number)(optional)
^If present and equal to 1, Mixpanel will respond with a JSON Object describing the success or failure of the tracking call. The returned object will have two keys: status, with the value 1 on success and 0 on failure, and error, with a string-valued error message if the request wasn't successful. This is useful for debugging during implementation.


### .import(params)
Send batches of events from your servers to Mixpanel.
Note you need Service Account for this Api
(https://developer.mixpanel.com/reference/import-events)
params(Table):
params.token(string), params.auth.username(string), params.auth.password(string), params.listener(function (See #Events)) (add if skipped .init())

params.data(Array)(required)
There is a lot details, see Mixpanel docs for more info on batch imports
https://developer.mixpanel.com/reference/import-events
Here an example of what to pass in params.data
```
{
  {event= "Signup", properties={time= 1618716477000,distinct_id= "91304156-cafc-4673-a237-623d1129c801",["$insert_id"]= "29fc2962-6d9c-455d-95ad-95b84f09b9e4",["Referred by"]="Friend",URL= "mixpanel.com/signup"}},
  {event= "Purchase", properties= {time= 1618716477000,distinct_id= "91304156-cafc-4673-a237-623d1129c801",["$insert_id"]= "935d87b1-00cd-41b7-be34-b9d98dd08b42",Item= "Coffee", Amount=5.0}}
}
```



#Events
Events be passed into init listener if not set in params.listener

event.data (table or string) -- data from request

event.isError (boolean) -- returns true if error

event.error (strign) -- error message (if event.isError == true)

event.statusCode (number) -- status code of request

event.type (string) -- either "ingestion" or "query"

event.request (table) -- raw event request (see https://docs.coronalabs.com/api/library/network/request.html)
