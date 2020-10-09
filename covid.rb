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

  netherlands = JSON.parse(HTTParty.get("https://corona.lmao.ninja/v2/countries/Netherlands").body)

  puts "\nGOT COVID DATA\n"

  return "**NY**: #{number_format ny["todayCases"]} cases today
**GY**: #{number_format guyana["todayCases"]} cases today
**FL**: #{number_format florida["todayCases"]} cases today
**CN**: #{number_format china["todayCases"]} cases today
**NL**: #{number_format netherlands["todayCases"]} cases today
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


