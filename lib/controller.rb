require 'bundler'
Bundler.require
require '/home/zealra/THP/semaine_5/sinatra/the_gossip_project_sinatra/lib/gossip.rb'

class ApplicationController < Sinatra::Base
  get '/' do
    erb :index
  end

  get '/gossips/new/' do
    erb :new_gossip
  end

  post '/gossips/new/' do
    gossip = Gossip.new(params[:gossip_author], params[:gossip_content])
    gossip.save
    redirect '/'
  end

  get '/' do
    erb :index, locals: {gossips: Gossip.all}
end