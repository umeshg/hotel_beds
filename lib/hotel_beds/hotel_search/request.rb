require "securerandom"
require "hotel_beds/model"
require "hotel_beds/model/requested_room"

module HotelBeds
  module HotelSearch
    class Request
      include HotelBeds::Model

      # attributes
      attribute :session_id, String, default: SecureRandom.hex[0..15]
      attribute :page_number, Integer, default: 1
      attribute :language, String, default: "ENG"
      attribute :check_in_date, Date
      attribute :check_out_date, Date
      attribute :destination, String
      attribute :hotels, Array[Integer]
      attribute :rooms, Array[HotelBeds::Model::RequestedRoom]
      attribute :group_results, Virtus::Attribute::Boolean, default: false

      # validation
      validates :language, :destination, length: { is: 3 }
      validates :session_id, :check_in_date, :check_out_date, presence: true
      validates :rooms, length: { minimum: 1, maximum: 5 }
      validates :page_number, numericality: {
        greater_than: 0, only_integer: true
      }
      validate do |search|
        unless (1..5).cover?(search.rooms.size)
          search.errors.add(:rooms, "quantity must be between 1 and 5")
        end
        unless search.rooms.all?(&:valid?)
          search.errors.add(:rooms, "are invalid")
        end
      end
    end
  end
end
