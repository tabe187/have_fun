class Public::HomesController < ApplicationController
  skip_before_action :require_sign_in!, only: [:top, :about]

  def top
    @reservations = Reservation.all.where("day >= ?", Date.current).where("day < ?", Date.current >> 3).order(day: :desc)
  end
end
