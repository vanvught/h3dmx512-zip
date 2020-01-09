----------------------------------------
-- script-name: tcnet.lua
--
-- Author: Arjan van Vught <arjan.van.vught@gmail.com>
-- GitHub: https://github.com/vanvught/h3dmx512-zip
-- Website: http://www.orangepi-dmx.org/orange-pi-smpte-timecode-ltc-reader-converter/tcnet
--
-- Done : OptIn, OptOut, Status, Time, Application, Time Sync, Error / Notification, Request
-- Todo : Control, TextData, KeyboardData, Data, DataFile
--
-- TCNet specification V3.3.3 11/11/2019 (https://www.tc-supply.com/tcnet)
----------------------------------------

local tcnet_proto = Proto("tcnet","TCNet Protocol")

local message_types = {
	[2] = "OptIn",
	[3] = "OptOut",
	[5] = "Status",
	[10] = "TimeSync" ,
	[13] = "Error Notification",
	[20] = "Request",
	[30] = "Application",
	[101] = "Control",
	[128] = "TextData", 
	[132] = "KeyboardData", 
	[200] = "Data", 
	[204] = "DataFile", 
	[254] = "Time",
}

local node_types = {
	[1] = "Auto",
	[2] = "Master",
	[4] = "Slave",
	[8] = "Repeater"
}

local layer_status = {
	[0] = "IDLE",
	[3] = "PLAYING",
	[4] = "LOOPING",
	[5] = "PAUSED",
	[6] = "STOPPED",
	[7] = "CUE BOTTON DOWN",
	[8] = "PLATTER DOWN",
	[9] = "FFWD",
	[10] = "FFRV",
	[11] = "HOLD",
}

local smpte_mode = {
	[0] = "Global SMPTE Mode",
	[24] = "24FPS",
	[25] = "25FPS",
	[29] = "29.7FPS",
	[30] = "30FPS"
}

auto_master_mode = {
	[0] = "Disabled",
	[1] = "HTP Master",
	[2] = "Link Master"
}

time_code_state = {
	[0] = "Stopped",
	[1] = "Running",
	[2] = "Force Re sync"
}

error_notification_code = {
	[1] = "Request Unknown",
	[13] = "Request Not Possible/Featured",
	[14] = "Request Data = EMPTY",
	[255] = "Request Response: OK"
}

-- Management Header fields
local node_id = ProtoField.uint16("tcnet.management.nodeid", "Node ID", base.DEC)
local header = ProtoField.string("tcnet.management.header", "Header", base.ASCII)
local message_type = ProtoField.uint8("tcnet.management.messagetype", "Message Type", base.DEC, message_types)
local node_name = ProtoField.string("tcnet.management.nodename", "Node Name", base.ASCII)
local seq = ProtoField.uint8("tcnet.management.seq", "SEQ", base.DEC)
local node_type = ProtoField.uint8("tcnet.management.nodetype", "Node Type", base.DEC, node_types)
local node_options = ProtoField.uint16("tcnet.management.nodeoptions", "Node Options", base.DEC)
local time_stamp = ProtoField.uint32("tcnet.management.timestamp", "Time Stamp", base.DEC)

-- TCNet Opt-IN Packet fields
local optin_node_count = ProtoField.uint16("tcnet.optin.nodecount", "Node Count", base.DEC)
local optin_listener_port = ProtoField.uint16("tcnet.optin.listenerport", "Listener Port", base.DEC)
local optin_uptime = ProtoField.uint16("tcnet.optin.uptime", "Uptime", base.DEC)
local optin_vendor_name = ProtoField.string("tcnet.optin.vendorname", "Vendor Name", base.ASCII)
local optin_device_name = ProtoField.string("tcnet.optin.devicename", "Device Name", base.ASCII)

-- TCNet Opt-OUT Packet fields
local optout_node_count = ProtoField.uint16("tcnet.optout.nodecount", "Node Count", base.DEC)
local optout_listener_port = ProtoField.uint16("tcnet.optout.listenerport", "Listener Port", base.DEC)

-- TCNet Status Packet fields
local status_node_count = ProtoField.uint16("tcnet.status.nodecount", "Node Count", base.DEC)
local status_listener_port = ProtoField.uint16("tcnet.status.listenerport", "Listener Port", base.DEC)
--
local status_layer1_source = ProtoField.uint8("tcnet.status.layer1source", "1", base.DEC)
local status_layer2_source = ProtoField.uint8("tcnet.status.layer2source", "2", base.DEC)
local status_layer3_source = ProtoField.uint8("tcnet.status.layer3source", "3", base.DEC)
local status_layer4_source = ProtoField.uint8("tcnet.status.layer4source", "4", base.DEC)
local status_layera_source = ProtoField.uint8("tcnet.status.layerasource", "A", base.DEC)
local status_layerb_source = ProtoField.uint8("tcnet.status.layerbsource", "B", base.DEC)
local status_layerm_source = ProtoField.uint8("tcnet.status.layermsource", "M", base.DEC)
local status_layerc_source = ProtoField.uint8("tcnet.status.layercsource", "C", base.DEC)
--
local status_layer1_status = ProtoField.uint8("tcnet.status.layer1status", "1", base.DEC, layer_status)
local status_layer2_status = ProtoField.uint8("tcnet.status.layer2status", "2", base.DEC, layer_status)
local status_layer3_status = ProtoField.uint8("tcnet.status.layer3status", "3", base.DEC, layer_status)
local status_layer4_status = ProtoField.uint8("tcnet.status.layer4status", "4", base.DEC, layer_status)
local status_layera_status = ProtoField.uint8("tcnet.status.layerastatus", "A", base.DEC, layer_status)
local status_layerb_status = ProtoField.uint8("tcnet.status.layerbstatus", "B", base.DEC, layer_status)
local status_layerm_status = ProtoField.uint8("tcnet.status.layermstatus", "M", base.DEC, layer_status)
local status_layerc_status = ProtoField.uint8("tcnet.status.layercstatus", "C", base.DEC, layer_status)
--
local status_layer1_trackid = ProtoField.uint32("tcnet.status.layer1trackid", "1", base.HEX)
local status_layer2_trackid = ProtoField.uint32("tcnet.status.layer2trackid", "2", base.HEX)
local status_layer3_trackid = ProtoField.uint32("tcnet.status.layer3trackid", "3", base.HEX)
local status_layer4_trackid = ProtoField.uint32("tcnet.status.layer4trackid", "4", base.HEX)
local status_layera_trackid = ProtoField.uint32("tcnet.status.layeratrackid", "A", base.HEX)
local status_layerb_trackid = ProtoField.uint32("tcnet.status.layerbtrackid", "B", base.HEX)
local status_layerm_trackid = ProtoField.uint32("tcnet.status.layermtrackid", "M", base.HEX)
local status_layerc_trackid = ProtoField.uint32("tcnet.status.layerctrackid", "C", base.HEX)
--
local status_smpte_mode = ProtoField.uint8("tcnet.status.smptemode", "SMPTE Mode", base.DEC, smpte_mode)
local status_auto_master_mode = ProtoField.uint8("tcnet.status.automastermode", "Auto Master Mode", base.DEC, auto_master_mode)
--
local status_layer1_name = ProtoField.string("tcnet.status.layer1name", "1", base.ASCII)
local status_layer2_name = ProtoField.string("tcnet.status.layer2name", "2", base.ASCII)
local status_layer3_name = ProtoField.string("tcnet.status.layer3name", "3", base.ASCII)
local status_layer4_name = ProtoField.string("tcnet.status.layer4name", "4", base.ASCII)
local status_layera_name = ProtoField.string("tcnet.status.layeraname", "A", base.ASCII)
local status_layerb_name = ProtoField.string("tcnet.status.layerbname", "B", base.ASCII)
local status_layerm_name = ProtoField.string("tcnet.status.layermname", "M", base.ASCII)
local status_layerc_name = ProtoField.string("tcnet.status.layercname", "C", base.ASCII)

-- TCNet Time Sync Packet
local timesync_step = ProtoField.uint8("tcnet.timesync.step", "STEP", base.DEC)
local timesync_listener_port = ProtoField.uint16("tcnet.timesync.listenerport", "Listener Port", base.DEC)
local timesync_remote_timestamp = ProtoField.uint32("tcnet.timesync.remotetimestamp", "Remote Timestamp", base.DEC)

-- TCNet Error / Notification
local errornotification_datatype = ProtoField.uint8("tcnet.errornotification.datatype", "DataType", base.HEX);
local errornotification_layerid = ProtoField.uint8("tcnet.errornotification.layerid", "Layer ID", base.HEX);
local errornotification_code = ProtoField.uint16("tcnet.errornotification.code", "Code", base.DEC, error_notification_code)
local errornotification_messagetype = ProtoField.uint16("tcnet.errornotification.messagetype", "Message Type", base.DEC)

-- TCNet Request Packet
local request_datatype = ProtoField.uint8("tcnet.request.datatype", "DataType", base.HEX);
local request_layer = ProtoField.uint8("tcnet.request.layer", "Layer", base.DEC);

-- TCNet Application Specific Data Packet fields
local application_dataidentifier1 = ProtoField.uint8("tcnet.application.dataidentifier1", "Data Identifier 1", base.DEC);
local application_dataidentifier2 = ProtoField.uint8("tcnet.application.dataidentifier2", "Data Identifier 2", base.DEC);
local application_datasize = ProtoField.uint32("tcnet.application.datasize", "Data Size", base.DEC)
local application_totalpackets = ProtoField.uint32("tcnet.application.totalpackets", "Total Packets", base.DEC)
local application_packetno = ProtoField.uint32("tcnet.application.packetno", "Packet No", base.DEC)
local application_packetsignature = ProtoField.uint32("tcnet.application.packetsignature", "Packet Signature", base.DEC)

-- TCNet Time Packet fields
local time_l1_time = ProtoField.uint32("tcnet.time.l1time", "1", base.DEC)
local time_l2_time = ProtoField.uint32("tcnet.time.l2time", "2", base.DEC)
local time_l3_time = ProtoField.uint32("tcnet.time.l3time", "3", base.DEC)
local time_l4_time = ProtoField.uint32("tcnet.time.l4time", "4", base.DEC)
local time_la_time = ProtoField.uint32("tcnet.time.l1time", "A", base.DEC)
local time_lb_time = ProtoField.uint32("tcnet.time.l2time", "B", base.DEC)
local time_lm_time = ProtoField.uint32("tcnet.time.l3time", "M", base.DEC)
local time_lc_time = ProtoField.uint32("tcnet.time.l4time", "C", base.DEC)
--
local time_l1_total_time = ProtoField.uint32("tcnet.time.l1totaltime", "1", base.DEC)
local time_l2_total_time = ProtoField.uint32("tcnet.time.l2totaltime", "2", base.DEC)
local time_l3_total_time = ProtoField.uint32("tcnet.time.l3totaltime", "3", base.DEC)
local time_l4_total_time = ProtoField.uint32("tcnet.time.l4totaltime", "4", base.DEC)
local time_la_total_time = ProtoField.uint32("tcnet.time.l1totaltime", "A", base.DEC)
local time_lb_total_time = ProtoField.uint32("tcnet.time.l2totaltime", "B", base.DEC)
local time_lm_total_time = ProtoField.uint32("tcnet.time.l3totaltime", "M", base.DEC)
local time_lc_total_time = ProtoField.uint32("tcnet.time.l4totaltime", "C", base.DEC)
--
local time_l1_beatmarker = ProtoField.uint8("tcnet.time.l1beatmarker", "1", base.DEC)
local time_l2_beatmarker = ProtoField.uint8("tcnet.time.l2beatmarker", "2", base.DEC)
local time_l3_beatmarker = ProtoField.uint8("tcnet.time.l3beatmarker", "3", base.DEC)
local time_l4_beatmarker = ProtoField.uint8("tcnet.time.l4beatmarker", "4", base.DEC)
local time_la_beatmarker = ProtoField.uint8("tcnet.time.labeatmarker", "A", base.DEC)
local time_lb_beatmarker = ProtoField.uint8("tcnet.time.lbbeatmarker", "B", base.DEC)
local time_lm_beatmarker = ProtoField.uint8("tcnet.time.lmbeatmarker", "M", base.DEC)
local time_lc_beatmarker = ProtoField.uint8("tcnet.time.lcbeatmarker", "C", base.DEC) 
--
local time_l1_state = ProtoField.uint8("tcnet.time.l1state", "1", base.DEC, layer_status)
local time_l2_state = ProtoField.uint8("tcnet.time.l2state", "2", base.DEC, layer_status)
local time_l3_state = ProtoField.uint8("tcnet.time.l3state", "3", base.DEC, layer_status)
local time_l4_state = ProtoField.uint8("tcnet.time.l4state", "4", base.DEC, layer_status)
local time_la_state = ProtoField.uint8("tcnet.time.lastate", "A", base.DEC, layer_status)
local time_lb_state = ProtoField.uint8("tcnet.time.lbstate", "B", base.DEC, layer_status)
local time_lm_state = ProtoField.uint8("tcnet.time.lmstate", "M", base.DEC, layer_status)
local time_lc_state = ProtoField.uint8("tcnet.time.lcstate", "C", base.DEC, layer_status) 
--
local time_smpte_mode = ProtoField.uint8("tcnet.time.smptemode", "SMPTE Mode", base.DEC, smpte_mode)
--
local time_l1_smpte_mode = ProtoField.uint8("tcnet.time.l1smptemode", "Mode", base.DEC, smpte_mode)
local time_l2_smpte_mode = ProtoField.uint8("tcnet.time.l2smptemode", "Mode", base.DEC, smpte_mode)
local time_l3_smpte_mode = ProtoField.uint8("tcnet.time.l3smptemode", "Mode", base.DEC, smpte_mode)
local time_l4_smpte_mode = ProtoField.uint8("tcnet.time.l4smptemode", "Mode", base.DEC, smpte_mode)
local time_la_smpte_mode = ProtoField.uint8("tcnet.time.lasmptemode", "Mode", base.DEC, smpte_mode)
local time_lb_smpte_mode = ProtoField.uint8("tcnet.time.lbsmptemode", "Mode", base.DEC, smpte_mode)
local time_lm_smpte_mode = ProtoField.uint8("tcnet.time.lmsmptemode", "Mode", base.DEC, smpte_mode)
local time_lc_smpte_mode = ProtoField.uint8("tcnet.time.lcsmptemode", "Mode", base.DEC, smpte_mode)
--
local time_l1_tc_state = ProtoField.uint8("tcnet.time.l1smptemode", "State", base.DEC, time_code_state)
local time_l2_tc_state = ProtoField.uint8("tcnet.time.l2smptemode", "State", base.DEC, time_code_state)
local time_l3_tc_state = ProtoField.uint8("tcnet.time.l3smptemode", "State", base.DEC, time_code_state)
local time_l4_tc_state = ProtoField.uint8("tcnet.time.l4smptemode", "State", base.DEC, time_code_state)
local time_la_tc_state = ProtoField.uint8("tcnet.time.lasmptemode", "State", base.DEC, time_code_state)
local time_lb_tc_state = ProtoField.uint8("tcnet.time.lbsmptemode", "State", base.DEC, time_code_state)
local time_lm_tc_state = ProtoField.uint8("tcnet.time.lmsmptemode", "State", base.DEC, time_code_state)
local time_lc_tc_state = ProtoField.uint8("tcnet.time.lcsmptemode", "State", base.DEC, time_code_state)
--
local time_l1_onair = ProtoField.uint8("tcnet.time.l1onair", "1", base.DEC)
local time_l2_onair = ProtoField.uint8("tcnet.time.l2onair", "2", base.DEC)
local time_l3_onair = ProtoField.uint8("tcnet.time.l3onair", "3", base.DEC)
local time_l4_onair = ProtoField.uint8("tcnet.time.l4onair", "4", base.DEC)
local time_la_onair = ProtoField.uint8("tcnet.time.laonair", "A", base.DEC)
local time_lb_onair = ProtoField.uint8("tcnet.time.lbonair", "B", base.DEC)
local time_lm_onair = ProtoField.uint8("tcnet.time.lmonair", "M", base.DEC)
local time_lc_onair = ProtoField.uint8("tcnet.time.lconair", "C", base.DEC) 

tcnet_proto.fields = { 
	node_id, header, message_type, node_name, seq, node_type, node_options, time_stamp,  																			-- Management Header
	optin_node_count, optin_listener_port, optin_uptime, optin_vendor_name, optin_device_name,																		-- OptIn Fields
	optout_node_count, optout_listener_port,																														-- OptOut Fields
	status_node_count, status_listener_port, 																														-- Status Fields
	status_layer1_source, status_layer2_source, status_layer3_source, status_layer4_source, status_layera_source, status_layerb_source, status_layerm_source, status_layerc_source,
	status_layer1_status, status_layer2_status, status_layer3_status, status_layer4_status, status_layera_status, status_layerb_status, status_layerm_status, status_layerc_status,
	status_layer1_trackid, status_layer2_trackid, status_layer3_trackid, status_layer4_trackid, status_layera_trackid, status_layerb_trackid, status_layerm_trackid, status_layerc_trackid,
	status_smpte_mode, status_auto_master_mode,
	status_layer1_name, status_layer2_name, status_layer3_name, status_layer4_name, status_layera_name, status_layerb_name, status_layerm_name, status_layerc_name,
	timesync_step, timesync_listener_port, timesync_remote_timestamp,																								-- Time Sync fields
	errornotification_datatype, errornotification_layerid, errornotification_code, errornotification_messagetype,													-- Error / Notification fields
	request_datatype, request_layer,																																-- Request fields
	application_dataidentifier1, application_dataidentifier2, application_datasize, application_totalpackets, application_packetno, application_packetsignature,	-- Applicaton fields
	time_l1_time, time_l2_time, time_l3_time, time_l4_time, time_la_time, time_lb_time, time_lm_time, time_lc_time, 												-- Time fields
	time_l1_total_time, time_l2_total_time, time_l3_total_time, time_l4_total_time, time_la_total_time, time_lb_total_time, time_lm_total_time, time_lc_total_time,
	time_l1_beatmarker, time_l2_beatmarker, time_l3_beatmarker, time_l4_beatmarker, time_la_beatmarker, time_lb_beatmarker, time_lm_beatmarker, time_lc_beatmarker,
	time_l1_state, time_l2_state, time_l3_state, time_l4_state, time_la_state, time_lb_state, time_lm_state, time_lc_state,
	time_smpte_mode,
	time_l1_smpte_mode, time_l1_tc_state, time_l2_smpte_mode, time_l2_tc_state, time_l3_smpte_mode, time_l3_tc_state, time_l4_smpte_mode, time_l4_tc_state,
	time_la_smpte_mode, time_la_tc_state, time_lb_smpte_mode, time_lb_tc_state, time_lm_smpte_mode, time_lm_tc_state, time_lc_smpte_mode, time_lc_tc_state,
	time_l1_onair, time_l2_onair, time_l3_onair, time_l4_onair, time_la_onair, time_lb_onair, time_lm_onair, time_lc_onair
}
					
function tcnet_proto.dissector(buffer, pinfo, tree)
  length = buffer:len()
  if length == 0 then return end
  -- We can do some more validation
  
   pinfo.cols.protocol = "TCNET"
  
  local subtree = tree:add(tcnet_proto,buffer(),"TCNet Protocol Data")
	
	local managementtree = subtree:add(tcnet_proto,buffer(),"Management Header")
	managementtree:add(node_id, buffer(0,2))
	managementtree:add(buffer(2,2),"Protocol Version: " .. buffer(2,1):uint() .. "." .. buffer(3,1):uint())
	managementtree:add(header, buffer(4,3))
	managementtree:add(message_type, buffer(7,1))
	managementtree:add(node_name, buffer(8,8))
	managementtree:add(seq, buffer(16,1))
	managementtree:add(node_type, buffer(17,1))
	managementtree:add_le(node_options, buffer(18,2))
	managementtree:add_le(time_stamp, buffer(20,4))
	
	pinfo.cols.info = "Message Type: " .. message_types[buffer(7,1):uint()]
	
	-- Messsage Types
	local message_type = buffer(7,1):uint()
	
	if message_type == 254 then
		local timetree = subtree:add(tcnet_proto,buffer(),"Time")
		parse_time(timetree, buffer)	
	elseif message_type == 5 then
		local statustree = subtree:add(tcnet_proto,buffer(),"Status")		
		parse_status(statustree, buffer)
	elseif message_type == 10 then
		local timesynctree = subtree:add(tcnet_proto,buffer(),"Time Sync")
		parse_timesync(timesynctree, buffer)	
	elseif message_type == 13 then
		local errornotificationtree = subtree:add(tcnet_proto,buffer(),"Error / Notification")
		parse_errornotification(errornotificationtree, buffer)
	elseif message_type == 20 then
		local requesttree = subtree:add(tcnet_proto,buffer(),"Request")
		parse_request(requesttree, buffer)
	elseif message_type == 30 then
		local applicationtree = subtree:add(tcnet_proto,buffer(),"Application")
		parse_application(applicationtree, buffer)
	elseif message_type == 2 then
		local optintree = subtree:add(tcnet_proto,buffer(),"OptIn")
		parse_optin(optintree, buffer)		
	elseif message_type == 3 then
		local optouttree = subtree:add(tcnet_proto,buffer(),"OptOut")
		parse_optout(optouttree, buffer)
	end
end

-- TCNet Opt-IN Packet
function parse_optin(localtree, buffer)
	localtree:add_le(optin_node_count, buffer(24,2))
	localtree:add_le(optin_listener_port, buffer(26,2))
	localtree:add_le(optin_uptime, buffer(28,2))
	localtree:add(buffer(30,2),"Reserverd: " .. buffer(30,2))
	localtree:add(optin_vendor_name, buffer(32,16))
	localtree:add(optin_device_name, buffer(48,16))
	localtree:add(buffer(64,3),"Device Version: " .. buffer(64,1):uint() .. "." .. buffer(65,1):uint().. "." .. buffer(66,1):uint())
	localtree:add(buffer(67,1),"Reserverd: " .. buffer(67,1))
end

-- TCNet Opt-OUT Packet
function parse_optout(localtree, buffer)
	localtree:add_le(optout_node_count, buffer(24,2))
	localtree:add_le(optout_listener_port, buffer(26,2))
end	

-- TCNet Status Packet
function parse_status(localtree, buffer)
	localtree:add_le(status_node_count, buffer(24,2))
	localtree:add_le(status_listener_port, buffer(26,2))
	localtree:add(buffer(28,6),"Reserverd: " .. buffer(28,6))
	--
	local source = localtree:add(tcnet_proto,buffer(),"Layer Source")	
	source:add(status_layer1_source, buffer(34,1))
	source:add(status_layer2_source, buffer(35,1))
	source:add(status_layer3_source, buffer(36,1))
	source:add(status_layer4_source, buffer(37,1))
	source:add(status_layera_source, buffer(38,1))
	source:add(status_layerb_source, buffer(39,1))
	source:add(status_layerm_source, buffer(40,1))
	source:add(status_layerc_source, buffer(41,1))	
	--
	local status = localtree:add(tcnet_proto,buffer(),"Layer Status")	
	status:add(status_layer1_status, buffer(42,1))
	status:add(status_layer2_status, buffer(43,1))
	status:add(status_layer3_status, buffer(44,1))
	status:add(status_layer4_status, buffer(45,1))
	status:add(status_layera_status, buffer(46,1))
	status:add(status_layerb_status, buffer(47,1))
	status:add(status_layerm_status, buffer(48,1))
	status:add(status_layerc_status, buffer(49,1))
	--
	local trackid = localtree:add(tcnet_proto,buffer(),"Layer Track ID")	
	trackid:add(status_layer1_trackid, buffer(50,4))
	trackid:add(status_layer2_trackid, buffer(54,4))
	trackid:add(status_layer3_trackid, buffer(58,4))
	trackid:add(status_layer4_trackid, buffer(62,4))
	trackid:add(status_layera_trackid, buffer(66,4))
	trackid:add(status_layerb_trackid, buffer(70,4))
	trackid:add(status_layerm_trackid, buffer(74,4))
	trackid:add(status_layerc_trackid, buffer(78,4))
	--
	localtree:add(buffer(85,15),"Reserverd: " .. buffer(85,15))
	--
	localtree:add(status_smpte_mode, buffer(83,1))
	localtree:add(status_auto_master_mode, buffer(84,1))
	--
	localtree:add(buffer(85,15),"Reserverd: " .. buffer(85,15))
	localtree:add(buffer(100,72),"Reserverd (App specific): " .. buffer(100,72))
	--
	local name = localtree:add(tcnet_proto,buffer(),"Layer Name")	
	name:add(status_layer1_name, buffer(172,16))
	name:add(status_layer2_name, buffer(188,16))
	name:add(status_layer3_name, buffer(204,16))
	name:add(status_layer4_name, buffer(220,16))
	name:add(status_layera_name, buffer(236,16))
	name:add(status_layerb_name, buffer(252,16))
	name:add(status_layerm_name, buffer(268,16))
	name:add(status_layerc_name, buffer(284,16))
end

-- TCNet Time Sync Packet
function parse_timesync(localtree, buffer)	
	localtree:add(timesync_step, buffer(24,1))
	localtree:add(buffer(25,1),"Reserverd: " .. buffer(25,1))
	localtree:add_le(timesync_listener_port, buffer(26,2))
	localtree:add_le(timesync_remote_timestamp, buffer(28,4))
end

-- TCNet Error / Notification
function parse_errornotification(localtree, buffer)	
	localtree:add(errornotification_datatype, buffer(24,1))
	localtree:add(errornotification_layerid, buffer(25,1))
	localtree:add_le(errornotification_code, buffer(26,2))
	localtree:add_le(errornotification_messagetype, buffer(28,2))
end

-- TCNet Request Packet
function parse_request(localtree, buffer)
	localtree:add(request_datatype, buffer(24,1))
	localtree:add(request_layer, buffer(25,1))
end

-- TCNet Application Specific Data Packet
function parse_application(localtree, buffer)	
	localtree:add(application_dataidentifier1, buffer(24,1))
	localtree:add(application_dataidentifier2, buffer(25,1))
	localtree:add_le(application_datasize, buffer(26,4))
	localtree:add_le(application_totalpackets, buffer(30,4))
	localtree:add_le(application_packetno, buffer(34,4))
	localtree:add_le(application_packetsignature, buffer(38,4))
	
	local data_size = buffer(26,4):le_uint()
	localtree:add(buffer(42,data_size),"Data: " .. buffer(42,data_size))
end

-- TCNet Time Packet
function parse_time(localtree, buffer)
	local ltime = localtree:add(tcnet_proto,buffer(),"Time (ms)")	
	ltime:add_le(time_l1_time, buffer(24,4))
	ltime:add_le(time_l2_time, buffer(28,4))
	ltime:add_le(time_l3_time, buffer(32,4))
	ltime:add_le(time_l4_time, buffer(36,4))
	ltime:add_le(time_la_time, buffer(40,4))
	ltime:add_le(time_lb_time, buffer(44,4))
	ltime:add_le(time_lm_time, buffer(48,4))
	ltime:add_le(time_lc_time, buffer(52,4))
	--
	local ltotaltime = localtree:add(tcnet_proto,buffer(),"Total Time (ms)")	
	ltotaltime:add_le(time_l1_total_time, buffer(56,4))
	ltotaltime:add_le(time_l2_total_time, buffer(60,4))
	ltotaltime:add_le(time_l3_total_time, buffer(64,4))
	ltotaltime:add_le(time_l4_total_time, buffer(68,4))
	ltotaltime:add_le(time_la_total_time, buffer(72,4))
	ltotaltime:add_le(time_lb_total_time, buffer(76,4))
	ltotaltime:add_le(time_lm_total_time, buffer(80,4))
	ltotaltime:add_le(time_lc_total_time, buffer(84,4))	
	--
	local beatmarker = localtree:add(tcnet_proto,buffer(),"Layer Beat Marker")	
	beatmarker:add(time_l1_beatmarker, buffer(88,1))
	beatmarker:add(time_l2_beatmarker, buffer(89,1))
	beatmarker:add(time_l3_beatmarker, buffer(90,1))
	beatmarker:add(time_l4_beatmarker, buffer(91,1))
	beatmarker:add(time_la_beatmarker, buffer(92,1))
	beatmarker:add(time_lb_beatmarker, buffer(93,1))
	beatmarker:add(time_lm_beatmarker, buffer(94,1))
	beatmarker:add(time_lc_beatmarker, buffer(95,1))
	--
	local state = localtree:add(tcnet_proto,buffer(),"Layer State")	
	state:add(time_l1_state, buffer(96,1))
	state:add(time_l2_state, buffer(97,1))
	state:add(time_l3_state, buffer(98,1))
	state:add(time_l4_state, buffer(99,1))
	state:add(time_la_state, buffer(100,1))
	state:add(time_lb_state, buffer(101,1))
	state:add(time_lm_state, buffer(102,1))
	state:add(time_lc_state, buffer(103,1))
	--
	localtree:add(buffer(104,1),"Reserverd: " .. buffer(104,1))
	--
	localtree:add(time_smpte_mode, buffer(105,1))	
	-- L1 SMPTE
	local l1smpte = localtree:add(tcnet_proto,buffer(),"L1 SMPTE")	
	l1smpte:add(time_l1_smpte_mode, buffer(106,1))	
	l1smpte:add(time_l1_tc_state, buffer(107,1))	
	l1smpte:add(buffer(108,4),"Time Code: " .. buffer(108,1):uint() .. ":" .. buffer(109,1):uint().. ":" .. buffer(110,1):uint().. "." .. buffer(111,1):uint())
	-- L2 SMPTE
	local l2smpte = localtree:add(tcnet_proto,buffer(),"L2 SMPTE")	
	l2smpte:add(time_l2_smpte_mode, buffer(112,1))	
	l2smpte:add(time_l2_tc_state, buffer(113,1))	
	l2smpte:add(buffer(114,4),"Time Code: " .. buffer(114,1):uint() .. ":" .. buffer(115,1):uint().. ":" .. buffer(116,1):uint().. "." .. buffer(117,1):uint())
	-- L3 SMPTE
	local l3smpte = localtree:add(tcnet_proto,buffer(),"L3 SMPTE")	
	l3smpte:add(time_l3_smpte_mode, buffer(118,1))	
	l3smpte:add(time_l3_tc_state, buffer(119,1))	
	l3smpte:add(buffer(120,4),"Time Code: " .. buffer(120,1):uint() .. ":" .. buffer(121,1):uint().. ":" .. buffer(122,1):uint().. "." .. buffer(123,1):uint())
	-- L4 SMPTE
	local l4smpte = localtree:add(tcnet_proto,buffer(),"L4 SMPTE")	
	l4smpte:add(time_l4_smpte_mode, buffer(124,1))	
	l4smpte:add(time_l4_tc_state, buffer(125,1))	
	l4smpte:add(buffer(126,4),"Time Code: " .. buffer(126,1):uint() .. ":" .. buffer(127,1):uint().. ":" .. buffer(128,1):uint().. "." .. buffer(129,1):uint())
	-- LA SMPTE
	local lasmpte = localtree:add(tcnet_proto,buffer(),"LA SMPTE")	
	lasmpte:add(time_lm_smpte_mode, buffer(130,1))	
	lasmpte:add(time_lm_tc_state, buffer(131,1))	
	lasmpte:add(buffer(132,4),"Time Code: " .. buffer(132,1):uint() .. ":" .. buffer(133,1):uint().. ":" .. buffer(134,1):uint().. "." .. buffer(135,1):uint())
	-- LB SMPTE
	local lbsmpte = localtree:add(tcnet_proto,buffer(),"LB SMPTE")	
	lbsmpte:add(time_lc_smpte_mode, buffer(136,1))	
	lbsmpte:add(time_lc_tc_state, buffer(137,1))	
	lbsmpte:add(buffer(138,4),"Time Code: " .. buffer(138,1):uint() .. ":" .. buffer(139,1):uint().. ":" .. buffer(140,1):uint().. "." .. buffer(141,1):uint())
	-- LM SMPTE
	local lmsmpte = localtree:add(tcnet_proto,buffer(),"LM SMPTE")	
	lmsmpte:add(time_lm_smpte_mode, buffer(142,1))	
	lmsmpte:add(time_lm_tc_state, buffer(143,1))	
	lmsmpte:add(buffer(144,4),"Time Code: " .. buffer(144,1):uint() .. ":" .. buffer(145,1):uint().. ":" .. buffer(146,1):uint().. "." .. buffer(147,1):uint())
	-- LC SMPTE
	local lcsmpte = localtree:add(tcnet_proto,buffer(),"LC SMPTE")	
	lcsmpte:add(time_lc_smpte_mode, buffer(148,1))	
	lcsmpte:add(time_lc_tc_state, buffer(149,1))	
	lcsmpte:add(buffer(150,4),"Time Code: " .. buffer(150,1):uint() .. ":" .. buffer(151,1):uint().. ":" .. buffer(152,1):uint().. "." .. buffer(153,1):uint())
		--
	local onair = localtree:add(tcnet_proto,buffer(),"Layer OnAir")	
	onair:add(time_l1_onair, buffer(154,1))
	onair:add(time_l2_onair, buffer(155,1))
	onair:add(time_l3_onair, buffer(156,1))
	onair:add(time_l4_onair, buffer(157,1))
	onair:add(time_la_onair, buffer(158,1))
	onair:add(time_lb_onair, buffer(159,1))
	onair:add(time_lm_onair, buffer(160,1))
	onair:add(time_lc_onair, buffer(161,1))
end

udp_table = DissectorTable.get("udp.port")
udp_table:add(60000,tcnet_proto)
udp_table:add(60001,tcnet_proto)
-- udp_table:add(60002,tcnet_proto)