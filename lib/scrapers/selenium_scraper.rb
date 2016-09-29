require 'selenium-webdriver'
require_relative './fcms_scraper'

class SeleniumScraper
  def start
    @driver = Selenium::WebDriver.for :chrome
    @driver.navigate.to 'https://campus.concordia.ca/psc/pscsprd/EMPLOYEE/HRMS/c/CU_EXT.CU_CLASS_SEARCH.GBL'
  end

  def end
    @driver.close
  end

  def get_results(course_code, term)
    @driver.navigate.refresh
    select_term(term)
    fill_course(course_code)
    sleep 1
    submit

    wait = Selenium::WebDriver::Wait.new(timeout: 5)
    wait.until {
      !@driver.find_elements(:id, 'CLASS_SRCH_WRK2_SSR_PB_NEW_SEARCH').empty? ||
      !@driver.find_elements(:class, 'SSSMSGINFOTEXT').empty?
    }
    click_ok unless @driver.find_elements(:class, 'SSSMSGINFOTEXT').empty?

    html = @driver.page_source
    html
  end

  def click_ok
    @driver.find_element(:id, '#ICSave').click
    wait = Selenium::WebDriver::Wait.new(timeout: 30)
    wait.until { @driver.find_element(:class, 'PAPAGETITLE').text.match('Search Results') }
  end

  def submit
    @driver.find_element(:id, 'CLASS_SRCH_WRK2_SSR_PB_CLASS_SRCH').click
  end

  def fill_course(course_code)
    code_box = @driver.find_element(:name, 'SSR_CLSRCH_WRK_SUBJECT$1')
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_SUBJECT$1').click
    @driver.execute_script("arguments[0].setAttribute('value', arguments[1])", code_box, course_code)
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_CU_CRSE_LVL_200$3').click
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_CU_CRSE_LVL_300$3').click
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_CU_CRSE_LVL_400$3').click
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_CU_CRSE_LVL_500$3').click
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_CU_CRSE_LVL_600$3').click
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_CU_CRSE_LVL_700$3').click
    @driver.find_element(:name, 'SSR_CLSRCH_WRK_CU_CRSE_LVL_800$3').click
  end

  def select_term(term_number)
    unless term_number.to_s =~ /216/
      @driver.execute_script(
        "arguments[0].setAttribute('value', arguments[1])",
        dropdown.options[1],
        term_number.to_s
      )
      wait = Selenium::WebDriver::Wait.new(timeout: 5)
      wait.until {
        dropdown.options[1].attribute('value') == term_number.to_s
      }
    end
    dropdown.select_by(:value, term_number.to_s)
  end

  def dropdown
    dropdown_node = @driver.find_element(:name, 'CLASS_SRCH_WRK2_STRM$35$')
    Selenium::WebDriver::Support::Select.new(dropdown_node)
  end
end