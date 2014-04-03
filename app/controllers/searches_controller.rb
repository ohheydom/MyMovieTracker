class SearchesController < ApplicationController
  before_filter :define_paths

  def show
    @querystring = params[:query]
    @type = params[:type]
    if @type == 'actor'
      @render = 'actor'
    else
      @render = 'movie'
      @search_movies_list = Tmdb::TheMovieDb.search_by_movie_title(@querystring)
      if user_signed_in?
        user_movies
        @ourmovies =  Tmdb::MovieStats.compare_movies(@allmovies,@search_movies_list['results'])[0]
        @listpart = '/shared_partials/list_of_movies'
      else
        @listpart = '/shared_partials/list_of_movies_not_signed_in'
      end
    end
  end

  def define_paths
    @jpathc = 'create'
    @jpathd = 'destroy'
  end
end
