module CodeBuddy
  class ShowApp
    def initialize(app)
      @app = app

      CodeBuddy::App.path_prefix = '/code_buddy'
    end

    def call(env)
      if env['PATH_INFO'] =~ /^\/code_buddy(.*)/
        env['PATH_INFO'] = $1 #strip the code_buddy/ prefix
        CodeBuddy::App.new.call(env)
      else
        @app.call(env)
      end
    end
  end
end
