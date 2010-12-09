module CodeBuddy
  class Stack

    attr_reader :stack_frames
    attr_reader :selected

    def initialize(exception, selected=0)
      @selected = selected
      @stack_frames = exception.backtrace.collect do |string|
        StackFrame.new(string)
      end
    end
  end
end