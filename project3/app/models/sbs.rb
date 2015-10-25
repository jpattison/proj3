# The_Digest Created by Jeremy Pattison jpattison@student.unimelb.edu.au 637841 on 20 sep 2015
# Credit goes to Matt Blair and Edmund Kazmierczak for creating 'WordGram' which much of the code in this project
# is based off.



require 'date'
require_relative 'article.rb'
require_relative 'importer.rb'
require 'rss'
require 'open-uri'
require 'time'


class SbsImporter < Importer
  # This file downloads RSS feed from 'SBS'
  # and exports policical news from last 7 days

  # Call super in the initialize method
  def initialize start_date, end_date
    super
  end

  #Return source Name
  def self.source_name
    "Special_Broadcaster_Company"
  end


  # Save canned article data
  def scrape_article

    url="http://sbs.feedsportal.com/c/34692/f/637303/index.rss"
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|
        temp_article=Article.new
        temp_article.author=item.author
        temp_article.title=item.title

        # input was in form of several paragraphs in html format
        # the code splits the paragraphs to arrays so only the relevent
        # text is displayed
        temp_article.summary=item.description.split('<')[0]
        temp_article.images=get_http(item.description)
        temp_article.source=SbsImporter.source_name
        temp_article.link=item.link
        temp_article.date=item.pubDate.to_date





        if(temp_article.date <= @end && temp_article.date>=@start && is_unique(temp_article))
          #if article is with the start and end date insert into array and is unique

          temp_article.save


        end

      end




    end
  end


end


