require "httparty"
require 'json'

FILENAME = './imouto_covid_memory.json'

# GET COVID UPDATES
def covid
  puts "\nGETTING COVID DATA\n"
  usa = JSON.parse(HTTParty.get("https://corona.lmao.ninja/states").body)
  ny = usa.find { |state| 
    # puts state
    state["state"] == "New York"  
  }

  guyana = JSON.parse(HTTParty.get("https://corona.lmao.ninja/countries/Guyana").body)

  florida = usa.find { |state| 
    # puts state
    state["state"] == "Florida"  
  }

  puts "\nGOT COVID DATA\n"

  return "**NY**: #{ny["cases"]} cases \n**GY**: #{guyana["cases"]} cases \n**FL**: #{florida["cases"]} cases\n**Source**: https://www.who.int/emergencies/diseases/novel-coronavirus-2019/situation-reports/"
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
