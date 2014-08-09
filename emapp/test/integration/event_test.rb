require 'test_helper'

class EventTest < ActionDispatch::IntegrationTest
    describe 'home page' do

        before do
            user = users(:userone)
            # event = events(:event1)
            # event2 = events(:event2)
            login_as(user)
            visit root_url
        end

        it 'must see the content' do
          assert page.has_content?('All events'), 'The page title has not been found'
          # assert page.has_button?('Join', :visible => false), "Invisible buttons"
          # page.assert_no_selector('a')
        end

        it 'must not see a join button for own event' do
            assert page.has_link?('Join', :visible => false), "Invisible buttons"
        end

        it 'must see a join button for other event' do
            assert page.has_link?('Join', :visible => true), "Visible buttons"
        end

        # it {should have_selector('h3', text: 'Followers')}


    end
end
