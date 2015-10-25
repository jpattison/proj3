# The_Digest Created by Jeremy Pattison jpattison@student.unimelb.edu.au 637841 on 20 sep 2015
# Credit goes to Matt Blair and Edmund Kazmierczak for creating 'WordGram' which much of the code in this project
# is based off.
class User < ActiveRecord::Base
  require_relative "the_age.rb"
  require_relative "herald_sun.rb"
  require_relative "nyt.rb"
  require_relative "abc.rb"
  require_relative "smh.rb"
  require_relative "sbs.rb"
  # Validations
  validates_presence_of :email, :first_name, :last_name, :username
    validates :email, format: { with: /(.+)@(.+).[a-z]{2,4}/, message: "%{value} is not a valid email" }
    validates :username, length: { minimum: 3 }
  validates_presence_of :start_date, :end_date, message: "is not of correct format or is not present"
  validates :password, format: { with: /[\S]{8,}/, message: "must be at least eight non-whitespace characters" }

  # Users can have interests
  acts_as_taggable_on :interests


  #,useing secure password
  has_secure_password

  has_many :emails


  # Find a user by email, then check the username is the same
  def self.authenticate password, email
    user = User.find_by(email: email)
    if user && user.authenticate(password)
      return user
    else
      return nil
    end
  end

  # Return users name
  def full_name
    first_name + ' ' + last_name
  end

  # Scrapes through a set of news sites to make Article objects
  def scrape_articles
    age_import=AgeImporter.new(self.start_date,self.end_date)
    age_import.scrape_article
    sun_import=SunImporter.new(self.start_date,self.end_date)
    sun_import.scrape_article
    nyt_import=NytImporter.new(self.start_date,self.end_date)
    nyt_import.scrape_article



    abc_import=AbcImporter.new(self.start_date,self.end_date)
    abc_import.scrape_article

    smh_import=SmhImporter.new(self.start_date,self.end_date)
    smh_import.scrape_article

    sbs_import=SbsImporter.new(self.start_date,self.end_date)
    sbs_import.scrape_article
  end
  #selects the artciles to send
  def articles_to_email
    emailed = self.emails.map{|email| email.article_id}
    interests = Article.tagged_with(self.interest_list, :any => true).to_a
    to_email = []
    interests.each do |article|
      if (not emailed.include? article.id) && to_email.length <= 10
        to_email << article
      end
    end
    return to_email
  end
end
