# frozen_string_literal: true

desc 'This task is called by the Heroku scheduler add-on'
task send_reminders: :environment do
  User::NotifyOfPendingCards.call
end
