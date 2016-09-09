require_relative './lib/concordia_course_scraper'

scraper = ConcordiaCourseScraper.new
scraper.extract_all
scraper.save
