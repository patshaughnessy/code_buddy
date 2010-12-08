class Stack

  attr_reader :addresses
  attr_reader :selected

  def initialize(exception, selected=0)
    @selected = selected
    @addresses = exception.backtrace.collect do |string|
      Address.new(string)
    end
  end
end
