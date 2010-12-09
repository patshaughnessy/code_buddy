module CodeBuddy
  class StackFrame

    CODE_WINDOW = 10

    attr_reader :path
    attr_reader :line
    attr_reader :code

    def initialize(exception_string)
      @path, @line = exception_string.split(':')
      @line = @line.to_i
    
      code
    end

    def code
      @code ||= begin
        html_args = { :line_numbers => :inline, :wrap => :span }
        lines_of_code = File.new(path).readlines

        first_line_to_show      = [1, line-CODE_WINDOW].max
        lines_above             = lines_of_code[first_line_to_show-1 ... line-1]
        formatted_lines_above   = CodeRay.scan(lines_above,   :ruby).
                                          html(html_args.merge(:line_number_start=>first_line_to_show))

        selected_line           = lines_of_code[line-1]
        formatted_selected_line = CodeRay.scan(selected_line, :ruby).
                                          html(html_args.merge(:line_number_start=>line))

        last_line_to_show       = [lines_of_code.length, line + 1 + CODE_WINDOW].min
        lines_below             = lines_of_code[line ... last_line_to_show-1]
        formatted_lines_below   = CodeRay.scan(lines_below,   :ruby).
                                          html(html_args.merge(:line_number_start=>line+1))
        
        [ formatted_lines_above, 
          "<span class='container selected'>#{formatted_selected_line}<span class='overlay'></span></span>",
          formatted_lines_below
        ].join
      rescue => exception
        "Unable to read the file #{path}"
      end
    end
  end
end