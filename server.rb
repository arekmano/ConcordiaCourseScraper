require 'sinatra'
require_relative './lib/concordia_course_scraper'
require_relative './lib/database_populators/sql_populator'

set :port, ENV['PORT']

get '/' do
  populator = SqlPopulator.new(
    username: ENV['CONCORDIA_COURSE_USER'],
    password: ENV['CONCORDIA_COURSE_PASS'],
    host: ENV['CONCORDIA_COURSE_HOST'],
    database: ENV['CONCORDIA_COURSE_DB']
  )
  scraper = ConcordiaCourseScraper.new(
      course_codes: 'ALL',
      database_populator: populator
  )
  scraper.extract_all(214)
  scraper.extract_all(215)
  scraper.extract_all(216)
  scraper.save
end