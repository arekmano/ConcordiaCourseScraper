require 'capybara/poltergeist'
require 'capybara'
require 'capybara/dsl'

Capybara.run_server = false
Capybara.current_driver = :poltergeist
Capybara.app_host = 'https://fcms.concordia.ca/'
Capybara.default_max_wait_time = 5

class CapybaraScraper
  include Capybara::DSL
  def get_results(course_code, term)
    visit '/fcms/asc002_stud_all.aspx'
    select_term(term)
    fill_course(course_code)
    submit
    page.source
  end

  def submit
    click_on 'Search'
    sleep 1
    raise 'Too many Classes' if page.text =~ /maximum limit of 300 sections/
    raise 'No match for code' if page.text =~ /no results that match the criteria specified/
    click_on 'OK' if page.text =~ /over 100 classes/
    find('#CLASS_SRCH_WRK2_SSR_PB_MODIFY')
  end

  def select_term(term)
    within('#ACE_DERIVED_CLSRCH_SSR_GROUP1') do
      execute_script("document.getElementsByTagName('option')[0].value = #{term}") if has_no_css?("option[value='#{term}']")
      find("option[value='#{term}']").select_option
    end
  end

  def fill_course(course_code)
    check 'SSR_CLSRCH_WRK_CU_CRSE_LVL_200$3'
    check 'SSR_CLSRCH_WRK_CU_CRSE_LVL_300$3'
    check 'SSR_CLSRCH_WRK_CU_CRSE_LVL_400$3'
    check 'SSR_CLSRCH_WRK_CU_CRSE_LVL_500$3'
    check 'SSR_CLSRCH_WRK_CU_CRSE_LVL_600$3'
    check 'SSR_CLSRCH_WRK_CU_CRSE_LVL_700$3'
    check 'SSR_CLSRCH_WRK_CU_CRSE_LVL_800$3'
    fill_in 'SSR_CLSRCH_WRK_SUBJECT$1', with: course_code
  end
end
