class ListsController < ApplicationController
  before_filter :define_paths

  def show
    Rails.cache.delete(:moviecredits)
    @list = Tmdb::TheMovieDb.get_list_by_id(params[:id])
    @listp = Kaminari.paginate_array(@list['items']).page(params[:page]).per(50)
    if user_signed_in?
      @listpart = '/shared_partials/list_of_movies'
      @ourmovies =  Tmdb::MovieStats.compare_movies(user_movies, @list['items'])[0]
    else
      @listpart = '/shared_partials/list_of_movies_not_signed_in'
    end 
  end

  def index
  end

  def define_paths
    @path = movies_path
    @jpathc = 'create_and_count'
    @jpathd = 'destroy_and_count'
  end
end
