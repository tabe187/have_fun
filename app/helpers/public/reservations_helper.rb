module Public::ReservationsHelper

  def check_reservation(reservations, day, time)
    result = false
    reservations_count = reservations.count
    count = 0
    if reservations_count >= 1
      reservations.each do |reservation|
        result = reservation[:day].eql?(day.strftime("%Y-%m-%d")) && reservation[:time].eql?(time)
        count = count + reservation[:number_of_ppl] if result
      end
      return count
    elsif reservations_count == 1
      result = reservations[0][:day].eql?(day.strftime("%Y-%m-%d")) && reservations[0][:time].eql?(time)
      count += reservations[0][:number_of_ppl] if result
      return count
    end
    return count
  end

end
