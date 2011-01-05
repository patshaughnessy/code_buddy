module CodeBuddy
  class Railtie < Rails::Railtie
    initializer "code_buddy.add_middleware" do |app|
      if app.config.action_dispatch.show_exceptions
        app.middleware.swap ActionDispatch::ShowExceptions, CodeBuddy::ShowExceptions
        app.middleware.insert_before CodeBuddy::ShowExceptions, CodeBuddy::ShowApp
      end
    end
    CodeBuddy::App.path_prefix = '/code_buddy'
  end

  class ShowExceptions < ActionDispatch::ShowExceptions

    silence_warnings do
      ActionDispatch::ShowExceptions::RESCUES_TEMPLATE_PATH = File.join(File.dirname(__FILE__), 'templates')
    end

    def rescue_action_locally(request, exception)
      App.exception = exception
      super
    end
  end
end


