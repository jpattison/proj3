# The_Digest Created by Jeremy Pattison jpattison@student.unimelb.edu.au 637841 on 20 sep 2015
# Credit goes to Matt Blair and Edmund Kazmierczak for creating 'WordGram' which much of the code in this project
# is based off.


require 'date'
require_relative 'article.rb'
require_relative 'importer.rb'
require 'rss'
require 'open-uri'
require 'time'


class SunImporter < Importer

  # By  Jeremy Pattison 637841
  # This file downloads RSS feed from 'The Herald Sun'
  # and exports policical news from dates set by current user


  # Call super in the initialize method
  def initialize start_date, end_date
    super
  end

  #Return source Name
  def self.source_name
    "Herald_Sun"
  end


  # Creates new Article object and scrapes site to fill object in
  def scrape_article

    url="http://feeds.news.com.au/heraldsun/rss/heraldsun_news_an\
drewbolt_2782.xml"
    open(url) do |rss|
        feed = RSS::Parser.parse(rss)
        feed.items.each do |item|
          temp_article=Article.new
          temp_article.author=item.author
          temp_article.title=item.title

          # note had to reformat description to represent article properly
          temp_article.summary = item.description.gsub!("&#8217;","'")
          temp_article.images=get_http(item.enclosure.to_s.gsub!("\n",''))
          temp_article.source=SunImporter.source_name
          temp_article.link=item.link
          temp_article.date=item.pubDate.to_date





          if(temp_article.date <= @end && temp_article.date>=@start && is_unique(temp_article))
            #if article is with the start and end date and unique insert into array
            tag_article(temp_article) # tag article
            temp_article.save


          end

        end




      end
    end


  end


