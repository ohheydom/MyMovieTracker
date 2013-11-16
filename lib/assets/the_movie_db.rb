require 'faraday'
require 'json'

module Tmdb

class TheMovieDb

#Constants
	API_KEY = '47f84ce170c3f96cdfb8a690d1d29615'
	BASE_URI = 'http://api.themoviedb.org/3'
	PICTURE_URL = 'http://d3gtl9l2a4fn1j.cloudfront.net/t/p/w92'
	
	
	
	
	
   @conn = Faraday.new(:url => BASE_URI  ) do |faraday|
   faraday.request  :url_encoded             # form-encode POST params
   faraday.params = {api_key: API_KEY}
   faraday.response :logger   # log requests to STDOUT
   faraday.headers['Content-Type'] = 'application/json'
   faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
   end
  
  



  
	def self.get_movie_by_id (movie_id)
		x = @conn.get 'movie/' + movie_id
		JSON.parse(x.body)
	end

	def self.get_movie_credits_by_movie_id(movie_id)
		x = @conn.get "movie/#{movie_id}/credits"
		JSON.parse(x.body)
	end

	def self.get_movie_credits_by_id(person_id)
		x = @conn.get "person/#{person_id}/movie_credits"
		JSON.parse(x.body)
	end

	
	def self.search_by_movie_title(movie_title)
		x = @conn.get 'search/movie', {query: CGI::escape(movie_title) }
		JSON.parse(x.body)
	end
	
	def self.search_by_person(person)
		x = @conn.get 'search/person', {query: CGI::escape(person) }
		JSON.parse(x.body)
	end
	
	
end

end
