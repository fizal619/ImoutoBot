require "httparty"
require 'json'

FILENAME = './imouto_covid_memory.json'

def number_format(number, delimiter=",")
  number.to_s.gsub(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1#{delimiter}")
end

# GET COVID UPDATES
def covid
  puts "\nGETTING COVID DATA\n"
  usa = JSON.parse(HTTParty.get("https://corona.lmao.ninja/v2/states").body)
  ny = usa.find { |state| 
    # puts state
    state["state"] == "New York"  
  }

  guyana = JSON.parse(HTTParty.get("https://corona.lmao.ninja/v2/countries/Guyana").body)

  china = JSON.parse(HTTParty.get("https://corona.lmao.ninja/v2/countries/China").body)

  florida = usa.find { |state| 
    # puts state
    state["state"] == "Florida"  
  }

  puts "\nGOT COVID DATA\n"

  return "**NY**: #{number_format ny["cases"]} cases, #{number_format ny["cases"]-(ny["deaths"]+ny["active"])} recovered, #{number_format ny["deaths"]} deaths
**GY**: #{number_format guyana["cases"]} cases, #{number_format guyana["recovered"]} recovered, #{number_format guyana["deaths"]} deaths
**FL**: #{number_format florida["cases"]} cases, #{number_format florida["cases"]-(florida["deaths"]+florida["active"])} recovered, #{number_format florida["deaths"]} deaths
**CN**: #{number_format china["cases"]} cases, #{number_format china["recovered"]} recovered, #{number_format china["deaths"]} deaths
**Source**: https://www.who.int/emergencies/diseases/novel-coronavirus-2019/situation-reports/"


end

# SAVE A CHANNEL TO THE SUBSCRIPTION LIST
def covid_subscribe(channel_id) 
  file = File.open(FILENAME, "r")
  contents = file.read
  file.close
  db = []

  begin
    db = JSON.parse(contents)
  rescue 
    puts "file empty owo"
  end
  
  if !db.include? channel_id
    file = File.open(FILENAME, "w")
    db.push channel_id
    file.write db.to_json
    file.close
    return "subscribed ✅"
  else 
    file = File.open(FILENAME, "w")
    db.delete channel_id
    file.write db.to_json
    file.close
    return "unsubscribed ❌"
  end
end

# SEND covid updates to all subscribed channels
def send_covid_updates(bot)
  file = File.open(FILENAME, "r")
  contents = file.read
  file.close
  db = []

  begin
    db = JSON.parse(contents)
  rescue 
    puts "file empty owo"
  end

  covid_message = covid

  db.each { |channel_id| 
    bot.send_message channel = channel_id, content = covid_message
  }

end


