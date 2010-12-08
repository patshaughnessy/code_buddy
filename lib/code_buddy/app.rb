require 'sinatra'

module CodeBuddy
  class App < Sinatra::Base
    set :views,  File.dirname(__FILE__) + '/views'
    set :public, File.dirname(__FILE__) + '/public'


    def self.exception=(exception)
      @exception = exception
    end
    def self.exception
      @exception
    end


    get '/:selected' do
      @stack = Stack.new(self.class.exception, params[:selected].to_i)
      erb :index
    end
  end
end
