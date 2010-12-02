module CodeBuddy
  class MyCoolRailtie < Rails::Railtie
    initializer "code_buddy.add_middleware" do |app|
      app.middleware.swap ActionDispatch::ShowExceptions, CodeBuddy::ShowExceptions
    end
  end
  
  class ShowExceptions < ActionDispatch::ShowExceptions
    def call(env)
      puts "In CODE BUDDY..."
      super
    end
  end
end
