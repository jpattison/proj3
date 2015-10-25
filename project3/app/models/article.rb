# The_Digest Created by Jeremy Pattison jpattison@student.unimelb.edu.au 637841 on 20 sep 2015
# Credit goes to Matt Blair and Edmund Kazmierczak for creating 'WordGram' which much of the code in this project
# is based off.

class Article < ActiveRecord::Base

  acts_as_taggable
  def self.search(search)
    if search
      keywords=search.split(' ')
      answer=[]
      score_array = []
      hash_answer= []
      Article.find_each do |article|
        # assumption made for one match per keyword per attribute. Ie if searching description for cats and description is "Cats cats cats cats" then only count once
        # assuming more points for differnt keyword match
        temp_hash={}
        score = 0
        keywords.each do |keyword|

          unless (article.tag_list.nil? or !article.tag_list.include? keyword.downcase)
            score=score + 4.0
          end

          #unless (article.title.nil? or !article.title.downcase.include? keyword.downcase)
          unless (article.title.nil? or !article.title.match(/#{keyword}/i))
            score=score + 3.0
          end

          unless (article.summary.nil? or !article.summary.match(/#{keyword}/i))
            score=score + 2.0
          end

          unless (article.source.nil? or !article.source.match(/#{keyword}/i))
            score=score + 1.0
          end



        end
        if (score>0)
          #answer.insert(-1,article)
          score_array.insert(-1,score)
          temp_hash["article"]=article
          temp_hash["score"]=score
          temp_hash["date"]=article.date
          hash_answer.insert(-1,temp_hash)

        end

      end
      temp_answer=hash_answer.sort { |a, b| [a["score"], a["date"]] <=> [b["score"], b["date"]]}
      temp_answer.each { |key| answer.insert(0,key["article"])}
#        if(a1[1]>a2[1])
#         return -1
#       end
#       if(a1[1]<a2[1])
#         return 1
#       end
#
#       return 0
#     end
#     hash_answer.each do |key|
#       answer.insert(-1,key[0])
#     end

      return answer
    else
      Article.order(:date).reverse_order
    end
  end

end
