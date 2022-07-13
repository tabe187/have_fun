class Reservation < ApplicationRecord
  
  belongs_to :user
  
  enum times: { "9:00": 0, "11:00": 1, "13:00": 2, "15:00": 3 }
  
  def self.reservations_after_three_month
    reservations = Reservation.all.where("day >= ?", Date.current).where("day < ?", Date.current >> 3).order(day: :desc)
    reservation_data = []
    reservations.each do |reservation|
      reservations_hash = {}
      reservations_hash.merge!(day: reservation.day.strftime("%Y-%m-%d"), time: reservation.time_from, number_of_ppl: reservation.number_of_ppl, user_id: reservation.user_id)
      reservation_data.push(reservations_hash)
    end
    reservation_data
  end
  
  def self.check_reservation_day(day)
    if day < Date.current
      return "過去の日付は選択できません。正しい日付を選択してください。"
    elsif (Date.current >> 3) < day
      return "3ヶ月以降の日付は選択できません。正しい日付を選択してください。"
    end
  end
  
  validate :date_before_start
  validate :date_three_month_end


  def date_before_start
    errors.add(:day, "は過去の日付は選択できません") if day < Date.current
  end

  def date_three_month_end
    errors.add(:day, "は3ヶ月以降の日付は選択できません") if (Date.current >> 3) < day
  end

end
