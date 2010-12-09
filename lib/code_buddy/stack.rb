module CodeBuddy
  class Stack
    attr_reader   :stack_frames
    attr_accessor :selected

    def initialize(exception_or_string)
      if exception_or_string.is_a?(Exception)
        @selected = selected
        @stack_frames = exception_or_string.backtrace.collect do |string|
          StackFrame.new(string)
        end
      else
        @stack_frames = exception_or_string.collect do |string|
          StackFrame.new(string)
        end
      end
    end
  end
end
