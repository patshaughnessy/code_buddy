module CodeBuddy
  module Server
    class << self
      
      def start
        if running?
          puts "Code Buddy is already running."
          exit
        else
          $0 = "code_buddy server"
          Daemons.daemonize(:backtrace => true, :log_dir => File.join(File.dirname(__FILE__), "../../tmp"))
          CodeBuddy::App.run! :host => 'localhost'
        end
      end
      
      def stop
        if process_line = running?
          pid = process_line.split[0]
          Process.kill("TERM", pid)
        else
          puts "Code Buddy is not running."
          exit
        end
      end
      
      def running?
        `ps`.split("\n").any?{|process_line| process_line =~ /code_buddy server/}
      end
    end
  end
end