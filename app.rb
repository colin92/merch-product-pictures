require 'digest/sha1'
require 'mime-types'
require './fetcher'

VALID_PRODUCT_TYPES = ['pillow'].freeze

class FileStreamer
  def initialize(path)
    @file = File.open(path)
  end

  def each(&blk)
    @file.each(&blk)
  ensure
    @file.close
  end
end

module MerchProductPictures

  class App
    def call(env)
      params = extract_params(env)

      return not_found_answer unless env['REQUEST_PATH'] == '/'
      return invalid_request_answer unless valid_request?(params)

      # Hash deterministic params to get unique filename
      file_name = filename_from_params(params)
      save_path = File.expand_path('store/' + file_name + '.jpg', '.')

      # Only fetch and transform if image
      # was not already processed and stored
      unless File.exists? save_path
        begin
          # Fetch
          Fetcher.fetch(params['url'], save_path)

          # Transform
          # Transformer.transform(params['type'], save_path)
        rescue => e
          return [500, {}, ['Error occured', "\n\n", e.class.name, "\n", e.message]]
        end
      end

      [
        200,
        {'Content-Type' => MIME::Types.type_for(save_path).first.to_s },
        FileStreamer.new(save_path)
      ]
    end

  private

    def valid_request?(params)
      params.has_key?('url') and
        params.has_key?('type') and
        VALID_PRODUCT_TYPES.include?(params['type'])
    end

    def invalid_request_answer
      [422, {}, ['Invalid request: Double check the params, read the doc and come again!']]
    end

    def not_found_answer
      [404, {}, ['Page not found']]
    end

    def filename_from_params(params)
      Digest::SHA1.base64digest(params['type']+params['url']).gsub(/=/, '_').gsub(/\//, '-')
    end

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