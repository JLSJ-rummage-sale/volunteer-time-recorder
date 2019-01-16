class PlannedShiftsUploaded < ApplicationRecord
  belongs_to :spreadsheet
  belongs_to :planned_shift

  scope :for_spreadsheet, lambda { |spreadsheet_id| where(["spreadsheet_id = ?", "#{spreadsheet_id}"]) if spreadsheet_id.present? }

end
