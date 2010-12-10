module CodeBuddy
  class ShowApp
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['PATH_INFO'] =~ /^\/code_buddy(.*)/
        env['PATH_INFO'] = $1
        App.new.call(env)
      else
        @app.call(env)
      end
    end
  end
end
