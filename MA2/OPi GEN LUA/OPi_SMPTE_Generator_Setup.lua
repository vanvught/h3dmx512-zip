--[[
Tested on 3.3.4.3 thru 3.7.0.5
Created By Jason Buckley "Bucky" jasonbuckley@sexylites.com for use with  
Orange Pi SMPTE Timecode LTC Reader / Converter / Generator -- from Arjan van Vught
http://orangepi-dmx.org/
https://sites.google.com/site/rpidmx512/orange-pi-smpte-timecode-ltc-reader-converter 
]]-- 


local opiIPAdd
local opiPort
local setup = true

 
function OPIstart()
  local startMsg = "ltc!start"
  local udp = udpsockOPi.udp()
  udp:settimeout(0)
  udp:setsockname("*", opiPort)
  udp:sendto(startMsg, opiIPAdd, opiPort)
  gma.echo("OPi Start Mesage Sent to: " .. opiIPAdd)
end


function OPIstop()
  local stopMsg = "ltc!stop"
  local udp = udpsockOPi.udp()
  udp:settimeout(0)
  udp:setsockname("*", opiPort)
  udp:sendto(stopMsg, opiIPAdd, opiPort)
  gma.echo("OPi Stop Mesage Sent to: " .. opiIPAdd)
end


function OPIresume()
  local resumeMsg = "ltc!resume"
  local udp = udpsockOPi.udp()
  udp:settimeout(0)
  udp:setsockname("*", opiPort)
  udp:sendto(resumeMsg, opiIPAdd, opiPort)
  gma.echo("OPi Resume Mesage Sent to: " .. opiIPAdd)
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
  local finish = macrOPi + 2 
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
  macrOPi = math.floor(macrOPi - 3)
  gma.cmd("Store Macro 1." .. macrOPi .. " /nc")
  gma.cmd("Store Macro 1." .. math.floor(macrOPi + 1) .. " /nc")
  gma.cmd("Store Macro 1." .. math.floor(macrOPi + 2) .. " /nc")
  gma.cmd("Store Macro 1." .. macrOPi .. ".1 /nc")
  gma.cmd("Store Macro 1." .. math.floor(macrOPi + 1) .. ".1 /nc")
  gma.cmd("Store Macro 1." .. math.floor(macrOPi + 2) .. ".1 /nc") 
  gma.cmd("Label Macro 1." .. macrOPi .. " 'Start OPi Gen'")
  gma.cmd("Label Macro 1." .. math.floor(macrOPi + 1) .. " 'Stop OPi Gen'")
  gma.cmd("Label Macro 1." .. math.floor(macrOPi + 2) .. " 'Resume OPi Gen'")
  gma.cmd("Assign Macro 1." .. macrOPi .. ".1 /cmd=\"LUA 'OPIstart()'\"")
  gma.cmd("Assign Macro 1." .. math.floor(macrOPi + 1) .. ".1 /cmd=\"LUA 'OPIstop()'\"")
  gma.cmd("Assign Macro 1." .. math.floor(macrOPi + 2) .. ".1 /cmd=\"LUA 'OPIresume()'\"")
end


function setupOPIsmpte()
  local startMsg = "ltc!start"
  local stopMsg = "ltc!stop"
  local resumeMsg = "ltc!resume"
  local macrOPi
  if setup == false then
    setup = gma.gui.confirm("Initialize OPi SMPTE?", "'OK' for yes, 'Cancel' for no" )
  end
  if setup == true then
    gma.cmd("Delete Macro \"Start OPi Gen\" /nc") 
    gma.cmd("Delete Macro \"Stop OPi Gen\" /nc")
    gma.cmd("Delete Macro \"Resume OPi Gen\" /nc")
    udpsockOPi = require("socket/socket")
    opiIPAdd = setOPIp() 
    gma.echo('OPi IP Address:' .. opiIPAdd)
    opiPort = 21571
    macroSetup()
    setup = false
  end
end


return setupOPIsmpte
