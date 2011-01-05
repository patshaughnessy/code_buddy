module CodeBuddy
  class StackFrame

    CODE_WINDOW = 10

    attr_reader :path
    attr_reader :line

    def initialize(exception_string)
      if exception_string =~ /\s*([^:\s]+):([0-9]+)\s*/
        @path = $1
        @line = $2.to_i
      else
        @path = exception_string
        @line = 0
      end
      code
    end

    def code
      @code ||= begin
        html_args = { :line_numbers => :inline, :wrap => :span }
        lines_of_code = File.new(path).readlines

        first_line_to_show      = [1, line-CODE_WINDOW].max
        last_line_to_show       = [lines_of_code.length, line + 1 + CODE_WINDOW].min
        code_to_show            = lines_of_code[first_line_to_show-1 .. last_line_to_show-1]
        formatted_lines = CodeRay.scan(code_to_show,   :ruby).
                                       html(:line_numbers      => :inline,
                                            :wrap              => :span,
                                            :bold_every        => false,
                                            :line_number_start => first_line_to_show)
        
        highlighted_line = line - first_line_to_show + 1
        formatted_lines_array = formatted_lines.split("\n")
        formatted_lines_array[highlighted_line-1] = "<span class='container selected'>#{formatted_lines_array[highlighted_line-1]}<span class='overlay'></span></span>"
        formatted_lines_array.join("\n")
      rescue => exception
        "<span class=\"coderay\">Unable to read file:\n&nbsp;\"#{@path}\"</span>"
      end
    end
    
    def open_in_editor
      case ENV['EDITOR']
      when 'mate'
        `mate #{path} -l #{line}`
      when 'mvim'
        `mvim +#{line} #{path}` 
      else
        puts "Sorry unable to open the file for editing.  Please set your environment variable to either mate or mvim 'export EDITOR=mate' and restart the server"
      end
    end
  end
end
