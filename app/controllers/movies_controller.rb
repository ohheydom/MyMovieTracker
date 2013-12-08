class MoviesController < ApplicationController

  def show
	@movie = Tmdb::TheMovieDb.get_movie_by_id(params[:id])
	unless @movie["status_code"] == 6
		@moviecredits = Tmdb::TheMovieDb.get_movie_credits_by_movie_id(params[:id])
		if user_signed_in?
			@allmovies = current_user.movies.to_a 
		end
	end
  end
   
  def destroy
	super(movie_path(params[:id]))
  end
  
  
  def create
	super(movie_path(params[:id]))
  end

end