require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CodeBuddy::StackFrame do
  subject { CodeBuddy::StackFrame.new("/gems/actionpack-3.0.3/lib/abstract_controller/base.rb:3:in `new'") }

  describe 'initialization' do
    before do
      CodeBuddy::StackFrame.any_instance.expects(:code).returns('def some_code_here end')
    end
    
    it 'should have the file path' do
      subject.path.should == '/gems/actionpack-3.0.3/lib/abstract_controller/base.rb'
    end
    it 'should have the line number' do
      subject.line.should == 3
    end
  end
  
  describe 'formatting code from the source file' do
    describe 'with a valid file' do
      let(:source_code) { [
        "require 'active_support/configurable'\n",
        "require 'active_support/descendants_tracker'\n",
        "require 'active_support/core_ext/module/anonymous'\n",
        "\n",
        "module AbstractController\n",
        "  class Error < StandardError; end\n",
        "  class ActionNotFound < StandardError; end\n",
        "\n",
        "  # <tt>AbstractController::Base</tt> is a low-level API. Nobody should be\n",
        "  # using it directly, and subclasses (like ActionController::Base) are\n",
        "  # expected to provide their own +render+ method, since rendering means\n",
        "  # different things depending on the context.  \n",
        "  class Base\n",
        "    attr_internal :response_body\n",
        "    attr_internal :action_name\n",
        "    attr_internal :formats\n",
        "\n",
        "    include ActiveSupport::Configurable\n",
        "    extend ActiveSupport::DescendantsTracker\n",
        "\n",
        "    class << self\n",
        "      attr_reader :abstract\n",
        "      alias_method :abstract?, :abstract\n",
        "\n",
        "      # Define a controller as abstract. See internal_methods for more\n",
        "      # details.\n",
        "      def abstract!\n",
        "        @abstract = true\n",
        "      end\n",
        "\n",
        "      # A list of all internal methods for a controller. This finds the first\n",
        "      # abstract superclass of a controller, and gets a list of all public\n",
        "      # instance methods on that abstract class. Public instance methods of\n"
        ] }
    
      before do
        File.expects(:new).with('/gems/actionpack-3.0.3/lib/abstract_controller/base.rb').
                           returns(mock(:readlines=>source_code))
      end

      it 'should read code from the middle of a file' do
        CodeRay.expects(:scan).with(source_code[4..25].join, :ruby).returns(parsed_code=mock)
        parsed_code.expects(:html).
                    with(:line_number_start => 5, :line_numbers => :inline, :wrap => :span, :bold_every=>false).
                    returns(formatted_source=mock)
                    
        formatted_source.expects(:split).with("\n").returns((5..25).to_a)

        stack_frame = CodeBuddy::StackFrame.new("/gems/actionpack-3.0.3/lib/abstract_controller/base.rb:15:in `new'") 
        stack_frame.code.should == "5\n6\n7\n8\n9\n10\n11\n12\n13\n14\n<span class='container selected'>15<span class='overlay'></span></span>\n16\n17\n18\n19\n20\n21\n22\n23\n24\n25"
      end
      it 'should read code from the top of a file' do
        CodeRay.expects(:scan).with(source_code[0..13].join, :ruby).returns(parsed_code=mock)
        parsed_code.expects(:html).
                    with(:line_number_start => 1, :line_numbers => :inline, :wrap => :span, :bold_every=>false).
                    returns(formatted_source=mock)
        formatted_source.expects(:split).with("\n").returns((1..13).to_a)     

        stack_frame = CodeBuddy::StackFrame.new("/gems/actionpack-3.0.3/lib/abstract_controller/base.rb:3:in `new'") 

        stack_frame.code.should == "1\n2\n<span class='container selected'>3<span class='overlay'></span></span>\n4\n5\n6\n7\n8\n9\n10\n11\n12\n13"
      end
      it 'should read code from the bottom of a file' do
        CodeRay.expects(:scan).with(source_code[19..32].join, :ruby).returns(parsed_code=mock)
        parsed_code.expects(:html).
                    with(:line_number_start => 20, :line_numbers => :inline, :wrap => :span, :bold_every=>false).
                    returns(formatted_source=mock)
        formatted_source.expects(:split).with("\n").returns((20..33).to_a)    

        stack_frame = CodeBuddy::StackFrame.new("/gems/actionpack-3.0.3/lib/abstract_controller/base.rb:30:in `new'") 
      
        stack_frame.code.should == "20\n21\n22\n23\n24\n25\n26\n27\n28\n29\n<span class='container selected'>30<span class='overlay'></span></span>\n31\n32\n33"
      end
    end
    
    it 'should return an error message in the code when unable to read the source file' do
      File.expects(:new).with('/no/such/file.rb').
                         raises(Errno::ENOENT.new('/no/such/file.rb'))

      stack_frame = CodeBuddy::StackFrame.new('/no/such/file.rb') 
      stack_frame.code.should == "<span class=\"coderay\">Unable to read file:\n&nbsp;\"/no/such/file.rb\"</span>"
    end
  end
end
