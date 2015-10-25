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
    age_import=AgeImporter.new(Date.today(),Date.today()-14)
    age_import.scrape_article
    sun_import=SunImporter.new(Date.today(),Date.today()-14)
    sun_import.scrape_article
    nyt_import=NytImporter.new(Date.today(),Date.today()-14)
    nyt_import.scrape_article



    abc_import=AbcImporter.new(Date.today(),Date.today()-14)
    abc_import.scrape_article

    smh_import=SmhImporter.new(Date.today(),Date.today()-14)
    smh_import.scrape_article

    sbs_import=SbsImporter.new(Date.today(),Date.today()-14)
    sbs_import.scrape_article

    tag_article()
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

  def tag_article
    # tags the article with the source name as well as proper nouns in the summary
    Article.tagged_with(ActsAsTaggableOn::Tag.all.map(&:to_s), :exclude => true).each do |temp_article|

      # adds the source as a tag if present
      if temp_article.source.present?
        temp_article.tag_list.add(temp_article.source)
      end

      # Tag proper nouns in the summary
      if temp_article.summary.present?
        temp_article.summary.split(" ").each do |word|
          if((word.match /[A-Z][a-z]*/).to_s.length>1)
            temp_article.tag_list.add(word)

          end
        end
      end

      # Tag author
      if temp_article.author.present?
        temp_article.tag_list.add(temp_article.author)
      end

      # Tag words in title
      if temp_article.title.present?
        temp_article.title.split(" ").each do |word|
          temp_article.tag_list.add(word)
        end
      end

      # Tag alchemy entities
      if temp_article.summary.present?
        AlchemyAPI.key = "2542e026f603445ce9ca6460e8b3fd03bf785848"
        a_concepts = AlchemyAPI::ConceptTagging.new.search(text: temp_article.summary)
        a_concepts.each { |c| temp_article.tag_list.add(c['text'])}
      end
    end
  end
end
