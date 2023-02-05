local bg = display.newRect( display.contentCenterX, display.contentCenterY, display.actualContentWidth, display.actualContentHeight )
bg:setFillColor(0,.1,.6)

local title = display.newText("Mixpanel Plugin", display.contentCenterX, 30, native.systemFontBold, 30)

local json = require "json"
local widget = require "widget"
local function mixpanelCallback (event)
	if(event.isError)then
		print("Error:")
		print("------------")
		print(event.error)
	else
		print("Data:")
		print("------------")
		if(type(event.data) == "table" )then
			print(json.prettify(event.data))
		else

			print(event.data)
		end

	end
	print(json.prettify( event ))
end
local mixpanelR = require "mixpanelRequest"
mixpanelR.init({projectId=00000000, listener=mixpanelCallback,
	username="replace",
	password="replace",
	token="replace",
--location="eu",--remove if want data stored in US instead EU
}) -- optional, you can include these params on each request
--^You can add workspaceId to init




local queryTitle = display.newText("Query Apis Ex:", display.contentCenterX, display.contentCenterY-150, native.systemFontBold, 20)
local querySpacer = display.newText("--------------", display.contentCenterX, display.contentCenterY-130, native.systemFontBold, 20)

local bookmarkId = "insert bookmarkId here"
local insightR=widget.newButton{
    x = display.contentCenterX,
		y = display.contentCenterY-100,
    id = "button1",
    label = "Insights reports",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
    onRelease = function ()
    	mixpanelR.query.insight({bookmarkId=bookmarkId})
    end
}
local funnelsList =  widget.newButton{
    x = display.contentCenterX,
		y = display.contentCenterY-60,
    id = "button2",
    label = "Get Funnels",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
    onRelease = function ()
    	mixpanelR.query.funnelList()
    end
}
local segmentationList =  widget.newButton{
    x = display.contentCenterX,
		y = display.contentCenterY-20,
    id = "button3",
    label = "Query Segmentation Report",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
    onRelease = function ()
    	mixpanelR.query.segmentation({event="testEvent", fromDate="2022-06-01", toDate="2022-06-13"})
    end
}
local userActivity =  widget.newButton{
    x = display.contentCenterX,
		y = display.contentCenterY+20,
    id = "button4",
    label = "User Activity",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
    onRelease = function ()
    	mixpanelR.query.userActivity({distinctIds={"12345"}, fromDate="2022-06-01", toDate="2022-06-13"})
    end
}

local ingestionTitle = display.newText("Ingestion Apis Ex:", display.contentCenterX, display.contentCenterY+60, native.systemFontBold, 20)
local ingestionSpacer = display.newText("--------------", display.contentCenterX, display.contentCenterY+80, native.systemFontBold, 20)

local track =  widget.newButton{
    x = display.contentCenterX,
		y = display.contentCenterY+110,
    id = "button5",
    label = "Track Event",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
    onRelease = function ()
    	mixpanelR.ingestion.track({event="testEvent",properties={hello="world"}})
    end
}

local setUserProp =  widget.newButton{
    x = display.contentCenterX,
		y = display.contentCenterY+150,
    id = "button6",
    label = "Set User Prop",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
    onRelease = function ()
    	mixpanelR.ingestion.setProfile({ distinctId="12345", set={age=23, gender="male", name="scott"}})
    end
}

local updateProfiles =  widget.newButton{
    x = display.contentCenterX,
		y = display.contentCenterY+190,
    id = "button7",
    label = "Update Profile",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
    onRelease = function ()
    	mixpanelR.ingestion.groupUpdate({groupKey="company", groupId="Solar2D", set={value="1 million dollars", bestEmployee="Scott"}})
    end
}
