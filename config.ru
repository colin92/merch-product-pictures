require 'rubygems'
require 'bundler/setup'

require 'rack'
require './app'
require './lib/params_middleware'
require './lib/root_only_middleware'
require './lib/file_request_validator_middleware'

use MerchProductPictures::ParamsMiddleware
use MerchProductPictures::RootOnlyMiddleware
use MerchProductPictures::FileRequestValidatorMiddleware
run MerchProductPictures::App.new