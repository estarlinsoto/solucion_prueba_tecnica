class Earthquake < ApplicationRecord
    validates :mag, :place, :time, :url, :mag_type, :title, :longitude, :latitude, presence: true
    validates :mag, inclusion: { in: -1.0..10.0 }
    validates :longitude, numericality: { greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0 }
    validates :latitude, numericality: { greater_than_or_equal_to: -90.0, less_than_or_equal_to: 90.0 }
    validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp }
end
