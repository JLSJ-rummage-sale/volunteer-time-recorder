class Event < ApplicationRecord
    has_many :time_records, :dependent => :delete_all

    # Required fields:
    validates :name, presence: true
    validates :year, presence: true

    # Other methods:

    def event_title
        return (self.name.to_s + " (" + self.year.to_s + ")");
    end

end
