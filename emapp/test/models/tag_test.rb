require 'test_helper'

class TagTest < ActiveSupport::TestCase
    let(:event) { events(:event1) }

    before do
        event.all_tags = 'Tag1'
    end

    it "creates valid tags" do

        tag = Tag.where(name: event.all_tags.strip).first_or_create!
        tag.must_be :valid?

    end

    it "does not create empty tags" do
        tag = Tag.first_or_create!
        tag.name = nil
        tag.wont_be :valid?
    end

    it "makes all tag names downcase" do
        tag = Tag.where(name: event.all_tags.strip).first_or_create!
        assert tag.name == 'tag1', "Tags names can only be downcase"
    end

    it "does not allow dup names" do
        tag1 = Tag.where(:name => 'tag2').create!
        tag2 = tag1.dup
        tag2.wont_be :valid?
        tag2.errors.must_include(:name)
    end

end
