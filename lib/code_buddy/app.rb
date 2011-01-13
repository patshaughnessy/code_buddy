require 'erb'

module CodeBuddy
  class App
    VIEW_PATH    = File.expand_path(File.dirname(__FILE__) + '/views')
    STATIC_FILES = Rack::File.new(File.expand_path(File.dirname(__FILE__) + '/public'))

    class << self
      attr_reader   :stack
      attr_accessor :path_prefix

      def exception=(exception)
        @stack = Stack.new(exception)
      end

      def stack_string=(stack_string)
        if stack_string.nil?
          @stack = nil
        else
          @stack = Stack.new(stack_string)
        end
      end
    end


    def call(env)
      request = Rack::Request.new(env)

      case request.path_info
        
      when /\/?(images|stylesheets|javascripts)/
        STATIC_FILES.call(env)

      when '/'
        [ 302, {'Location'=> "#{path_prefix}/stack" }, [] ]

      when /\/stack(\/\d+)*/
        static_file_prefix = '../' if selected($1)
        [ 200, { 'Content-Type' => 'text/html' },      display_stack(selected.to_i, static_file_prefix) ]

      when /\/edit\/(\d*)/
        self.class.stack.edit($1.to_i)
        [ 200, { 'Content-Type' => 'text/html' },      '' ]

      when /\/new/
        self.class.stack_string = request.params['stack'] 
        [ 302, {'Location'=> "#{path_prefix}/stack" }, [] ]

      else
        [ 404, {},                                     '']
      end

    end


    def selected path=''
      path =~ /\/(\d)/
      $1
    end
    
    def get_binding
      binding
    end

    def erb file
      erb = ERB.new File.read "#{VIEW_PATH}/#{file}.erb"
      erb.result self.get_binding
    end

    def display_stack(selected_param, static_file_prefix = nil)
      @static_file_prefix = static_file_prefix
      @stack = self.class.stack
      @stack.selected = selected_param if @stack
      erb :index
    rescue => e
      puts "display stackk error #{e}"
      puts e.backtrace
    end

    def path_prefix
      self.class.path_prefix 
    end

  end
end