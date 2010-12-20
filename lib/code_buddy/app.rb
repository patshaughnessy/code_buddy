module CodeBuddy
  class App < Sinatra::Base
    set :views,  File.dirname(__FILE__) + '/views'
    set :public, File.dirname(__FILE__) + '/public'

    class << self
      attr_reader   :stack
      attr_accessor :rails

      def exception=(exception)
        @stack = Stack.new(exception)
      end

      def stack_string=(stack_string)
        @stack = Stack.new(stack_string)
      end
    end

    get '/' do
      redirect "#{rails_prefix}/stack"
    end

    get '/code_buddy/new' do
      erb :form
    end

    post '/code_buddy/new' do
      self.class.stack_string = params[:stack]
      redirect "#{rails_prefix}/stack"
    end

    get '/code_buddy/stack' do
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
        redirect "#{rails_prefix}/new"
      end
    end

    def rails_prefix
      self.class.rails ? '/code_buddy' : ''
    end

  end
end
