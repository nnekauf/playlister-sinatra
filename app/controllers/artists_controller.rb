class ArtistsController < ApplicationController
    get '/artists' do
        @artists = Artist.all
        erb :'/artists/index'
    end

    # get '/artists/:id' do
    #     @artist = Artist.find_by(id: params[:id])
    #     @songs = Song.all.each do |s|
    #         s if s.artist_id == @artist.id
    #     end
        
    #     erb :'/artists/show'
    # end

    # get '/artists/new' do
        
    #     erb :'/artists/new'
    # end

    get '/artists/:slug' do
        @artist = Artist.find_by_slug(params[:slug])
        
        erb :'/artists/show'
    end
end
