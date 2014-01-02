class UsersController < ApplicationController
	before_filter :authenticate_user!, :get_user_and_render, :define_paths
	helper_method :add_most_recent_movies_and_ids_to_array
	
  def show
  end
  
 
  def index
  end
  
  def create  
    super(@path)
  end

  def destroy
    super(@path) 
  end 

  def get_user_and_render
    if (current_user.username == params[:id]) || (User.where(username: params[:id]).blank?)
  	  @user = current_user
	    @render = 'users/partials/my_profile' 
      @usermovies = @user.movies.order(title: :asc).to_a
    else
      @user =  User.find(params[:id])
      @allmovies = current_user.movies.to_a
	    @render = 'users/partials/profile'
      @usermovies = @user.movies.order(title: :asc).to_a
      @ourmovies =  Tmdb::MovieStats.compare_movies(@allmovies,@usermovies)[0]
    end
    
    @usermoviesp = Kaminari.paginate_array(@usermovies).page(params[:page]).per(50)
  end

  def define_paths
    @path = profile_path(@user)
    @jpathc = 'create'
    @jpathd = 'destroy'
  end
  
  def add_most_recent_movies_and_ids_to_array(user)
    x = []
    idandmovie = []
    user.connectors.order('created_at').last(5).each do |movie|
      x << movie['movie_id']
    end
    Movie.find(x).index_by(&:id).slice(*x).each do |movid, movinfo|
      idandmovie << [movinfo['title'], movid]
    end
    return idandmovie
  end

end
