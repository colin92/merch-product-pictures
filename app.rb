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

      file_hash = Digest::SHA1.base64digest(params['type']+params['url']).gsub(/=/, '_').gsub(/\//, '-')
      save_path = File.expand_path('store/' + file_hash + '.jpg', '.')
      Fetcher.fetch(params['url'], save_path)

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