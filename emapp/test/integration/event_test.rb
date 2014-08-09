require 'test_helper'

class EventTest < ActionDispatch::IntegrationTest

    describe 'User logged in' do

        before do
            @user = users(:userone)
            @event = events(:event1)
            login_as(@user)
            visit root_url
        end

        it 'must see the content' do
          assert page.has_content?('All events'), 'The page title has not been found'
        end

        it 'must not see a join button for own event' do
            assert page.has_link?('Join', :visible => false), "Invisible buttons"
        end

        it 'must see a join button for other event' do
            assert page.has_link?('Join', :visible => true), "Visible buttons"
        end

        it "can see own event" do
            find('.table-striped').first(:link, "Show").click
            visit event_path(@event)
            assert page.has_content?(@event.title), 'The event title has not been found'
        end

        it "Event page has edit options" do
            visit event_path(@event)
            assert page.has_link?('Edit'), 'The edit link has not been found'
        end

        it "Event page has back options" do
            visit event_path(@event)
            assert page.has_link?('Back'), 'The back link has not been found'
        end

        it "can edit the event" do
            visit event_path(@event)
            find('body').first(:link, "Edit").click
            assert page.has_content?('Editing event'), 'The event edit page has not been found'
        end

    end
end
