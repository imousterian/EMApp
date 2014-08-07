class AddAllTagsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :all_tags, :string
  end
end
