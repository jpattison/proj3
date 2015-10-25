require 'mandrill'

class AdminController < HelperController
  #emails all users using mandril
  def email
    m = Mandrill::API.new 'Ce1GEUdL9HgIcxu0g-ezwA'
    User.all.each do |user|
      #uses send_email from HelperController to send email
      send_email user
    end
    render nothing: true
  end
  #scrapes for all users
  def scrape
    User.all.each do |user|
      user.scrape_articles
    end
    render nothing: true
  end
end
