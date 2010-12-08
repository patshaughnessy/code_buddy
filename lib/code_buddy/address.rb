class Address

  CODE_WINDOW = 10

  attr_reader :path
  attr_reader :line
  attr_reader :code

  def initialize(exception_string)
    @file, @line = exception_string.split(':')
    @line = @line.to_i
    
    @code = code
  end

 def code
   file = File.new(@file)
   lines = file.readlines
   if line < CODE_WINDOW
     first_line = 0
   else
     first_line = line-CODE_WINDOW
   end
   #puts "DEBUG first_line #{first_line}"
   if line+CODE_WINDOW > lines.size-1
     last_line = lines.size-1
   else
     last_line = line+CODE_WINDOW
   end
   #puts "DEBUG last_line #{last_line}"
   subset = lines.slice(first_line, last_line-first_line+1)
   result = []
   subset.each_with_index do |line_of_code, index|
     result << { :code => CodeRay.scan(line_of_code, :ruby).html(:wrap => :span), :highlighted => (index+first_line == line-1) }
   end
   result.join(' ')
 end
end
