require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CodeBuddy::Stack do
  it 'should create a series of stack frames from an exception' do
    backtrace = [
      "/Users/me/my_app/config.ru:1:in `new'",
      "/Users/me/my_app/config.ru:1"
    ]
    CodeBuddy::StackFrame.expects(:new).with("/Users/me/my_app/config.ru:1:in `new'").returns(frame1=mock)
    CodeBuddy::StackFrame.expects(:new).with("/Users/me/my_app/config.ru:1"         ).returns(frame2=mock)
    stack = CodeBuddy::Stack.new mock(:backtrace=>backtrace)  
    stack.stack_frames.should == [frame1, frame2]
  end
  
  it 'should save the currently selected stack frame' do
    stack = CodeBuddy::Stack.new mock(:backtrace=>''), 3  
    stack.selected.should == 3
  end

end
