script_name('FarmPresent by Dashok.')
script_properties("FarmPresent")
script_version('1.0')

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
    local fpath = os.getenv('TEMP') .. '\\testing_version.json' -- куда будет качаться наш файлик для сравнения версии
    downloadUrlToFile('https://raw.githubusercontent.com/Dashok1234/Lua-SAMP-RDS/main/update.json', fpath, function(id, status, p1, p2) -- ссылку на ваш гитхаб где есть строчки которые я ввёл в теме или любой другой сайт
      if status == dlstatus.STATUS_ENDDOWNLOADDATA then
      local f = io.open(fpath, 'r') -- открывает файл
      if f then
        local info = decodeJson(f:read('*a')) -- читает
        updatelink = info.updateurl
        if info and info.latest then
          version = tonumber(info.latest) -- переводит версию в число
          if version > tonumber(thisScript().version) then -- если версия больше чем версия установленная то...
            lua_thread.create(goupdate) -- апдейт
          else -- если меньше, то
            update = false -- не даём обновиться 
            sampAddChatMessage(tag .. 'У вас и так последняя версия! Обновление отменено')
          end
        end
      end
    end
  end)
  end
  --скачивание актуальной версии
  function goupdate()
  sampAddChatMessage(tag .. 'Обнаружено обновление. AutoReload может конфликтовать. Обновляюсь...')
  sampAddChatMessage(tag .. 'Текущая версия: '..thisScript().version..". Новая версия: "..version)
  wait(300)
  downloadUrlToFile(updatelink, thisScript().path, function(id3, status1, p13, p23) -- качает ваш файлик с latest version
    if status1 == dlstatus.STATUS_ENDDOWNLOADDATA then
    sampAddChatMessage(tag .. 'Обновление завершено!')
    thisScript():reload()
  end
  end)
  end