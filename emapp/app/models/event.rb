class Event < ActiveRecord::Base
    extend FriendlyId

    friendly_id :title, use: :slugged
    friendly_id :slugged_candidates, use: :slugged

    belongs_to :organizer, class_name: 'User', :foreign_key => 'organizer_id'

    has_many :taggings
    has_many :tags, through: :taggings, :dependent => :destroy

    has_many :attendances
    has_many :users, through: :attendances

    def slugged_candidates
        [
            :title,
            [:title, :location],
            [:title, :location, :organizer]
        ]
    end

    def all_tags=(names)
        self.tags = names.split(",").map do |t|
            Tag.where(name: t.strip).first_or_create!
        end
    end

    def all_tags
        tags.map(&:name).join(", ")
    end

    def self.tagged_with(name)
        Tag.find_by_name!(name).events
    end

    def self.tag_counts
        # Tag.select("tags.name, count(taggings.tag_id) as count").joins(:taggings).group("taggings.tag_id")
        # Tag.select("tags.*, count(taggings.tag_id) as count").joins(:taggings).group("tags.id")
        Tag.select("tags.name, count(taggings.tag_id) as count").joins(:taggings).group("tags.id")
    end

    def self.event_owner(organizer_id)
        User.find_by id: organizer_id
    end

    def pending_requests(event_id)
        # Attendance.where(event_id: event_id, state: 'request_sent')
        Attendance.pending.where(event_id: event_id)
    end

    def self.show_accepted_attendees(event_id)
        Attendance.accepted.where(event_id: event_id)
    end

end
