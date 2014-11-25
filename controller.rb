require 'sinatra'
require 'mongo'
require 'json/ext'

include Mongo

configure do
	mongo_uri = ENV['MONGOLAB_URI']
	connection = mongo_uri ? MongoClient.from_uri(mongo_uri) : 
			MongoClient.new("localhost", 27017)

	set :mongo_connection, connection
	set :mongo_db, connection.db('Blog')
end

helpers do 
	def find_posts
		settings.mongo_db['Posts'].
			find().to_a
	end

	def find_post_by_url(url)
		settings.mongo_db['Posts'].
			find_one(:url => url).to_json
	end

	def find_posts_by_tag(tag)
		settings.mongo_db['Posts'].
			find(:tags => tag).to_a
	end
end

get '/' do 
	erb :index
end

get '/posts' do 
	@posts = find_posts
	erb :posts, :locals => {:posts => @posts}
end

get '/posts/:url' do 
	url = params[:url]
	@post = find_post_by_url(url)
	erb :post, :locals => {:post => @post}
end

get '/posts/tag/:tag' do 
	tag = params[:tag]
	@posts = find_posts_by_tag(tag)
	erb :posts, :locals => {:posts => @posts}
end


