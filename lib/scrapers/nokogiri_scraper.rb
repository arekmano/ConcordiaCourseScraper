class NokogiriScraper
  def self.get_data(noko_object)
    noko_object.content.gsub(/[^0-9A-Za-z:]/, '')
  end
end