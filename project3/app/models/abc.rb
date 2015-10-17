# The_Digest Created by Jeremy Pattison jpattison@student.unimelb.edu.au 637841 on 20 sep 2015
# Credit goes to Matt Blair and Edmund Kazmierczak for creating 'WordGram' which much of the code in this project
# is based off.




require 'date'
require_relative 'article.rb' # Dont think need this line
require_relative 'importer.rb'
require 'rss'
require 'open-uri'
require 'time'


class AbcImporter < Importer
  # This file downloads RSS feed from 'ABC'
  # and exports policical news from dates set by current user

  # Call super in the initialize method
  def initialize start_date, end_date
    super
  end

  #Return source Name
  def self.source_name
    "Australian_Broadcaster_Company"
  end


  # Creates new Article object and scrapes site to fill object in
  def scrape_article
    url="http://www.abc.net.au/radionational/feed/3777540/rss.xml"
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|
        temp_article=Article.new
        temp_article.author=item.author
        temp_article.title=item.title
        temp_article.summary = item.description
        temp_article.images=nil #note no image provided on this RSS field
        temp_article.source=AbcImporter.source_name
        temp_article.link=item.link
        temp_article.date=item.pubDate.to_date





        if(temp_article.date <= @end && temp_article.date>=@start && is_unique(temp_article))
          #if article is with the start and end date insert into array and is unique
          tag_article(temp_article) # tag article
          temp_article.save


        end

      end




    end
  end


end


