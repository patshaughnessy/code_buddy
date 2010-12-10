require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe CodeBuddy::ShowExceptions do
  let (:app) { mock }
  subject { CodeBuddy::ShowApp.new(app) }

  describe 'Non code_buddy URLs' do
    it 'should not call the Sinatra app when a non code_buddy URL is found' do
      CodeBuddy::App.expects(:new).never
      env = { 'PATH_INFO' => '/some_other_path' }
      app.expects(:call).with(env)
      subject.call(env)
    end

    it 'should not call the Sinatra app when code_buddy is found later in the URL' do
      CodeBuddy::App.expects(:new).never
      env = { 'PATH_INFO' => '/some_other_path/code_buddy' }
      app.expects(:call).with(env)
      subject.call(env)
    end
  end

  describe 'code_buddy URLs' do
    it 'should call the Sinatra app when a code_buddy URL is found and pass in the remaining path only' do
      code_buddy_app = mock
      CodeBuddy::App.expects(:new).returns(code_buddy_app)
      code_buddy_app.expects(:call).with({ 'PATH_INFO' => '/12' })
      env = { 'PATH_INFO' => '/code_buddy/12' }
      app.expects(:new).never
      subject.call(env)
    end

    it 'should call the Sinatra app with a null path when the code_buddy root URL is found' do
      code_buddy_app = mock
      CodeBuddy::App.expects(:new).returns(code_buddy_app)
      code_buddy_app.expects(:call).with({ 'PATH_INFO' => '' })
      env = { 'PATH_INFO' => '/code_buddy' }
      app.expects(:new).never
      subject.call(env)
    end
  end
end
