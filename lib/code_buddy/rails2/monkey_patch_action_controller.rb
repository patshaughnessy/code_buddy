# For Rails 2.3.x we need to monkey patch action controller to alter the exception templates

module ActionController
  class Base
    silence_warnings do
      ActionController::Base::RESCUES_TEMPLATE_PATH = File.join(File.dirname(__FILE__), 'templates')
    end
    def rescue_action_locally(exception)
      CodeBuddy::App.exception = exception
      code_buddy_rescue_templates_path = ActionView::Template::EagerPath.new_and_loaded(File.join(File.dirname(__FILE__), "templates"))
      @template.instance_variable_set("@exception", exception)
      @template.instance_variable_set("@rescues_path", code_buddy_rescue_templates_path)
      @template.instance_variable_set("@contents",
      @template.render(:file => template_path_for_local_rescue(exception)))
      response.content_type = Mime::HTML
      render_for_file(rescues_path("layout"), response_code_for_rescue(exception))
    end
  end
end
