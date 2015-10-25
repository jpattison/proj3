# The_Digest Created by Jeremy Pattison jpattison@student.unimelb.edu.au 637841 on 20 sep 2015
# Credit goes to Matt Blair and Edmund Kazmierczak for creating 'WordGram' which much of the code in this project
# is based off.




require 'date'
require_relative 'article.rb'
require_relative 'importer.rb'
require 'open-uri'
require 'json'
require 'net/http'


class GuardianImporter < Importer
  # This file downloads RSS feed from 'New York Times'
  # and exports policical news from dates set by current user

  # Call super in the initialize method
  def initialize start_date, end_date
    super
  end

  # Return the source name.
  def self.source_name
    "The_Guardian"
  end


  # Creates new Article object and scrapes site to fill object in
  def scrape_article

    url='http://content.guardianapis.com'
    request_url="/search?api-key=csk6v67wq89u46j7u7tyrqhs&order-by=newest&q=Australia"

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    #if api is using https set true
    http.use_ssl=false
    response = http.send_request('GET',request_url) #send request

    forecast = JSON.parse(response.body)

    #Copy down relevent attributes for each article

    forecast["response"]["results"].each do |val|
      temp_article=Article.new


        temp_article.author=nil


      if(val["webTitle"]==nil)
        temp_article.title=nil
      else
        temp_article.title=val["webTitle"]
      end


        temp_article.summary = nil

        temp_article.images=nil


      temp_article.source=GuardianImporter.source_name

      if(val["webUrl"]==nil)
        temp_article.link = nil
      else
        temp_article.link = val["webUrl"]
      end

      if(val["webPublicationDate"]==nil)
        return
        temp_article.date = Date.today
      else
        temp_article.date=Date.parse(val["webPublicationDate"])
      end





      #Create new article


      if(temp_article.date <= @end && temp_article.date>=@start && is_unique(temp_article))
        #if article is with the start and end date insert into array and is unique

        temp_article.save
      end

    end


  end



end

