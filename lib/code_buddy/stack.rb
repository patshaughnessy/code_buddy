module CodeBuddy
  class Stack
    attr_reader   :stack_frames
    attr_accessor :selected

    def initialize(exception_or_string)
      if exception_or_string.is_a?(Exception)
        backtrace = exception_or_string.backtrace
        backtrace = exception_or_string.first.split("\n") if backtrace.size == 1  #haml errors come through this way
      else
        backtrace = exception_or_string
      end

      @stack_frames = backtrace.collect do |string|
        StackFrame.new(string)
      end
    end
  end
end
