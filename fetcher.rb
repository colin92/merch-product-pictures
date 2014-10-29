require 'open-uri'

module MerchProductPictures
  class Fetcher

    def self.fetch(url_to_fetch, save_path)
      File.open(save_path, 'wb') do |saved_file|
        open(url_to_fetch, 'rb') do |read_file|
          saved_file.write(read_file.read)
        end
      end
    end

  end
end
