require "httparty"

def covid
  puts "\nGETTING COVID DATA\n"
  usa = JSON.parse(HTTParty.get("https://corona.lmao.ninja/states").body)
  ny = usa.find { |state| 
    # puts state
    state["state"] == "New York"  
  }

  guyana = JSON.parse(HTTParty.get("https://corona.lmao.ninja/countries/Guyana").body)

  puts "\nGOT COVID DATA\n"

  return "NY: #{ny["cases"]} cases \nGY: #{guyana["cases"]} cases \nSource: https://www.who.int/emergencies/diseases/novel-coronavirus-2019/situation-reports/"
end