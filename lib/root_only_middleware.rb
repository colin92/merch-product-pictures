module MerchProductPictures
  class RootOnlyMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if env['REQUEST_PATH'] == '/'
        @app.call(env)
      else
        [404, {}, ['Page not found']]
      end
    end
  end
end
