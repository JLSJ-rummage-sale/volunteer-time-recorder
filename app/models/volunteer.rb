class Volunteer < ApplicationRecord

    # Relationships:
    has_many :time_records, :dependent => :delete_all
    has_many :planned_shifts, :dependent => :delete_all
    has_one :member_type

    # Attributes: first_name, last_name, email_address, notes, phone, member_type_id

    # Required fields:
    validates :first_name, presence: true
    validates :last_name, presence: true
    validates :email_address, presence: true

    # Scopes:

    scope :newest_first, lambda { order("created_at DESC") }
    scope :sorted, lambda { order("first_name ASC") }
    scope :last_name_first, lambda { order("last_name ASC") }
    scope :search, lambda { |query| where(["LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ? OR email_address LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%"]) if query.present? }
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

    def remove_spreadsheet_connection
      upload_records = VolunteersUploaded.where(volunteer_id: self.id);
      upload_records.each do |record|
        record.destroy;
      end

      # Also need to manually remove spreadsheet connection for planned shifts:
      self.planned_shifts.each do |shift|
        shift.remove_spreadsheet_connection
      end
    end

    # Export to CSV:
    def self.as_csv
      CSV.generate do |csv|

        # puts "column_names = #{column_names}"

        # Create row names that are more readable:
        custom_column_names = []

        column_names.each do |column_name|
          column_name = column_name.gsub("_", " ") # Replaces all underscores with spaces.
          column_name = column_name.titleize # Capitalizes each word.
          custom_column_names << column_name
        end

        custom_column_names << "Member Type"

        csv << custom_column_names #column_names
        all.each do |item|
          # puts "item = #{item}; class = #{item.class.name}"
          # puts "item.attributes = #{item.attributes}; class = #{item.attributes.class.name}"
          # puts "item.attributes.values_at(*column_names) = #{item.attributes.values_at(*column_names)}; class = #{item.attributes.values_at(*column_names).class.name}"

          row = item.attributes.values_at(*column_names)
          member_type = MemberType.find_by_id(item.member_type_id);

          member_type_name = (member_type) ? member_type.name : "No Member Type"
          row << member_type_name.to_s
          puts "row = #{row}"
          csv << row
        end
      end
    end

    # Export to CSV __ORIGINAL__:
    # def self.as_csv
    #   CSV.generate do |csv|
    #     csv << column_names
    #     all.each do |item|
    #       csv << item.attributes.values_at(*column_names)
    #     end
    #   end
    # end

end
