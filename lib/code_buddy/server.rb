module CodeBuddy
  module Server
    class << self
      
      def start
        if running?
          puts "Code Buddy is already running."
          exit
        else
          Daemons.daemonize(:app_name => "code_buddy_server")
          CodeBuddy::App.enable :logging
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
      
      def running?
        `lsof -i :4567`.split("\n").find{|process_line| process_line =~ /ruby/}
      end
    end
  end
end