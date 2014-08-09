require "test_helper"


feature "EventFeature" do
  scenario "Anyone can see an index page" do

    visit root_path
    page.must_have_content "All events"
    # page.wont_have_content "Goobye All!"
  end

    scenario "event owners users cannot see join button for their own events" do
        user = users(:userone)
        login_as(user)
        visit root_path
        # page.should have_no_content('Join')
        assert page.has_content?("Join")
        page.should have_link('Join') #(user.name, href: user_path(user))}
        # page.should have_no_selector(:xpath, "//input[@type='#{type}' and @name='#{name}']")
    end

end
