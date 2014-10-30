require 'digest/sha1'
require 'mime-types'
require './fetcher'
require './lib/file_streamer'

VALID_PRODUCT_TYPES = ['pillow'].freeze

module MerchProductPictures

  class App
    def call(env)
      params = env[:params]

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
    def filename_from_params(params)
      Digest::SHA1.base64digest(params['type']+params['url']).gsub(/=/, '_').gsub(/\//, '-')
    end
  end

end