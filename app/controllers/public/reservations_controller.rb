class Public::ReservationsController < ApplicationController
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
    if current_user.id != @reservation.user_id
      redirect_back fallback_location: root_path
    end
  end

  def edit
    @reservation = Reservation.find(params[:id])
    @reservations = Reservation.where(day: @reservation.day, time_from: @reservation.time_from)
    if current_user.id != @reservation.user_id
      redirect_back fallback_location: root_path
    end
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @user = current_user
    @reservation.user_id = current_user.id
    @reservations = Reservation.where(day: @reservation.day, time_from: @reservation.time_from)
    if Reservation.find_by(day: @reservation.day, time_from: @reservation.time_from, user_id: @reservation.user_id).present?
      flash[:notice] = "既に予約が存在します。変更の場合はキャンセル後に再度予約手続きをお願いいたします"
      redirect_to reservations_path
    elsif Reservation.all_users_reservation_amount(@reservations) + @reservation.number_of_ppl <= 10
      @reservation.save
      redirect_to reservation_path(@reservation.id)
    else
      flash[:notice] = "定員オーバーです。"
      redirect_to root_path
    end
  end

  def update
    @reservation_new = Reservation.new(reservation_params)
    @reservation = Reservation.find(params[:id])
    @reservations_all = Reservation.where(day: @reservation.day, time_from: @reservation.time_from)
    @reservations_current_user = Reservation.where(day: @reservation.day, time_from: @reservation.time_from, user_id: current_user.id)
    if current_user.id != @reservation.user_id
      redirect_back fallback_location: root_path
    else
      if Reservation.all_users_reservation_amount(@reservations_all) - Reservation.current_users_reservation_amount(@reservations_current_user) + @reservation_new.number_of_ppl <= 10
        if @reservation.update(reservation_params)
          redirect_to reservation_path(@reservation.id)
        end
      else
        flash[:notice] = "定員オーバーです。"
        redirect_to root_path
      end
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    if current_user.id != @reservation.user_id
      redirect_back fallback_location: root_path
    else
      @reservation .destroy
      redirect_to reservations_path
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(:day, :time_from, :user_id, :number_of_ppl, :start_time)
  end
end
