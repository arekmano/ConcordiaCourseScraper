require 'securerandom'
class Base
  attr_accessor :id
  def initialize(_ = {})
    @id = SecureRandom.uuid
  end
end
