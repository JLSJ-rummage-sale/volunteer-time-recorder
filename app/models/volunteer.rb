class Volunteer < ApplicationRecord

    has_many :time_records, :dependent => :delete_all
    has_one :member_type

    # Attributes: first_name, last_name, email_address, notes, phone, member_type_id

    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email_address, presence: true

    # Scopes:

    scope :newest_first, lambda { order("created_at DESC") }
    scope :sorted, lambda { order("first_name ASC") }
    scope :last_name_first, lambda { order("last_name ASC") }
    scope :search, lambda { |query| where(["first_name LIKE ? OR last_name LIKE ?", "%#{query}%", "%#{query}%"]) if query.present? }
    scope :of_member_type, lambda { |member_type_id| where(["member_type_id = ?", "#{member_type_id}"]) if member_type_id.present? }

    # Other methods:

    def full_name
        return (self.first_name.to_s + " " + self.last_name.to_s);
    end

    def full_name_with_email
        return (self.first_name.to_s + " " + self.last_name.to_s + " <" + self.email_address + ">");
    end

    def to_string
        return "VOLUNTEER:{id: " + self.id.to_s + ", " +
                "first_name: " + self.first_name.to_s + ", " +
                "last_name: " + self.last_name.to_s + ", " +
                "email_address: " + self.email_address.to_s + ", " +
                "phone: " + self.phone.to_s + ", " +
                "notes: " + self.notes.to_s + ", " +
                "member_type_id: " + self.member_type_id.to_s +
                " }";
    end

end
