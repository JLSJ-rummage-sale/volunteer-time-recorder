class MemberType < ApplicationRecord

    # Required fields:
    validates :name, presence: true
    validates :quota_hours, presence: true

    # Scopes:

    scope :sorted, lambda { order("quota_hours ASC") }

    # Other methods:

    def volunteers_with_this_member_type
        volunteers_with_member_type = Volunteer.of_member_type(self.id);

        if volunteers_with_member_type.nil?
          volunteers_with_member_type = Array.new;
        end

        puts("volunteers_with_member_type = " + volunteers_with_member_type.to_s);
        return volunteers_with_member_type;
    end

    def volunteer_count
        volunteers = volunteers_with_this_member_type;
        return volunteers.count;
    end
end
