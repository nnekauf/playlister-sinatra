class SongsController < ApplicationController

    get '/songs' do
        @songs = Song.all
        erb :'/songs/index'
    end

    # get 'songs/:id' do
    #     @song = Song.find_by(id: params[:id])
    #     @artist = Artist.find_by(id: @song.artist_id)
    #     erb :'/songs/show'
    # end

    get '/songs/new' do
        
        erb :'/songs/new'
    end

    get '/songs/:slug' do
      
       @song = Song.find_by_slug(params[:slug])
       @artist = Artist.find_or_create_by(id: @song.artist_id)
       song_genre = SongGenre.find_or_create_by(song_id: @song.id)
       genre_id = song_genre.genre_id
       @genre = Genre.find_by(id: genre_id)
       
        erb :'/songs/show'
    end

    post '/songs' do
        @song = Song.create(name: params["Name"])
        @song.artist = Artist.find_or_create_by(name: params["Artist Name"])
        @song.genre_ids = params[:genres]
        @song.save
    # if !song.artist
    flash[:message] = "Successfully created song."
      redirect "/songs/#{@song.slug}"
    end
      #   erb :"/songs/show"
      # end
    
      get '/songs/:slug/edit' do
        @song = Song.find {|song| song.slug == params[:slug]}
        @a = Artist.find_or_create_by(id: @song.artist_id)
        
        erb :'/songs/edit'
      end
    
      patch '/songs/:slug' do
        
        @song = Song.find {|song| song.slug == params[:slug]}
        @song.name = params["Name"] 
        @new_artist = Artist.find_or_create_by(name: params["Artist Name"])
        @song.artist_id  = @new_artist.id 
        @song.save

        if params[:genres] #if genre is filled out
          @genres = Genre.find_by(id: params[:genres]) #then we find it, set to var
        #binding.pry #must make the current songs genre equal to this genre
          @songgenre = SongGenre.find_or_create_by(song_id: @song.id) #we create a songgenre by the current songs id
          @songgenre.genre_id = @genres.id #we make the songgenre that has the current song id also have the genres id creaating the association between song and genre
          # @genres.each do |genre|
          #   song_genre = SongGenre.new(song: @song, :genre => genre)
          #   song_genre.save
          # end
        else #if no genre is filled out, we have to clear that song's genre
          @songgenre = SongGenre.find_or_create_by(song_id: @song.id)
          @songgenre.genre_id = nil
        end
        @songgenre.save #save the song again just incase
        flash[:message] = "Successfully created song."
        # @song.save
        

       
      redirect "/songs/#{@song.slug}"
    end
end

