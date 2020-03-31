require "sinatra"
require "discordrb"
require 'rufus-scheduler'

require "./covid.rb"

set :bind, "0.0.0.0"
set :protection, :except => :frame_options

get "/" do
  erb :index,  :locals => { host: request.host }
end

@bot = Discordrb::Bot.new token: ENV["DISCORD_TOKEN"]

scheduler = Rufus::Scheduler.singleton
scheduler.every "10s" do
  # @bot.send_message("op_af", covid)
end

Thread.abort_on_exception = true
Thread.new {
  # DONT CHANGE ABOVE THIS LINE
  # MIND YOUR INDENTATION PLS TY
  # Ruby Examples: https://github.com/discordrb/discordrb/tree/master/examples
  # NOTE: VOICE DOESN"T WORK ON REPLIT SADLY

  @bot.message(with_text: "imouto covid") do |event|
    event.respond covid
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

  @bot.run

  # DONT CHANGE BELOW THIS LINE
}
