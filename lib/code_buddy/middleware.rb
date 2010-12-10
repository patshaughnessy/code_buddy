def rails_loaded
  Module.const_get('Rails')
  return true
rescue NameError
  return false
end

if rails_loaded
  module CodeBuddy
    class Railtie < Rails::Railtie
      initializer "code_buddy.add_middleware" do |app|
        if app.config.action_dispatch.show_exceptions
          app.middleware.swap ActionDispatch::ShowExceptions, CodeBuddy::ShowExceptions
        end
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
end
