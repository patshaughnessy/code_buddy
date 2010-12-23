module CodeBuddy
  class App < Sinatra::Base
    set :static, true
    set :views,  File.dirname(__FILE__) + '/views'
    set :public, File.dirname(__FILE__) + '/public'

    class << self
      attr_reader   :stack
      attr_accessor :path_prefix

      def exception=(exception)
        @stack = Stack.new(exception)
      end

      def stack_string=(stack_string)
        @stack = Stack.new(stack_string)
      end
    end

    get '/' do
      redirect "#{path_prefix}/stack"
    end

    get '/new' do
      erb :form
    end

    post '/new' do
      self.class.stack_string = params[:stack]
      redirect "#{path_prefix}/stack"
    end

    get '/stack' do
      display_stack(0)
    end

    get '/stack/:selected' do
      @static_file_prefix = '../'
      display_stack(params[:selected].to_i)
    end

    def display_stack(selected_param)
      @stack = self.class.stack
      if @stack
        @stack.selected = selected_param
        erb :index
      else
        redirect "#{path_prefix}/new"
      end
    end

    def path_prefix
      self.class.path_prefix
    end

  end
end
