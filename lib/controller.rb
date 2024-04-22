require 'bundler'
Bundler.require
require '/home/zealra/THP/semaine_5/sinatra/the_gossip_project_sinatra/lib/gossip.rb'

class ApplicationController < Sinatra::Base
  get '/' do
    erb :index, locals: { gossips: Gossip.all }
  end

  get '/gossips/new/' do
    erb :new_gossip
  end

  post '/gossips/new/' do
    gossip = Gossip.new(nil, params[:gossip_author], params[:gossip_content])
    gossip.save
    redirect '/'
  end

  get '/gossips/:id' do
    @gossip = Gossip.find(params[:id])
    if @gossip
      erb :show
    else
      "Potin non trouvé"
    end
  end

  get '/gossips/:id/edit/' do
    @gossip = Gossip.find(params[:id])
    erb :edit
  end

  post '/gossips/:id/edit/' do
    Gossip.update_gossip(params[:id], params[:gossip_author], params[:gossip_content])
    redirect '/'
  end
end