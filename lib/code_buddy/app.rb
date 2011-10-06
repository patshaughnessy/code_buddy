module CodeBuddy
  class App < Sinatra::Base
    set :views,  File.expand_path(File.dirname(__FILE__) + '/views')
    if Sinatra.const_defined?("VERSION") && Gem::Version.new(Sinatra::VERSION) >= Gem::Version.new("1.3.0")
      set :public_folder, File.expand_path(File.dirname(__FILE__) + '/public')
    else
      set :public, File.expand_path(File.dirname(__FILE__) + '/public')
    end

    LOCALHOST   = [/^127\.0\.0\.\d{1,3}$/, "::1", /^0:0:0:0:0:0:0:1(%.*)?$/].freeze

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

    get '/stack' do
      display_stack(0)
    end

    get '/stack/:selected' do
      @static_file_prefix = '../'
      display_stack(params[:selected].to_i)
    end

    post '/new' do
      return 'Sorry CodeBuddy cannot paste a stack unless CodeBuddy is running locally.  This is for your own safety.' unless local_request?

      self.class.stack_string = params[:stack]
      redirect "#{path_prefix}/stack"
    end

    get '/edit/:selected' do
      return "Sorry CodeBuddy cannot edit a file unless CodeBuddy is running locally"                      unless local_request?

      self.class.stack.edit(params[:selected].to_i)
    end

    def display_stack(selected_param)
      @stack = self.class.stack
      @stack.selected = selected_param if @stack
      erb :index
    end

    def path_prefix
      self.class.path_prefix
    end

    def local_request?
      LOCALHOST.any? { |local_ip| local_ip === request.ip}
    end


  end
end
