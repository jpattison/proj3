# The_Digest Created by Jeremy Pattison jpattison@student.unimelb.edu.au 637841 on 20 sep 2015
# Credit goes to Matt Blair and Edmund Kazmierczak for creating 'WordGram' which much of the code in this project
# is based off.


require_relative 'article.rb'
class Importer
  # Provides parent class for all importers for individual websites

  # A news scrape is initialised with the start and end date, it
  # then validates that the required methods are provided
  def initialize start_date, end_date
    @start = start_date
    @end = end_date

    validate_subclasses
  end

  def is_unique new_article
    # Checks if the article is unique

    if Article.where(:title => new_article.title).blank?
      return true
    end
    return false
  end

  private
  # Method to valid subclass implements the required methods

  def validate_subclasses
    # Validate instance methods
    if not(self.respond_to?(:scrape_article))
      throw Exception.new("subclass fails to implement the required scrape method")
    end

    # Validate class methods
    if not(self.class.respond_to?(:source_name))
      throw Exception.new("subclass fails to provide source_name")
    end

  end

  def tag_article temp_article
    # tags the article with the source name as well as proper nouns in the summary

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


  end

  # Returns http addresses from a string
  def get_http string
    images =[]
    string.split('"').each do |word|
      if((word.match /[h][t][t][p][a-z]*/).to_s.length>1)
        images.insert(-1,word)
      end
    end
    return images.to_sentence
  end
end
