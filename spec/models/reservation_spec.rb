require 'rails_helper'

describe '予約状況を確認するテスト' do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:reservations){
    [
      create(:reservation, user_id: user1.id),
      create(:reservation, day: "2022-07-19", user_id: user2.id)
    ]
  }
  it "正しい予約人数が返されているかを確認するテスト" do
    user1
    user2
    reservations
    expect(Reservation.check_reservation(reservations, reservations[0].day, reservations[0].time_from)).to eq(reservations[0].number_of_ppl)
  end
end

describe '予約状況を確認するテスト' do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:reservations){
    [
      create(:reservation, user_id: user1.id),
      create(:reservation, user_id: user2.id)
    ]
  }
  it "同日の予約人数が正しく返されているかを確認するテスト" do
    user1
    user2
    reservations
    expect(Reservation.all_users_reservation_amount(reservations)).to eq(reservations[0].number_of_ppl + reservations[1].number_of_ppl)
  end
end

describe '予約状況を確認するテスト' do
  let(:user1) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:reservations){
    [
      create(:reservation, user_id: user1.id),
      create(:reservation, user_id: user2.id)
    ]
  }
  it "指定のユーザーの予約人数が正しく返されているかを確認するテスト" do
    user1
    user2
    reservations
    current_user_reserve = Reservation.where(user_id: user1.id)
    expect(Reservation.current_users_reservation_amount(current_user_reserve)).to eq(reservations[0].number_of_ppl)
  end
end  
  
describe '予約日を確認するテスト' do
  it "予約日が過去の日付且ではないかを確認するテスト" do
    day = "Fri, 15 Jul 2022"
    expect(Reservation.check_reservation_day(day.to_date)).to eq("過去の日付は選択できません。正しい日付を選択してください。")
  end
end

describe '予約日を確認するテスト' do
  it "予約日が3ヶ月以降ではないかを確認するテスト" do
    day = "Wed, 30 Nov 2022"
    expect(Reservation.check_reservation_day(day.to_date)).to eq("3ヶ月以降の日付は選択できません。正しい日付を選択してください。")
  end
end