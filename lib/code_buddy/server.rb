module CodeBuddy
  module Server
    class << self
      
      def start
        if running?
          puts "Code Buddy is already running."
          exit
        else
          Daemons.daemonize(:app_name => "code_buddy_server")
          CodeBuddy::App.run! :host => 'localhost'
        end
      end
      
      def stop
        if process_line = running?
          pid = process_line.split[1]
          Process.kill("TERM", pid.to_i)
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
        `lsof -i :4567`.split("\n").find{|process_line| process_line =~ /ruby/}
      end
    end
  end
end