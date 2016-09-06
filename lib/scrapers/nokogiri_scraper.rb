require 'open-uri'
require 'openssl'
require 'nokogiri'

class NokogiriScraper
  def get_data(noko_object)
    noko_object.content.gsub(/[^0-9A-Za-z:]/, '')
  end

  def load_uri(uri)
    Nokogiri::HTML(
      open(
        uri,
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
      )
    )
  end
end