class Reservation < ApplicationRecord
  belongs_to :user

  enum times: { "9:00": 0, "11:00": 1, "13:00": 2, "15:00": 3 }

  def self.check_reservation(reservations, day, time)
    result = false
    count = 0
    reservations.each do |reservation|
      result = reservation[:day].strftime("%Y-%m-%d").eql?(day.strftime("%Y-%m-%d")) && reservation[:time_from].eql?(time)
      count += reservation[:number_of_ppl] if result
    end
    count
  end

  def self.check_reservation_day(day)
    if day < Date.current
      "過去の日付は選択できません。正しい日付を選択してください。"
    elsif (Date.current >> 3) < day
      "3ヶ月以降の日付は選択できません。正しい日付を選択してください。"
    end
  end

  def self.all_users_reservation_amount(reservations)
    count = 0
    reservations.each do |r|
      count += r.number_of_ppl
    end
    count
  end

  def self.current_users_reservation_amount(reservations)
    count = 0
    reservations.each do |r|
      count += r.number_of_ppl
    end
    count
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
