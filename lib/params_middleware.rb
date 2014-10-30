module MerchProductPictures
  class ParamsMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      env[:params] = extract_params(env)
      @app.call(env)
    end

  private
    def extract_params(env)
      params = {}
      env['QUERY_STRING'].split('&').each do |param|
        splitted_param = param.split('=')
        params[splitted_param[0]] = splitted_param[1]
      end
      params
    end
  end
end
