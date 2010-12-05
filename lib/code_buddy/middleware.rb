module CodeBuddy
  class Railtie < Rails::Railtie
    initializer "code_buddy.add_middleware" do |app|
      app.middleware.swap ActionDispatch::ShowExceptions, CodeBuddy::ShowExceptions
    end
  end

  class ShowExceptions < ActionDispatch::ShowExceptions

    CODEBUDDY_TEMPLATE_PATH = File.join(File.dirname(__FILE__), 'templates')

    def call(env)
      if env['PATH_INFO'] =~ /^\/code_buddy(.*)/
        env['PATH_INFO'] = $1
        App.new.call(env)
      else
        super
      end
    end

  end
end
