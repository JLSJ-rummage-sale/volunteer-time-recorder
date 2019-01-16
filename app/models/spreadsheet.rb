class Spreadsheet < ApplicationRecord

  # Relationships:
  has_one :event

  has_many :volunteers_uploaded
  has_many :volunteers, through: :volunteers_uploaded

  has_many :planned_shifts_uploaded
  has_many :planned_shifts, through: :planned_shifts_uploaded

  has_many :import_errors

end
