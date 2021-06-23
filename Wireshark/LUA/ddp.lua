----------------------------------------
-- script-name: ddp.lua
--
-- Author: Arjan van Vught <arjan.van.vught@gmail.com>
-- GitHub: https://github.com/vanvught/h3dmx512-zip
-- Based on specification: http://www.3waylabs.com/ddp/
----------------------------------------

local ddp_proto = Proto("DistributedDisplayProtocol","Distributed Display Protocol")

local ids = {
	[1] = "Display",
	[250] = "Config",
	[251] = "Status"
}

-- Header fields
local flags1_version = ProtoField.uint8("ddp.header.flags1.version", "Version", base.DEC, NULL, 0xC0)

local flags1_push = ProtoField.uint8("ddp.header.flags1.push", "PUSH", base.DEC, NULL , 0x01)
local flags1_query = ProtoField.uint8("ddp.header.flags1.query", "QUERY", base.DEC, NULL, 0x02)
local flags1_reply = ProtoField.uint8("ddp.header.flags1.reply", "REPLY", base.DEC, NULL , 0x04)
local flags1_storage = ProtoField.uint8("ddp.header.flags1.storage", "STORAGE", base.DEC, NULL, 0x08)
local flags1_time = ProtoField.uint8("ddp.header.flags1.time", "TIME", base.DEC, NULL , 0x10)

local flags2 = ProtoField.uint8("ddp.header.flags2", "Flags2", base.DEC)
local message_type = ProtoField.uint8("ddp.header.messagetype", "Message Type", base.DEC, message_types)
local id = ProtoField.uint8("ddp.header.id", "Id", base.DEC, ids)
local offset = ProtoField.uint32("ddp.header.offset", "Offset", base.DEC)
local len = ProtoField.uint16("ddp.header.len", "Length", base.DEC)

local json = ProtoField.string("ddp.data.json", "JSON")

ddp_proto.fields = { 
	flags1_version, flags1_push, flags1_query, flags1_reply, flags1_storage, flags1_time,
	flags2, message_type, id, offset, len, json
}
					
function ddp_proto.dissector(buffer, pinfo, tree)
  length = buffer:len()
 
 	if length == 0 then return end

 	pinfo.cols.protocol = "DDP"
  
 	local subtree = tree:add(ddp_proto,buffer(),"Distributed Display Protocol Data")
	
	local managementtree = subtree:add(ddp_proto,buffer(0,10),"Header")
	
	local flags1tree = managementtree:add(ddp_proto,buffer(),"Flags1")
	flags1tree:add(flags1_version, buffer(0,1))
	flags1tree:add(flags1_push, buffer(0,1))
	flags1tree:add(flags1_query, buffer(0,1))
	flags1tree:add(flags1_reply, buffer(0,1))
	flags1tree:add(flags1_storage, buffer(0,1))
	flags1tree:add(flags1_time, buffer(0,1))
	
	local flags2tree = managementtree:add(ddp_proto,buffer(),"Flags2")
	flags2tree:add(flags2, buffer(1,1))
	
	managementtree:add(message_type, buffer(2,1))
	managementtree:add(id, buffer(3,1))
	managementtree:add(offset, buffer(4,4))
	managementtree:add(len, buffer(8,2))

	local id =  buffer(3,1):uint()
	local id_text = ids[id]

	if id_text == nil then
		id_text = "Not known / Not implemented"
	end
		
	pinfo.cols.info = "Id: " .. id_text

	if (length > 10) then
		local messagetree = tree:add(ddp_proto,buffer(10),id_text)
		messagetree:add(json, buffer(10))
	end

end

udp_table = DissectorTable.get("udp.port")
udp_table:add(4048,ddp_proto)