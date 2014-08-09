require 'test_helper'

class EventsControllerTest < ActionController::TestCase
    include Devise::TestHelpers

    describe "EventsController" do

        describe "when user is logged in" do

            setup do
                @event = events(:event1)
                @user1 = users(:userone)
                # sign_in users(:userone)
                sign_in @user1
            end
            it "should get index" do
                get :index
                assert_response :success
                assert_not_nil assigns(:events)
            end
            it "should get new" do
                get :new
                assert_response :success
            end
            it "should create event" do
                assert_difference('Event.count') do
                post :create, event: {
                    address: @event.address,
                    agenda: @event.agenda,
                    end_date: @event.end_date,
                    location: @event.location,
                    organizer_id: @event.organizer_id,
                    start_date: @event.start_date,
                    title: @event.title,
                    all_tags: "tag"
                    }
                end

                assert_redirected_to event_path(assigns(:event))
            end
            it "should show event" do
                get :show, id: @event
                assert_response :success
            end
            it "should get edit" do
                get :edit, id: @event
                assert_response :success
            end
            it "should update event" do
                patch :create, event: {
                    address: @event.address,
                    agenda: @event.agenda,
                    end_date: @event.end_date,
                    location: @event.location,
                    organizer_id: @event.organizer_id,
                    start_date: @event.start_date,
                    title: @event.title,
                    all_tags: "tag"
                    }
                assert_redirected_to event_path(assigns(:event))
            end

            it "should destroy event" do
                assert_difference('Event.count', -1) do
                    delete :destroy, id: @event
                end
                assert_redirected_to events_path
            end

            it "cant send a successfull join request to join own event" do
                # puts "#{}"
                get :join, event_id: @event
                assert_redirected_to root_url
                assert_equal "You can not join your own event.", flash[:notice]
            end

            it 'sends a successful join request' do

                event_to_join = events(:event_to_join)
                get :join, event_id: event_to_join
                assert_redirected_to event_path(event_to_join)
                assert_equal "Thanks! We will notify you.", flash[:notice]

            end

        end

        describe 'when user is not logged in' do
            setup do
                @event = events(:event1)
            end
            it "not authenticated should not get new" do
                get :new
                assert_response :redirect
            end
            it "not authenticated should not get edit" do
                get :edit, id: @event
                assert_response :redirect
            end
            it "not authenticated should not get detroy" do
                delete :destroy, id: @event
                assert_response :redirect
            end
        end
        describe "a wrong user" do

            setup do
                @user = users(:userone)

                @event1 = @user.organized_events.create(:address => "String",
                    :agenda => "String",
                    :end_date => "String",
                    :location => "String",
                    :start_date => "String",
                    :title => "String",
                    :all_tags => "tag"
                    )

                @wrong_user = users(:usertwo)
                sign_in @wrong_user

            end

            it "cannot edit someone else's event" do
                get :edit, id: @event1
                assert_redirected_to root_url
            end

            it "cannot delete someone else's event" do
                 assert_difference('Event.count', 0) do
                    delete :destroy, id: @event1
                end
                assert_redirected_to root_url
            end

        end

        describe "an event owner" do

            setup do
                @event_to_accept = events(:event_to_join)
                @user1 = users(:userone)

                @attendance = attendances(:two)

                sign_in @user1
            end

            it "sends an acceptance response" do

                get(:accept_request, { :event_id =>  @attendance.event_id,  :attendance_id =>  @attendance.id } )
                assert_redirected_to event_path(@event_to_accept)
                assert_equal "Accepted!", flash[:notice]

            end

            it "sends an rejection response" do

                get(:reject_request, { :event_id =>  @attendance.event_id,  :attendance_id =>  @attendance.id } )
                assert_redirected_to event_path(@event_to_accept)
                assert_equal "Rejected!", flash[:notice]

            end

        end
    end

end
