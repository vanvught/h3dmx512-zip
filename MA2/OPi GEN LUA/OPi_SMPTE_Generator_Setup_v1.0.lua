
--[[
v1.0 -- added set start and stop time macros
Tested on 3.3.4.3 thru 3.7.0.5
Created By Jason Buckley "Bucky" jasonbuckley@sexylites.com for use with  
Orange Pi SMPTE Timecode LTC Reader / Converter / Generator -- from Arjan van Vught
http://orangepi-dmx.org/
https://sites.google.com/site/rpidmx512/orange-pi-smpte-timecode-ltc-reader-converter 
]]-- 

local opiIPAdd = gma.show.getvar("OPISMPTEIPADDRESS")
local opiPort = 21571
local udpsockOPi = require("socket/socket") 
local udp = udpsockOPi.udp()
local startCode
local staopCode
local startHour = "00"
local startMin = "00"
local startSec = "00"
local startFrame = "00"
local stopHour = "00"
local stopMin = "00"
local stopSec = "00"
local stopFrame = "00"
 
function OPIstart()
  local startMsg = "ltc!start"
  udp:settimeout(0)
  udp:setsockname("*", opiPort)
  udp:sendto(startMsg, opiIPAdd, opiPort)
  gma.echo("OPi Start Mesage Sent to: " .. opiIPAdd)
  udp:close()
end


function OPIstop()
  local stopMsg = "ltc!stop"
  udp:settimeout(0)
  udp:setsockname("*", opiPort)
  udp:sendto(stopMsg, opiIPAdd, opiPort)
  gma.echo("OPi Stop Mesage Sent to: " .. opiIPAdd)
  udp:close()
end

function OPIstartCode()
  local conStart = gma.gui.confirm("Are you sure?", "Do you want to set a new start time for the OPi?")
  if conStart then 
    startHour = gma.textinput("OPi Start Hour", startHour)
    startHour = tonumber(startHour)
    while startHour > 23 do 
      startHour = gma.textinput("Invalid OPi Start Hour", "Must be a number from 0 to 23")
      startHour = tonumber(startHour) 
    end
    startHour = string.format("%02d", startHour)
    startMin = gma.textinput("OPi Start Minute", startMin)
    startMin = tonumber(startMin)
    while startMin > 59 do 
      startMin = gma.textinput("Invalid OPi Start Minute", "Must be a number from 0 to 59")
      startMin = tonumber(startMin) 
    end
    startMin = string.format("%02d", startMin)
    startSec = gma.textinput("OPi Start Second", startSec)
    startSec = tonumber(startSec)
    while startSec > 59 do 
      startSec = gma.textinput("Invalid OPi Start Second", "Must be a number from 0 to 59")
      startSec = tonumber(startSec) 
    end
    startSec = string.format("%02d", startSec)
    startFrame = gma.textinput("OPi Start Frame", startFrame)
    startFrame = tonumber(startFrame)
    while startFrame > 29 do 
      startFrame = gma.textinput("Invalid OPi Start Frame", "Must be a number from 0 to 29")
      startFrame = tonumber(startFrame) 
    end
    startFrame = string.format("%02d", startFrame)
    local conCode = gma.gui.confirm("Is the TimeCode Correct?", "H" .. startHour .. ":M" .. startMin .. ":S" .. startSec .. ".F" .. startFrame)
    if conCode then
      gma.cmd('Label Macro \"OPi Start Code*\" \"OPi Start Code ' .. startHour .. ':' .. startMin .. ':' .. startSec .. '.' .. startFrame)
      local startCodeMsg = "ltc!start#" .. startHour .. ':' .. startMin .. ':' .. startSec .. '.' .. startFrame 
      udp:settimeout(0)
      udp:setsockname("*", opiPort)
      udp:sendto(startCodeMsg, opiIPAdd, opiPort)
      gma.echo(startCodeMsg)
      gma.echo("OPi Set Start Time Mesage Sent to: " .. opiIPAdd) 
    end  
  end
end

function OPIstopCode()
  local conStop = gma.gui.confirm("Are you sure?", "Do you want to set a new stop time for the OPi?")
  if conStop then 
    stopHour = gma.textinput("OPi Stop Hour", stopHour)
    stopHour = tonumber(stopHour)
    while stopHour > 23 do 
      stopHour = gma.textinput("Invalid OPi Stop Hour", "Must be a number from 0 to 23")
      stopHour = tonumber(stopHour) 
    end
    stopHour = string.format("%02d", stopHour)
    stopMin = gma.textinput("OPi Stop Minute", stopMin)
    stopMin = tonumber(stopMin)
    while stopMin > 59 do 
      stopMin = gma.textinput("Invalid OPi Stop Minute", "Must be a number from 0 to 59")
      stopMin = tonumber(stopMin) 
    end
    stopMin = string.format("%02d", stopMin)
    stopSec = gma.textinput("OPi Stop Second", stopSec)
    stopSec = tonumber(stopSec)
    while stopSec > 59 do 
      stopSec = gma.textinput("Invalid OPi Stop Second", "Must be a number from 0 to 59")
      stopSec = tonumber(stopSec) 
    end
    stopSec = string.format("%02d", stopSec)
    stopFrame = gma.textinput("OPi Stop Frame", stopFrame)
    stopFrame = tonumber(stopFrame)
    while stopFrame > 29 do 
      stopFrame = gma.textinput("Invalid OPi Stop Frame", "Must be a number from 0 to 29")
      stopFrame = tonumber(stopFrame) 
    end
    stopFrame = string.format("%02d", stopFrame)
    local conCode = gma.gui.confirm("Is the TimeCode Correct?", "H" .. stopHour .. ":M" .. stopMin .. ":S" .. stopSec .. ".F" .. stopFrame)
    if conCode then
      gma.cmd('Label Macro \"OPi Stop Code*\" \"OPi Stop Code ' .. stopHour .. ':' .. stopMin .. ':' .. stopSec .. '.' .. stopFrame)
      local stopCodeMsg = "ltc!stop#" .. stopHour .. ':' .. stopMin .. ':' .. stopSec .. '.' .. stopFrame 
      udp:settimeout(0)
      udp:setsockname("*", opiPort)
      udp:sendto(stopCodeMsg, opiIPAdd, opiPort)
      gma.echo(stopCodeMsg)
      gma.echo("OPi Set Stop Time Mesage Sent to: " .. opiIPAdd) 
    end  
  end
end

function OPIresume()
  local resumeMsg = "ltc!resume"
  udp:settimeout(0)
  udp:setsockname("*", opiPort)
  udp:sendto(resumeMsg, opiIPAdd, opiPort)
  gma.echo("OPi Resume Mesage Sent to: " .. opiIPAdd)
  udp:close()
end
  

function setOPIp()
  local opiIPAdd = gma.textinput("Set IP address of OPi", "[Press 'Please' to send to all/auto eth0 ONLY]")
  if opiIPAdd == "[Press 'Please' to send to all/auto eth0 ONLY]" then
    local network = gma.network.getprimaryip()   
    local num = {}
    local dot = 0
    while true do
      dot = string.find(network, '%.', dot+1)
      if dot == nil then 
        break
      end
    table.insert(num,dot)
    network = string.sub(network, 1, num[3])
    opiIPAdd = (network .. '255')
    end
  end
  return opiIPAdd
end


function checkSpace() 
  local finish = macrOPi + 4 
  local errorMessage = "Insufficient space at macro " .. macrOPi .. ". Please run plugin with a new Macro start #"
  local emptyStatus = true
  for i = macrOPi, finish do
    local handle = gma.show.getobj.handle("macro " .. macrOPi)
     gma.echo(i)
     gma.echo(tostring(handle))
    handle = gma.show.getobj.class(handle)
     gma.echo(handle)
    macrOPi = math.floor(macrOPi + 1)
    if handle ~= nil then 
      emptyStatus = false
      break
    end
  end
  return emptyStatus
end


function macroSetup(emptyStatus)
  macrOPi = gma.textinput("OPi starting macro #", "1") 
  while checkSpace() == false do
    macrOPi = gma.textinput("Insufficient space at macro " .. math.floor(macrOPi - 1), macrOPi) 
  end
  macrOPi = math.floor(macrOPi - 5)
  gma.cmd("Store Macro 1." .. macrOPi .. " /nc")
  gma.cmd("Store Macro 1." .. math.floor(macrOPi + 1) .. " /nc")
  gma.cmd("Store Macro 1." .. math.floor(macrOPi + 2) .. " /nc")
  gma.cmd("Store Macro 1." .. math.floor(macrOPi + 3) .. " /nc")
  gma.cmd("Store Macro 1." .. math.floor(macrOPi + 4) .. " /nc")
  gma.cmd("Store Macro 1." .. macrOPi .. ".1 /nc")
  gma.cmd("Store Macro 1." .. math.floor(macrOPi + 1) .. ".1 /nc")
  gma.cmd("Store Macro 1." .. math.floor(macrOPi + 2) .. ".1 /nc")
  gma.cmd("Store Macro 1." .. math.floor(macrOPi + 3) .. ".1 /nc")
  gma.cmd("Store Macro 1." .. math.floor(macrOPi + 4) .. ".1 /nc")
  gma.cmd("Label Macro 1." .. macrOPi .. " 'Start OPi Gen'")
  gma.cmd("Label Macro 1." .. math.floor(macrOPi + 1) .. " 'Stop OPi Gen'")
  gma.cmd("Label Macro 1." .. math.floor(macrOPi + 2) .. " 'Resume OPi Gen'")
  gma.cmd("Label Macro 1." .. math.floor(macrOPi + 3) .. " 'OPi Start Code'")
  gma.cmd("Label Macro 1." .. math.floor(macrOPi + 4) .. " 'OPi Stop Code'")
  gma.cmd("Assign Macro 1." .. macrOPi .. ".1 /cmd=\"LUA 'OPIstart()'\"")
  gma.cmd("Assign Macro 1." .. math.floor(macrOPi + 1) .. ".1 /cmd=\"LUA 'OPIstop()'\"")
  gma.cmd("Assign Macro 1." .. math.floor(macrOPi + 2) .. ".1 /cmd=\"LUA 'OPIresume()'\"")
  gma.cmd("Assign Macro 1." .. math.floor(macrOPi + 3) .. ".1 /cmd=\"LUA 'OPIstartCode()'\"")
  gma.cmd("Assign Macro 1." .. math.floor(macrOPi + 4) .. ".1 /cmd=\"LUA 'OPIstopCode()'\"")
end


function setupOPIsmpte()
  local macrOPi
  local setup = gma.show.getvar("OPISMPTESETUP")
  gma.echo(setup)
  if setup == "false" then
    confirm = gma.gui.confirm("Initialize OPi SMPTE?", "'OK' for yes, 'Cancel' for no" )
    if confirm == true then
      setup = nil
    end
  end
  if setup == nil then
    gma.cmd("Delete Macro \"Start OPi Gen\" /nc") 
    gma.cmd("Delete Macro \"Stop OPi Gen\" /nc")
    gma.cmd("Delete Macro \"Resume OPi Gen\" /nc")
    gma.cmd("Delete Macro \"OPi Start Code*\" /nc")
    gma.cmd("Delete Macro \"OPi Stop Code*\" /nc")
    opiIPAdd = setOPIp() 
    gma.show.setvar("OPISMPTEIPADDRESS", opiIPAdd)
    gma.echo('OPi IP Address:' .. opiIPAdd)
    macroSetup()
    gma.show.setvar("OPISMPTESETUP", "false")
  end
end


return setupOPIsmpte