require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CodeBuddy::ShowExceptions do
  subject { CodeBuddy::ShowExceptions.new }

  describe 'Non code_buddy URLs' do
    it 'should not call the Sinatra app when a non code_buddy URL is found' do
      CodeBuddy::App.expects(:new).never
      env = { 'PATH_INFO' => '/some_other_path' }
      subject.call(env)
    end

    it 'should not call the Sinatra app when code_buddy is found later in the URL' do
      CodeBuddy::App.expects(:new).never
      env = { 'PATH_INFO' => '/some_other_path/code_buddy' }
      subject.call(env)
    end
  end

  describe 'code_buddy URLs' do
    it 'should call the Sinatra app when a code_buddy URL is found and pass in the remaining path only' do
      app = mock
      CodeBuddy::App.expects(:new).returns(app)
      app.expects(:call).with({ 'PATH_INFO' => '/12' })
      env = { 'PATH_INFO' => '/code_buddy/12' }
      subject.call(env)
    end

    it 'should call the Sinatra app when a code_buddy URL is found and pass in the remaining path only' do
      app = mock
      CodeBuddy::App.expects(:new).returns(app)
      app.expects(:call).with({ 'PATH_INFO' => '' })
      env = { 'PATH_INFO' => '/code_buddy' }
      subject.call(env)
    end
  end
end
