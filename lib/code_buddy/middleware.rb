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


    # Render detailed diagnostics for unhandled exceptions rescued from
    # a controller action.
    def rescue_action_locally(request, exception)
      template = ActionView::Base.new([CODEBUDDY_TEMPLATE_PATH],
        :request => request,
        :exception => exception,
        :application_trace => application_trace(exception),
        :framework_trace => framework_trace(exception),
        :full_trace => full_trace(exception)
      )
      file = "rescues/#{@@rescue_templates[exception.class.name]}.erb"
      body = template.render(:file => file, :layout => 'rescues/layout.erb')
      App.exception = exception
      render(status_code(exception), body)
    end

  end
end
