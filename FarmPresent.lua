script_name('FarmPresent by Dashok.')
script_properties("FarmPresent")
script_version('1.1')

require "lib.moonloader"

local dlstatus = require('moonloader').download_status

local encoding							= require "encoding"
encoding.default 						= "CP1251"
u8 										= encoding.UTF8

local tag = "{E3294D}FarmPresent: {FFFFFF}"

local coord = {
    {648.24139404297, -1381.8989257813, 21.849822998047},
    {708.10321044922, -1477.6281738281, 17.6953125},
    {933.71398925781, -1438.9669189453, 13.554634094238},
    {600.71148681641, -1135.7568359375, 47.547241210938},
}


function main()
    repeat wait(0) until isSampAvailable()

    sampAddChatMessage(tag .. "FarmPresebt load")

     sampfuncsRegisterConsoleCommand("farmpresent",function()
         lua_thread.create(function()
            for i = 1, #coord do
            setCharCoordinates(PLAYER_PED, coord[i][1], coord[i][2], coord[i][3])
            wait(3000)
           end
        end)
     end)

    while true do
        wait(0)
        
    end
end

function update()
    local fpath = os.getenv('TEMP') .. '\\testing_version.json' -- êóäà áóäåò êà÷àòüñÿ íàø ôàéëèê äëÿ ñðàâíåíèÿ âåðñèè
    downloadUrlToFile('https://raw.githubusercontent.com/Dashok1234/Lua-SAMP-RDS/main/update.json', fpath, function(id, status, p1, p2) -- ññûëêó íà âàø ãèòõàá ãäå åñòü ñòðî÷êè êîòîðûå ÿ ââ¸ë â òåìå èëè ëþáîé äðóãîé ñàéò
      if status == dlstatus.STATUS_ENDDOWNLOADDATA then
      local f = io.open(fpath, 'r') -- îòêðûâàåò ôàéë
      if f then
        local info = decodeJson(f:read('*a')) -- ÷èòàåò
        updatelink = info.updateurl
        if info and info.latest then
          version = tonumber(info.latest) -- ïåðåâîäèò âåðñèþ â ÷èñëî
          if version > tonumber(thisScript().version) then -- åñëè âåðñèÿ áîëüøå ÷åì âåðñèÿ óñòàíîâëåííàÿ òî...
            lua_thread.create(goupdate) -- àïäåéò
          else -- åñëè ìåíüøå, òî
            update = false -- íå äà¸ì îáíîâèòüñÿ 
            sampAddChatMessage(tag .. 'Ó âàñ è òàê ïîñëåäíÿÿ âåðñèÿ! Îáíîâëåíèå îòìåíåíî')
          end
        end
      end
    end
  end)
  end
  --ñêà÷èâàíèå àêòóàëüíîé âåðñèè
  function goupdate()
  sampAddChatMessage(tag .. 'Îáíàðóæåíî îáíîâëåíèå. AutoReload ìîæåò êîíôëèêòîâàòü. Îáíîâëÿþñü...')
  sampAddChatMessage(tag .. 'Òåêóùàÿ âåðñèÿ: '..thisScript().version..". Íîâàÿ âåðñèÿ: "..version)
  wait(300)
  downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- êà÷àåò âàø ôàéëèê ñ latest version
    if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
    sampAddChatMessage(tag .. 'Îáíîâëåíèå çàâåðøåíî!')
    thisScript():reload()
  end
  end)
  end
