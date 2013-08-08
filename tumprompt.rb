require 'tumblr_client'
Tumblr.configure do |config|
  config.consumer_key = "1Juytw0l16Op1GODcv13lK9B0ySwVQom63lr9EsS246oIoYFM4"
  config.consumer_secret = "plo1wb96DeIHtUXm7FE6ZnB5cgX5jDmKSDtYxntSsbzMVvOcz1"
  config.oauth_token = "UNHfxvjiHbdPjIK548xhKCaDnC8Wlre4zWDqZKXyMrmtewygHf"
  config.oauth_token_secret = "yCu1HWfnpUI80wnnwowB09SQcu2xAjG11chSiyXYe2bRQek085"
end

class TumPrompt
  attr_accessor :User, :Input
  Client = Tumblr::Client.new(:client => :httpclient)

  def run
    puts "Welcome to TumPrompt, the command prompt for Tumblr geeks. This is a work in progress."
    @@input = ""
    print "Enter User: "
    while
      @@user = gets.chomp.downcase
      if @@user.include?(".tumblr.com") == false
        puts "---------------------------------"
        puts "Woah, Not A Valid URL. Try Again."
        puts "example: something.tumblr.com"
        print "Enter User:"
      elsif @@user.include?(".tumblr.com") == true
        break
      end
    end
    while @@input != "quit"
      puts "---------------------------------"
      puts "Commands Avaiable are: Text, Photo, Chat, Audio, Video, Link and Quote Post"
      print "Enter Command: "
      @@input = gets.chomp.downcase
      case @@input
      when "info" then puts Client.dashboard{0}
      when "posts" then posts
      when "quit" then puts "Goodbye" 
      when "text post" then text_post
      when "photo post" then photo_post
      when "chat post" then chat_post
      when "audio post" then audio_post
      when "video post" then video_post
      when "link post" then link_post
      when "quote post" then quote_post
      else 
        error_message
      end
    end
  end

  def text_post
    print "Creating a Text Post. Do you want a title? (Yes/No) "
    answer = gets.chomp.downcase
    if answer == "no"
      print "Enter The Body: "
      body_without_title = gets.chomp.downcase
      puts "Publishing This Post..."
      Client.text("#{@@user}", {:body => "#{body_without_title}"})
    elsif answer == "yes"
      print "Enter The Title: "
      title = gets.chomp
      print "Enter The Body: "
      body = gets.chomp
      puts "Publishing This Post..."
      Client.text("#{@@user}", {:title => "#{title}", :body => "#{body}"})
    end
  end
  
  def photo_post
    print "Creating a Photo Post. Is This Photo From a File or a Url? (File/Url) "
    answer = gets.chomp.downcase
    if answer == "file"
      print "Where is the file located? "
      file_location = gets.chomp.downcase
      print "Does the photo have a caption? "
      caption_answer = gets.chomp.downcase
      if caption_answer == "yes"
        print "What is the caption? "
        caption = gets.chomp
        puts "Publishing This Post..."
        Client.photo("#{@@user}", {:caption => "#{caption}", :data => ["#{file_location}"]})
      elsif caption_answer == "no"
        puts "Publishing This Post..."
        Client.photo("#{@@user}", {:data => ["#{file_location}"]})
      end
    elsif answer == "url"
      print "What is the URL? "
      url = gets.chomp.downcase
      print "Does the photo have a caption "
      caption_answer = gets.chomp.downcase
      if caption_answer == "yes"
        print "What is the caption? "
        caption = gets.chomp
        puts "Publishing This Post..."
        Client.photo("#{@@user}", {:caption => "#{caption}", :source => "#{url}"})
      elsif caption_answer == "no"
        puts "Publishing This Post..."
        Client.photo("#{@@user}", {:source => "#{url}"})
      end
    end
  end
  
  def chat_post
    puts "Under Construction"
    print "Creating a Chat Post. Do You Want To Title This Chat? "
    answer = gets.chomp.downcase
    if answer == "yes"
      print "Enter Title "
      chat_title = gets.chomp
      print "What is the conversation? "
      chat_conversation = ""
      print "What Did Person A Say? "
      chat_conversationA = gets.chomp
      print "What Did Person B Say? "
      chat_conversationB = gets.chomp
      Client.chat("#{@@user}", {:title => "#{chat_title}", :conversation => "#{chat_conversationA} \n #{chat_conversationB}" })
    elsif answer == "no"
      print "What is the conversation? "
      chat_conversation = ""
      print "What Did Person A Say? "
      chat_conversationA = gets.chomp
      print "What Did Person B Say? "
      chat_conversationB = gets.chomp
      Client.chat("#{@@user}", {:conversation => "#{chat_conversationA} \n #{chat_conversationB}"})
    end

  end

  def audio_post
    puts "Under Construction"
    print "Please Choose File Type (File/Url) "
    answer = gets.chomp.downcase
    if answer == "file"
      print "Where is the file located? "
      file_location = gets.chomp.downcase
      print "Does the audio post have a caption? "
      caption_answer = gets.chomp.downcase
      if caption_answer == "yes"
        print "What is the caption? "
        caption = gets.chomp
        puts "Publishing This Post..."
        Client.audio("#{@@user}", {:caption => "#{caption}", :data => ["#{file_location}"]})
      elsif caption_answer == "no"
        puts "Publishing This Post..."
        Client.audio("#{@@user}", {:data => ["#{file_location}"]})
      end
    elsif answer == "url"
      print "What is the URL? "
      url = gets.chomp.downcase
      print "Does this audio post have a caption? "
      caption_answer = gets.chomp.downcase
      if caption_answer == "yes"
        print "What is the caption? "
        caption = gets.chomp
        puts "Publishing This Post..."
        Client.audio("#{@@user}", {:caption => "#{caption}", :external_url => "#{url}"})
      elsif answer == "no"
        puts "Publishing This Post..."
        Client.audio("#{@@user}", {:external_url => "#{url}"})
      end
    end
  end

  def video_post
    print "Please Choose File Type (File/Url) "
    answer = gets.chomp.downcase
    if answer == "file"
      print "Where is the file located? "
      file_location = gets.chomp.downcase
      print "Does the video have a caption? "
      caption_answer = gets.chomp.downcase
      if caption_answer == "yes"
        print "What is the caption? "
        caption = gets.chomp
        puts "Publishing This Post..."
        Client.video("#{@@user}", {:caption => "#{caption}", :data => ["#{file_location}"]})
      elsif caption_answer == "no"
        puts "Publishing This Post..."
        Client.video("#{@@user}", {:data => ["#{file_location}"]})
      end
    elsif answer == "url"
      print "What is the URL? "
      url = gets.chomp.downcase
      print "Does this video have a caption? "
      caption_answer = gets.chomp.downcase
      if caption_answer == "yes"
        print "What is the caption? "
        caption = gets.chomp
        puts "Publishing This Post..."
        Client.video("#{@@user}", {:caption => "#{caption}", :embed => "#{url}"})
      elsif answer == "no"
        puts "Publishing This Post..."
        Client.video("#{@@user}", {:embed => "#{url}"})
      end
    end
  end

  def link_post
    print "Creating a Link Post. Do You Want a Title? (Yes/No) "
    answer = gets.chomp.downcase
    if answer == "yes"
      print "What is the title? "
      link_title = gets.chomp
      print "What is the URL? "
      the_url = gets.chomp.downcase
      puts "Publishing This Post..."
      Client.link("#{@@user}", {:title => "#{link_title}", :url => "#{the_url}"})
    elsif answer == "no"
      print "What is the URL? "
      the_url = gets.chomp.downcase
      puts "Publishing This Post..."
      Client.link("#{@@user}", {:url => "#{the_url}"})
    end
  end

  def quote_post
    print "Creating a Quote. Does this have a source?(Yes/No) "
    answer = gets.chomp.downcase
    if answer == "no"
      print "Enter The Body: "
      body_without_source = gets.chomp.downcase
      puts "Publishing This Post..."
      Client.quote("#{@@user}", {:quote => "#{body_without_source}"})
    elsif answer == "yes"
      print "Enter The Source: "
      source = gets.chomp.downcase
      print "Enter The Body: "
      body = gets.chomp.downcase
      puts "Publishing This Post..."
      Client.quote("#{@@user}", {:source => "#{source}", :quote => "#{body}"})
    end
  end

  def posts
    print "What Blog Post Do You Want To Find? "
    print "Enter URL: "
    blog_find_by_url = gets.chomp.downcase
    puts "Processing"
    Client.posts("#{blog_find_by_url}")
  end

  def error_message
    error_number = rand(8) + 1 
    if error_number == 1
      puts "YOU SO CLASSY"
    elsif error_number == 2
      puts "You Gettin Reckless With That Command"
    elsif error_number == 3
      puts "ME, SARCASTIC? NEVER"
    elsif error_number == 4
      puts "#{@@user} is irrelanvent, so is that command"
    elsif error_number == 5
      puts "UM I WROTE A LIST OF COMMANDS FOR A REASON"
    elsif error_number == 6
      puts "#{@@user} IS SUCH A PEASANT"
    elsif error_number == 7
      puts "STOP HOARDING THOSE URLs"
    elsif error_number == 8
      puts "LOL, #{@@user} THINKS THEY ARE TUMBLR FAMOUS"
    end
  end
end
tumblrprompt = TumPrompt.new
tumblrprompt.run

# DEMO PHOTO URL

# Grabbing a specific blogs posts
#  client.posts("codingjester.tumblr.com")

# Grabbing only the last 10 photos off the blog
# client.posts("codingjester.tumblr.com", :type => "photo", :limit => 10)

# Uploads a great photoset
# client.photo("codingjester.tumblr.com", {:data => ['/path/to/pic.jpg', '/path/to/pic.jpg']})
