module CodeBuddy
  module Server
    class << self
      
      def start
        if running?
          puts "Code Buddy is already running."
          exit
        else
          run!
        end
      end
      
      def stop
        if process_line = running?
          pid = process_line.split[1]
          Process.kill("TERM", pid.to_i)
          puts "Code Buddy stopped. (pid #{pid.to_i})"
        else
          puts "Code Buddy is not running."
          exit
        end
      end
      
      def update(stack_string)
        require 'net/http'
        require 'uri'
        require 'launchy'
        
        if running?
          Net::HTTP.post_form(URI.parse('http://localhost:4567/new'), {"stack" => stack_string})
        else
          CodeBuddy::App.stack_string = stack_string
          start
        end
        Launchy.open("http://localhost:4567/stack/0")
      end
      
      def running?
        `ps aux | grep code_buddy_server | grep -v grep`.split("\n").find{|process_line| process_line =~ /code_buddy_server/}
      end
    private 
    
    def run!
      handler      = detect_rack_handler
      handler_name = handler.name.gsub(/.*::/, '')
      port = 4567
      puts "== Code Buddy/#{CodeBuddy::VERSION} starting on on #{port}"

      Daemons.daemonize(:app_name => "code_buddy_server")
      handler.run CodeBuddy::App.new, :Host => 'localhost', :Port => port
    end

    def detect_rack_handler
      servers = Array(%w[thin mongrel webrick])
      servers.each do |server_name|
        begin
          return Rack::Handler.get(server_name.downcase)
        rescue LoadError
        rescue NameError
          puts 'rescuing...'
        end
      end
      fail "Server handler (#{servers.join(',')}) not found."
    end
    end
  end
end