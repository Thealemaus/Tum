class Post

  def initialize(type)
    @type = type
  end

  def createPost
    case type
    when "Photo"
      photoPost()
    when "text"
      puts "Your name begins with Q, R or Z, you're not welcome here!"
    else
      puts "Welcome stranger!"
    end
  end

end