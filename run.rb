require_relative './lib/concordia_course_scraper'

scraper = ConcordiaCourseScraper.new(course_codes: 'ALL')
scraper.extract_all
scraper.save
