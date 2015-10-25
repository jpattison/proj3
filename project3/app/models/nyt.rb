# The_Digest Created by Jeremy Pattison jpattison@student.unimelb.edu.au 637841 on 20 sep 2015
# Credit goes to Matt Blair and Edmund Kazmierczak for creating 'WordGram' which much of the code in this project
# is based off.




require 'date'
require_relative 'article.rb'
require_relative 'importer.rb'
require 'open-uri'
require 'json'
require 'net/http'


class NytImporter < Importer
  # This file downloads RSS feed from 'New York Times'
  # and exports policical news from dates set by current user

  # Call super in the initialize method
  def initialize start_date, end_date
    super
  end

  # Return the source name.
  def self.source_name
    "New_York_Times"
  end


  # Creates new Article object and scrapes site to fill object in
  def scrape_article

    url='http://api.nytimes.com'
    request_url="/svc/search/v2/articlesearch.json?q=australia&api-key=\
5571df3ed216f61a77ae2492a353c460%3A15%3A72745686"

    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    #if api is using https set true
    http.use_ssl=false
    response = http.send_request('GET',request_url) #send request

    forecast = JSON.parse(response.body)

    #Copy down relevent attributes for each article

    forecast["response"]["docs"].each do |val|
      temp_article=Article.new

      if (val.has_key?("byline"))
        if (val["byline"]==nil||val["byline"].empty?)
          temp_article.author=nil

        else
          temp_article.author=val["byline"]["original"]

        end
      else
        temp_article.author=nil


      end

      if(val["headline"]==nil||val["headline"]["print_headline"]==nil)
        temp_article.title=nil
      else
        temp_article.title=val["headline"]["print_headline"]
      end

      if(val["abstract"]==nil)
        temp_article.summary = nil
      else
        temp_article.summary = val["abstract"]
      end



      if val["multimedia"].any?

        temp_article.images=val["multimedia"][0]["url"]
      else

        temp_article.images=nil
      end

      temp_article.source=NytImporter.source_name

      if(val["web_url"]==nil)
        temp_article.link = nil
      else
        temp_article.link = val["web_url"]
      end

      if(val["pub_date"]==nil)
        return
        temp_article.date = Date.today
      else
        temp_article.date=Date.parse(val["pub_date"])
      end





      #Create new article


      if(temp_article.date <= @end && temp_article.date>=@start && is_unique(temp_article))
        #if article is with the start and end date insert into array and is unique

        temp_article.save
      end

    end


  end



end

