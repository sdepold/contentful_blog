require "active_support/core_ext"
require "sinatra"

set :root, File.dirname(__FILE__)
set :server, "webrick"

configure do
  I18n.default_locale = "en-US"

  require File.join(settings.root, "models", "content_model.rb")
  Dir[File.join(settings.root, "models", "*.rb")].each { |file| require file }
end

get "/" do
  erb :index, locals: { posts: BlogPost.all }
end

get "/:id" do
  erb :show, locals: { post: BlogPost.from_slug(params[:id]) }
end
