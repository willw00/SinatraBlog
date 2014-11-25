require 'sinatra'
require 'mongo'
require 'json/ext'

include Mongo

configure do
	connection = MongoClient.new("localhost", 27017)
	set :mongo_connection, connection
	set :mongo_db, connection.db('Blog')
end

helpers do 
	def find_posts
		settings.mongo_db['Posts'].
			find().to_a
	end

	def post_by_url(url)
		settings.mongo_db['Posts'].
			find_one(:url => url).to_json
	end
end

get '/posts' do 
	@posts = find_posts
	erb :posts, :locals => {:posts => @posts}
end

get '/posts/:url' do 
	url = params[:url]
	@post = post_by_url(url)
	erb :post, :locals => {:post => @post}
end

