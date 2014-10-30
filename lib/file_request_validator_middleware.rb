module MerchProductPictures
  class FileRequestValidatorMiddleware
    def initialize(app)
      @app = app
    end

    def call(env)
      if valid_request?(env[:params])
        @app.call(env)
      else
        invalid_request_answer
      end
    end

  private
    def valid_request?(params)
      params.has_key?('url') and
      params.has_key?('type') and
      VALID_PRODUCT_TYPES.include?(params['type'])
    end

    def invalid_request_answer
      [422, {}, [
        'Invalid request: Double check the params, ' +
        'read the docs and come again!'
      ]]
    end
  end
end
