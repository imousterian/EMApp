require 'test_helper'

class EventTest < ActiveSupport::TestCase
      describe "Event validations" do

        let(:event) { events(:event1) }
        let(:user)  {  users(:usertwo) }

        before do
            event.user_id = user.id
        end

        it "is valid with valid params" do
            event.all_tags = "tag"
            event.must_be :valid?
        end

        it "should respond to user" do
            event.user_id.must_equal user.id
        end

        it "is not valid without title" do
            event.title = ""
            event.wont_be :valid?
            event.errors[:title].must_be :present?
        end

        it "end date cannot be before start date" do
            event.end_date = "2014-08-06 10:48:40"
            event.wont_be :valid?
            event.errors[:end_date].must_be :present?
        end

        it "is not valid without location" do
            event.location = ""
            event.wont_be :valid?
            event.errors[:location].must_be :present?
        end

        it "is not valid without agenda" do
            event.agenda = ""
            event.wont_be :valid?
            event.errors[:agenda].must_be :present?
        end

        it "is not valid without address" do
            event.address = ""
            event.wont_be :valid?
            event.errors[:address].must_be :present?
        end

        it "is not valid without organizer_id" do
            event.organizer_id = ""
            event.wont_be :valid?
            event.errors[:organizer_id].must_be :present?
        end

        it "is not valid without tags" do
            event.all_tags = ""
            event.wont_be :valid?
            event.errors[:all_tags].must_be :present?
        end

        it "does not allow duplicate names" do
            dup = events(:event1)
            assert_difference('Tag.count', 1) do
                dup.all_tags=('Tag2, tag2')
            end
        end

    end

end
