module CodeBuddy
  class Railtie < Rails::Railtie
    initializer "code_buddy.add_middleware" do |app|
      if app.config.action_dispatch.show_exceptions
        app.middleware.swap          ActionDispatch::ShowExceptions, CodeBuddy::ShowExceptions, app.config.consider_all_requests_local
        app.middleware.insert_before CodeBuddy::ShowExceptions, CodeBuddy::ShowApp
      end
    end
  end

  class ShowExceptions < ActionDispatch::ShowExceptions

    silence_warnings do
      ActionDispatch::ShowExceptions::RESCUES_TEMPLATE_PATH = File.join(File.dirname(__FILE__), 'templates')
    end

    def rescue_action_locally(request, exception)
      CodeBuddy::App.exception = exception
      super
    end
  end
end


