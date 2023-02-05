--[[
By: Scott Harrison
-v1 6/13/2022 first verison



]]--
local m = {}
local mime = require("mime")
local json = require "json"
m.query = {}
m.ingestion = {}

local urlEndQuery = "https://mixpanel.com/api/2.0/" -- US Default
local urlEndIngestion = "https://api.mixpanel.com/" -- US Default

--Hidden vars
m.projectId = nil
m.workspaceId = nil
m.gCallback = nil
m.username = nil
m.password = nil
m.apiLocation = "us"
m.token = nil
m.debug = false
--Random ID maker https://gist.github.com/jrus/3197011
math.randomseed( os.time() )
local random = math.random
local function randomId()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end
--

--
m.init = function (params)
	if(params.projectId)then
		m.projectId = params.projectId
	end
	if(params.workspaceId)then
		m.workspaceId = params.workspaceId
	end
	if(params.username)then
		m.username = params.username
	end
	if(params.password)then
		m.password = params.password
	end
	if(params.listener)then
		m.gCallback = params.listener
	end
	if(params.token)then
		m.token = params.token
	end

	if(params.location and params.location == "eu")then
		urlEndQuery = string.gsub(urlEndQuery, "mixpanel.com", "eu.mixpanel.com")
		urlEndIngestion = string.gsub(urlEndIngestion, "api.mixpanel.com", "api-eu.mixpanel.com")
	end

  if(params.debug)then
		m.debug = params.debug
	end
end

local function encodeUrlParam(str)
		if(type(str)=="table") then
			str = json.encode( str )
		end
		if (str) then
			str = string.gsub (str, "\n", "\r\n")
			str = string.gsub (str, "([^%w %-%_%.%~])",
					function (c) return string.format ("%%%02X", string.byte(c)) end)
			str = string.gsub (str, " ", "+")
		end
		return str
end

local function tableToUrlEncoder(data)
	local params = {}

	if data then
      for k,v in next,data do
          if v then
              table.insert(params, k .. "=" .. encodeUrlParam(v))
          end
      end
  end
	return table.concat(params, '&')

end

------Query
local queryParamMaker = function (data, requestType)
	local body = {}
	local headers = {}
	headers["Accept"] = "application/json"
	headers["Content-Type"]  = "application/x-www-form-urlencoded"

	if(m.projectId) then
		body.project_id = m.projectId
	end
	if(m.workspaceId) then
		body.project_id = m.workspaceId
	end
	if(m.username and m.password) then
		headers["Authorization"] = "Basic " .. (mime.b64(m.username ..":" .. m.password))
	end

	if not data then -- if data is nil return what we have
		local params = {}
		params.headers = headers
		return params, tableToUrlEncoder(body)
	end


	if(data.auth) then
		headers["Authorization"] = "Basic " .. (mime.b64(data.auth.username ..":" .. data.auth.password))
	end

	local body2 = {} -- passed into url if not "GET"

	if(requestType == "GET") then
		if(data.projectId) then
			body.project_id= data.projectId
		elseif(m.projectId) then
			body.project_id = m.projectId
		end
		if(data.workspaceId) then
			body.workspace_id= data.workspaceId
		elseif(m.workspaceId) then
			body.project_id = m.workspaceId
		end
	else
		if(data.projectId) then
			body2.project_id= data.projectId
		elseif(m.projectId) then
			body2.project_id = m.projectId
		end
		if(data.workspaceId) then
			body2.workspace_id= data.workspaceId
		elseif(m.workspaceId) then
			body2.project_id = m.workspaceId
		end
	end


	if(data.bookmarkId) then
		body.bookmark_id= data.bookmarkId
	end


	if(data.funnelId) then
		body.funnel_id= data.funnelId
	end
	if(data.fromDate) then
		body.from_date= data.fromDate
	end
	if(data.toDate) then
		body.to_date= data.toDate
	end
	if(data.length) then
		body.length= data.length
	end

	if(data.lengthUnit) then
		body.length_unit= data.lengthUnit
	end
	if(data.interval) then
		body.interval= data.interval
	end

	if(data.unit) then
		body.unit= data.unit
	end
	if(data.on) then
		body.on= data.on
	end
	if(data.where) then
		body.where= data.where
	end
	if(data.limit) then
		body.limit= data.limit
	end

	if(data.retentionType) then
		body.retention_type= data.retentionType
	end
	if(data.bornEvent) then
		body.born_event= data.bornEvent
	end
	if(data.event) then
		body.event= data.event
	end
	if(data.bornWhere) then
		body.born_where= data.bornWhere
	end
	if(data.intervalCount) then
		body.interval_count= data.intervalCount
	end
	if(data.unboundedRetention) then
		body.unbounded_retention= data.unboundedRetention
	end

	if(data.addictionUnit) then
		body.addiction_unit= data.addictionUnit
	end

	if(data.type) then
		body.type= data.type
	end

	if(data.format) then
		body.format= data.format
	end

	if(data.distinctIds) then
		body.distinct_ids= data.distinctIds
	end
	if(data.sessionId) then
		body.session_id= data.sessionId
	end
	if(data.page) then
		body.page= data.page
	end
	if(data.behaviors) then
		body.behaviors= data.behaviors
	end
	if(data.asOfTimestamp) then
		body.as_of_timestamp= data.asOfTimestamp
	end
	if(data.includeAllUsers) then
		body.include_all_users= data.includeAllUsers
	end

	if(data.values) then
		body.values= data.values
	end
	if(data.name) then
		body.name= data.name
	end
	if(data.script) then
		body.script= data.script
	end
	if(data.params) then
		body.params= data.params
	end

	local params = {}
	params.headers = headers
  if(m.debug) then
    print("")
  end
	if(requestType == "GET") then
		return params, tableToUrlEncoder(body)
	end
	params.body = tableToUrlEncoder(body)
	return params, tableToUrlEncoder(body2)
end

local queryCallback = function (event,params)
	local callback
	if(params and params.listener) then
		callback = params.listener
	elseif(m.gCallback)then
		callback = m.gCallback
	end
	if(callback) then
		print(event.response)
    local data
    if(string.find(event.response, "{"))then
			data = json.decode(event.response)
		else
			data = event.response
		end
		local isError = false
		local error = nil
		if(event.status ~= 200) then
			isError = true
			error = data.error
			data = nil
		end
		callback({data=data, statusCode=event.status, isError=isError, error=error, request=event, type="query"})
	else
		print("Error: No callback set for mixpanel")
	end
end

m.query.insight = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."insights?"..body, "GET", networkListener, header )
end

m.query.funnel = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."funnels?"..body, "GET", networkListener, header )
end
m.query.funnelList = function (params)
	local function networkListener( event )
			queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."funnels/list?"..body, "GET", networkListener, header )
end

m.query.retention = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."retention?"..body, "GET", networkListener, header )
end
m.query.retentionAddiction = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."retention/addiction?"..body, "GET", networkListener, header )
end

m.query.segmentation = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."segmentation?"..body, "GET", networkListener, header )
end
m.query.segmentationNumeric = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."segmentation/numeric?"..body, "GET", networkListener, header )
end
m.query.segmentationSum = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."segmentation/sum?"..body, "GET", networkListener, header )
end
m.query.segmentationAverage = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."segmentation/average?"..body, "GET", networkListener, header )
end

m.query.userActivity = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."stream/query?"..body, "GET", networkListener, header )
end

m.query.listCohorts = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "POST")
	network.request( urlEndQuery.."cohorts/list?"..body, "POST", networkListener, header )
end

--Engage
m.query.profilesQuery = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local postData, body = queryParamMaker(params, "POST")
	network.request( urlEndQuery.."cohorts/list?"..body, "POST", networkListener, postData )
end

--Event Break Down
m.query.totalEvents = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."events?"..body, "GET", networkListener, header )
end

m.query.topEvents = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."events/top?"..body, "GET", networkListener, header )
end

m.query.topEventNames = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."events/names?"..body, "GET", networkListener, header )
end
m.query.eventProperties = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."events/properties?"..body, "GET", networkListener, header )
end
m.query.topEventProperties = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."events/properties/top?"..body, "GET", networkListener, header )
end
m.query.topEventPropertyValues = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local header, body = queryParamMaker(params, "GET")
	network.request( urlEndQuery.."events/properties/values?"..body, "GET", networkListener, header )
end
--JQL
m.query.jql = function (params)
	local function networkListener( event )
		queryCallback(event,params)
	end
	local postData, body = queryParamMaker(params, "POST")
	network.request( urlEndQuery.."jql?"..body, "POST", networkListener, postData )
end

-----Ingestion
local ingestionParamMaker = function (data, specialApi)
	local body = {}
	local headers = {}
	if(specialApi and (specialApi =="import" or specialApi =="event"))then
		headers["Accept"] = "application/json"
	else
		headers["Accept"] = "text/plain"
	end

	headers["Content-Type"]  = "application/json"

	if( m.token and (not specialApi or (specialApi and specialApi ~="track"))) then
		body["$token"] = m.token
	end
	if(m.username and m.password) then
		headers["Authorization"] = "Basic " .. (mime.b64(m.username ..":" .. m.password))
	end

	if not data then -- if data is nil return what we have
		local params = {}
		params.headers = headers
		if(next(body) == nil) then
			return params, ""
		end
		return params, tableToUrlEncoder(body)
	end


	if(data.auth) then
		headers["Authorization"] = "Basic " .. (mime.b64(data.auth.username ..":" .. data.auth.password))
	end

	local body2 = {} -- passed into url

	if(data.projectId) then
		body2.project_id= data.projectId
	elseif(m.projectId) then
		body2.project_id = m.projectId
	end
	if(data.strict) then
		body2.strict = data.strict
	end
	if(data.ip) then
		body2.ip = data.ip
	end
	if(data.verbose) then
		body2.verbose = data.verbose
	end
	if(data.redirect) then
		body2.redirect = data.redirect
	end
	if(data.img) then
		body2.img = data.img
	end
	if(data.callback) then
		body2.callback = data.callback
	end


	---Special Case Api

	if(specialApi and (specialApi == "import" or specialApi == "updateProfiles" or specialApi == "groupBatchUpdate"))then
		body = data.data
	else
		if(data.event) then
			body.event= data.event
		end
		if(data.name) then
			body.name= data.name
		end
		if(data.properties) then
			body.properties= data.properties
			if(specialApi and specialApi =="track" )then
				if(not body.properties.token and m.token)then
					body.properties.token = m.token
				end
				if(not body.properties.time)then
					body.properties.time = os.time(os.date("!*t"))
				end
				if(body.properties.distinctId)then
					body.properties.distinct_id = body.properties.distinctId
          body.properties.distinctId = nil
				end


        if(not body.properties.insertId)then
          body.properties["$insert_id"] = randomId()
        end

			end
		end
		if(data.params) then
			body.params= data.params
		end
		if(data.token) then
			body["$token"]= data.token
		end
		if(data.distinctId) then
			body["$distinct_id"]= data.distinctId
		end
		if(data.set) then
			body["$set"]= data.set
		end
		if(data.setOnce) then
			body["$set_once"]= data.setOnce
		end
		if(data.add) then
			body["$add"]= data.add
		end
		if(data.union) then
			body["$union"]= data.union
		end
		if(data.append) then
			body["$append"]= data.append
		end
		if(data.remove) then
			body["$remove"]= data.remove
		end
		if(data.unset) then
			body["$unset"]= data.unset
		end
		if(data.delete) then
			body["$delete"]= data.delete
		end
		if(data.groupKey) then
			body["$group_key"]= data.groupKey
		end
		if(data.groupId) then
			body["$group_id"]= data.groupId
		end
    if(data.ignoreAlias) then
			body["$ignore_alias"]= data.ignoreAlias
		end

	end



	local params = {}
	params.headers = headers
	if(specialApi and specialApi == "import")then
		params.body = json.encode(body)
	else
		params.body = json.encode({body})
	end

	if(next(body2) == nil) then
		return params, ""
	end
	return params, tableToUrlEncoder(body2)
end

local ingestionCallback = function (event,params)
	local callback
	if(params and params.listener) then
		callback = params.listener
	elseif(m.gCallback)then
		callback = m.gCallback
	end
	if(callback) then
		local data
		if(string.find(event.response, "{"))then
			data = json.decode(event.response)
		else
			data = event.response
		end
		local isError = false
		local error = nil
		if(event.status ~= 200) then
			isError = true
			error = data.error
			data = nil
		end
		callback({data=data, statusCode=event.status, isError=isError, error=error, request=event, type="ingestion"})
	else
		print("Error: No callback set for mixpanel")
	end
end

--Events
m.ingestion.import = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params, "import")
	network.request( urlEndIngestion.."import?"..body, "POST", networkListener, postData )
end
m.ingestion.track = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params, "track")
	print(json.prettify( postData ))
	network.request( urlEndIngestion.."track", "POST", networkListener, postData )
end
--User profiles
m.ingestion.setProfile = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params)
    print(json.prettify( postData )) 
	network.request( urlEndIngestion.."engage#profile-set?"..body, "POST", networkListener, postData )
end
m.ingestion.setProfileOnce = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params)
	network.request( urlEndIngestion.."engage#profile-set-once?"..body, "POST", networkListener, postData )
end
m.ingestion.profileAddNum = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params)
	network.request( urlEndIngestion.."engage#profile-numerical-add?"..body, "POST", networkListener, postData )
end
m.ingestion.profileListUnion = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params)
	network.request( urlEndIngestion.."engage#profile-union?"..body, "POST", networkListener, postData )
end
m.ingestion.profileListAppend = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params)
	network.request( urlEndIngestion.."engage#profile-list-append?"..body, "POST", networkListener, postData )
end
m.ingestion.profileListRemove = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params)
	network.request( urlEndIngestion.."engage#profile-list-remove?"..body, "POST", networkListener, postData )
end
m.ingestion.profileDeleteProperty = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params)
	network.request( urlEndIngestion.."engage#profile-unset?"..body, "POST", networkListener, postData )
end
m.ingestion.updateProfiles = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params, "updateProfiles")
	network.request( urlEndIngestion.."engage#profile-unset?"..body, "POST", networkListener, postData )
end

m.ingestion.deleteProfile = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params)
	network.request( urlEndIngestion.."engage#profile-delete?"..body, "POST", networkListener, postData )
end
--Group profiles
m.ingestion.groupUpdate = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params)
	network.request( urlEndIngestion.."groups#group-set?"..body, "POST", networkListener, postData )
end
m.ingestion.groupUpdateOnce = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params)
	network.request( urlEndIngestion.."groups#group-set-once?"..body, "POST", networkListener, postData )
end
m.ingestion.groupDeleteProperty = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params)
	network.request( urlEndIngestion.."groups#group-unset?"..body, "POST", networkListener, postData )
end
m.ingestion.groupListRemove = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params)
	network.request( urlEndIngestion.."groups#group-remove-from-list?"..body, "POST", networkListener, postData )
end
m.ingestion.groupListUnion = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params)
	network.request( urlEndIngestion.."groups#group-union?"..body, "POST", networkListener, postData )
end
m.ingestion.groupBatchUpdate = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params, "groupBatchUpdate")
	network.request( urlEndIngestion.."groups#group-batch-update"..body, "POST", networkListener, postData )
end
m.ingestion.deleteGroup = function (params)
	local function networkListener( event )
		ingestionCallback(event,params)
	end
	local postData, body = ingestionParamMaker(params)
	network.request( urlEndIngestion.."groups#group-delete"..body, "POST", networkListener, postData )
end

return m
