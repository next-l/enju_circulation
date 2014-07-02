
every 5.minute do
  rake "enju_message:send"
end

every 1.day, :at => '0:00 am' do
  rake "enju_circulation:expire"
  runner "User.lock_expired_users"
end

every 1.day, :at => '5:00 am' do
  rake "enju_circulation:send_notification"
end
