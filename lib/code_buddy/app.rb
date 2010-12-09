module CodeBuddy
  class App < Sinatra::Base
    set :views,  File.dirname(__FILE__) + '/views'
    set :public, File.dirname(__FILE__) + '/public'

    class << self
      attr_reader :stack

      def exception=(exception)
        @stack = Stack.new(exception)
      end

      def stack_string=(stack_string)
        @stack = Stack.new(stack_string)
      end
    end

    get '/' do
      erb :form
    end

    post '/' do
      self.class.stack_string = params[:stack]
      redirect '/stack'
    end

    get '/stack' do
      display_stack(0)
    end

    get '/stack/:selected' do
      display_stack(params[:selected].to_i)
    end

    def display_stack(selected_param)
      @stack = self.class.stack
      if @stack
        @stack.selected = selected_param
        erb :index
      else
        redirect '/'
      end
    end
  end
end
