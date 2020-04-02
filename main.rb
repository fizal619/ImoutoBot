require "sinatra"
require "discordrb"
require 'rufus-scheduler'

require "./covid.rb"

# 👨‍🎓 FEEL DUNCE? Try: https://www.codecademy.com/learn/learn-ruby 💎

# SINATRA STUFF
set :bind, "0.0.0.0"
set :protection, :except => :frame_options

get "/" do
  erb :index,  :locals => { host: request.host }
end
# END SINATRA STUFF

@bot = Discordrb::Bot.new token: ENV["DISCORD_TOKEN"]

scheduler = Rufus::Scheduler.singleton
# EVERY DAY at 1am, 9am, and 4pm?
scheduler.cron "7 5,13,21 * * *" do
  send_covid_updates @bot
end

# IMOUTOBOT WILL well have a 50% chance of RANDOMLY SENDING A MESSAGE to #op_af every half hour
scheduler.cron "55 * * * *" do
  should_i_message = [true, false].sample
  random_messages = [
    "Oniichan daisuki 😘",
    "i serve the soviet yunyun ",
    "owo 😸", 
    "I want hentai with senpai 😉🤤",
    "BAKA!!😤😡",
    "Look at these losers🤭",
    "Sadique bakaaaa 😝",
    "bt crease 🍑",
    "**Meshaan** oniichaan~😛",
    "Saeed stimky rat🐀",
    "Maitri daisuki oneechan🥰",
    "Fizal pls bathe🤢🤮",
    "ORA ORA ORA ORA ORA ORA ORA ORA ORA ORA 
    https://i.imgur.com/1wb4XCj.gif",
    "Play with me!!
    https://thumbs.gfycat.com/DirtyDetailedErmine.webp"

  ]

  if should_i_message
    # https://ruby-doc.org/core-1.9.3/Array.html#method-i-sample
    @bot.send_message channel=128661000239972353, content=random_messages.sample
  end
end

Thread.abort_on_exception = true
Thread.new {
  # DONT CHANGE ABOVE THIS LINE ====================================================
  # MIND YOUR INDENTATION PLS TY
  # Ruby Examples: https://github.com/discordrb/discordrb/tree/master/examples
  # NOTE: VOICE DOESN"T WORK ON REPLIT SADLY
  # Press start/restart to apply changes to imoutobot

  @bot.message(with_text: "imouto covid") do |event|
    # this is a function from covid.rb
    event.respond covid
  end

  @bot.message(with_text: "imouto subscribe") do |event|
    # this is a function from covid.rb
    result = covid_subscribe event.channel.id
    event.respond "Channel subscription status: #{result}"
  end

  @bot.message(with_text: "imouto roast me") do |event|
    event.respond "Oniichan BAKA! 😠 😝"
  end

  @bot.message(with_text: "imouto kiss me") do |event|
    event.respond "ew! 😒 \n https://media1.tenor.com/images/101d6d064d43691fd929ac37cc1a6b74/tenor.gif?itemid=14066819"
  end

  @bot.message(with_text: "imouto i love you") do |event|
    event.respond "d-d-daisuki"
  end

  @bot.message(with_text: "imouto levi") do |event|
    event.respond "😏 \n
    https://media.discordapp.net/attachments/128661000239972353/686412405823111183/ItachiLevi.gif"
  end

  @bot.message(with_text: "imouto") do |event|
    event.respond "hai hai imouto desu 👁👄👁"
  end
  
    
@bot.message(with_text: "imouto explosion") do |event|
    event.respond "Darkness blacker than black and darker than dark,
I beseech thee, combine with my deep crimson.
The time of awakening cometh.
Justice, fallen upon the infallible boundary,
appear now as an intangible distortions!
I desire for my torrent of power a destructive force:
a destructive force without equal!
Return all creation to cinders,
and come frome the abyss!
Explosion! \nhttps://thumbs.gfycat.com/AmazingFabulousBackswimmer-size_restricted.gif " 
  end

  @bot.message(with_text: "imouto bakuretsu") do |event|
    event.respond "bakuretsu bakuretsu la la la ( •̀ ω •́ )✧"
  end

  
  # DONT CHANGE BELOW THIS LINE ==================================================
  @bot.run
}
