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
        lines_of_code = File.new(path).readlines
        first_line_to_show = [1, line-CODE_WINDOW].max
        last_line_to_show  = [lines_of_code.length, line + 1 + CODE_WINDOW].min
        

        subset = lines_of_code[first_line_to_show-1, last_line_to_show-1]

        CodeRay.scan(subset, :ruby).html(:line_number_start => first_line_to_show, 
                                         :line_numbers      => :inline, 
                                         :wrap              => :span)
      rescue => exception
        "Unable to read the file #{path}"
      end
    end
  end
end