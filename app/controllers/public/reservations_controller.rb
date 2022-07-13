class Public::ReservationsController < ApplicationController
# before_action :authenticate_user!

  def new
    @reservation = Reservation.new
    @day = params[:day]
    @time = params[:time_from]
    @start_time = DateTime.parse(@day + " " + "00:00" + " " + "JST")
    @reservations = Reservation.where(day: @day, time_from: @time)
    message = Reservation.check_reservation_day(@day.to_date)
    if !!message
      redirect_to @reservation, flash: { alert: message }
    end
  end

  def index
    @user = current_user
    @reservations = Reservation.where(user_id: @user.id).order(day: :desc)
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def edit
    @reservation = Reservation.find(params[:id])
    @reservations = Reservation.where(day: @reservation.day, time_from: @reservation.time_from)
  end

  def update
    @reservation = Reservation.find(params[:id])
    reservations = Reservation.reservations_after_three_month
    @reservations = Reservation.where(day: @day, time_from: @time, user_id: @reservation.user_id)
    number_of_ppl = 0
      @reservations.each do |r|
        number_of_ppl += r.number_of_ppl
      end
    @total = view_context.check_reservation(reservations, @reservation.day, @reservation.time_from) - number_of_ppl + @reservation.number_of_ppl
    if @total <= 10
        @reservation.update(reservation_params)
        redirect_to reservation_path(@reservation.id)
    else
        flash[:notice] = "定員オーバーです。"
        redirect_to root_path
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation .destroy
    redirect_to reservations_path
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @user = current_user
    @reservation.user_id = current_user.id
    reservations = Reservation.reservations_after_three_month
    if Reservation.find_by(day: @reservation.day, time_from: @reservation.time_from, user_id: @reservation.user_id).present?
      flash[:notice] = "既に予約が存在します。変更の場合はキャンセル後に再度予約手続きをお願いいたします"
      redirect_to reservations_path
    elsif view_context.check_reservation(reservations, @reservation.day, @reservation.time_from) + @reservation.number_of_ppl <= 10
      @reservation.save
      redirect_to reservation_path(@reservation.id)
    else
      flash[:notice] = "エラーが発生しました。"
      redirect_to root_path
    end
  end

private

  def reservation_params
    params.require(:reservation).permit(:day, :time_from, :user_id, :number_of_ppl, :start_time)
  end

end
