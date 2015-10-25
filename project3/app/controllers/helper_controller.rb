class HelperController < ApplicationController
  require 'mandrill'
  def format_message message_html, user
    #creates the message format for mandrill
    message = {  
     :subject=> "Article Digest",  
     :from_name=> "The Digest",  
     :text=>"",  
     :to=>[  
       {  
         :email=> user.email,  
         :name=> "Recipient1"  
       }  
     ],  
     :html=>message_html,  
     :from_email=>"sender@yourdomain.com"  
    }  
    return message
  end
  def create_message articles
    #creates a message if the articles is empty
    if articles.empty?
      message = "<html><p>No Articles matching your interests could be found</p></html>"
      return message
    end
    #creates a normal message if articles isnt empty
    message = "<html><h1>Article Digest</h1>"
    articles.each do |article|
      message +="\n<h2>"+article.title + "</h2>"
      message+="\n<h2>author</h2>\n<p>"+article.author + "</p>" if not article.author.nil?
      message+= "\n<h2>Summary</h2>\n<p>"+article.summary + "</p>" if not article.summary.nil?
      message+= "\n<h2>Images</h2>\n<p>"+article.images + "</p>" if not article.images.nil?
      message+= "\n<h2>Source</h2>\n<p>"+article.source + "</p>" if not article.source.nil?
      message+= "\n<h2>Date</h2>\n<p>"+article.date.to_s + "</p>" if not article.date.nil?
      message+= "\n<h2>Link</h2>\n<p>"+article.link + "</p>" if not article.link.nil?
    end
    message+="</html>"
    return message
  end
  def send_email user
    m = Mandrill::API.new 'Ce1GEUdL9HgIcxu0g-ezwA'
    #gives array of up to 10 articles to email
    to_email = user.articles_to_email
    #creates the html content for the message
    email_message = create_message to_email
    #formats message into a hash and adds user email as recipient
    formatted_email = format_message email_message ,user
    #sends the email to
    sent = m.messages.send formatted_email
    to_email.each do |e_article| 
      Email.create ({user: user, article: e_article}) 
    end
    return sent
  end
end