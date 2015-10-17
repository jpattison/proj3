# The_Digest Created by Jeremy Pattison jpattison@student.unimelb.edu.au 637841 on 20 sep 2015
# Credit goes to Matt Blair and Edmund Kazmierczak for creating 'WordGram' which much of the code in this project
# is based off.


require 'date'
require_relative 'article.rb'
require_relative 'importer.rb'
require 'rss'
require 'open-uri'
require 'time'


class AgeImporter < Importer
  # This file downloads RSS feed from 'The Age'
  # and exports policical news from dates set by current user

  # Call super in the initialize method
  def initialize start_date, end_date
    super
  end

  # Return the source name.
  def self.source_name
    "The_Age"
  end


  # Creates new Article object and scrapes site to fill object in
  def scrape_article

    url='http://www.theage.com.au/rssheadlines/political-news/article/rss.xml'
    puts url
    open(url) do |rss|

      feed = RSS::Parser.parse(rss)

      #For each article gather the relevent information and put it in the article
      feed.items.each do |item|

        temp_article=Article.new
        temp_article.author=item.author
        temp_article.title=item.title
        # input was in form of several paragraphs in html format
        # the code splits the paragraphs to arrays so only the relevent
        # text is displayed
        temp_article.summary = item.description.split('</p>')[1]
        temp_article.images=get_http(item.description.split('</p>')[0].split('><')[1])

        temp_article.source=AgeImporter.source_name
        temp_article.link=item.link
        temp_article.date=item.pubDate.to_date



        if(temp_article.date <= @end && temp_article.date>=@start && is_unique(temp_article))
          # if article is with the start and end date insert into array and is unique
          tag_article(temp_article)
          temp_article.save


        end

      end




    end
  end


end

