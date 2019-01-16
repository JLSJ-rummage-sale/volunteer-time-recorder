class VolunteersUploaded < ApplicationRecord
  belongs_to :spreadsheet
  belongs_to :volunteer

  scope :for_spreadsheet, lambda { |spreadsheet_id| where(["spreadsheet_id = ?", "#{spreadsheet_id}"]) if spreadsheet_id.present? }
end
