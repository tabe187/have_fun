class Public::ReservationsController < ApplicationController
# before_action :authenticate_user!

  def new
    @reservation = Reservation.new
    @day = params[:day]
    @time = params[:time]
    @start_time = DateTime.parse(@day + " " + @time + " " + "JST")
    message = Reservation.check_reservation_day(@day.to_date)
    if !!message
      redirect_to @reservation, flash: { alert: message }
    end
    
    
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.user_id = current_user.id
    if @reservation.save
      redirect_to reservation_path @reservation.id
    else
      render :new
    end
  end

private

  def reservation_params
    params.require(:reservation).permit(:day, :time, :user_id, :start_time)
  end
 
end
