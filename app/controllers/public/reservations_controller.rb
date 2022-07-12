class Public::ReservationsController < ApplicationController
# before_action :authenticate_user!

  def new
    @reservation = Reservation.new
    @day = params[:day]
    @time = params[:time_from]
    @start_time = DateTime.parse(@day + " " + "00:00" + " " + "JST")
    message = Reservation.check_reservation_day(@day.to_date)
    if !!message
      redirect_to @reservation, flash: { alert: message }
    end
  end
  
  def index
    @user = current_user
  end  

  def show
    @reservation = Reservation.find(params[:id])
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @user = current_user
    @reservation.user_id = current_user.id
    reservations = Reservation.reservations_after_three_month
    if Reservation.find_by(day: @reservation.day, time_from: @reservation.time_from, user_id: @reservation.user_id).present?
        render :index
    elsif view_context.check_reservation(reservations, @reservation.day, @reservation.time_from) + @reservation.number_of_ppl < 13
      if @reservation.save
        redirect_to reservation_path @reservation.id
      else
        render :new
      end
    else
        render :new
    end  
  end

private

  def reservation_params
    params.require(:reservation).permit(:day, :time_from, :user_id, :number_of_ppl, :start_time)
  end

end
