# @author Chris Loftus
# @author Daniel Thompson 

require 'rest-client'
require 'json'
require 'base64'
require 'io/console'
class CSARestClient

  @@DOMAIN = 'http://localhost:3000'

  def check_login
    #asks the user for their credentials
    print "Login: "
    @login = STDIN.gets.chomp
    print "Password: "
    @password = STDIN.noecho(&:gets).chomp

    #if either of the inputs are empty if starts the process again
    if(@login.empty? || @password.empty?)
      puts "username or password cannot be blank"
      return false
    else
	#makes a post request to the session api controller with the provided credentials
        response = RestClient.post "#{@@DOMAIN}/api/session.json",
                                 {
                                   login: @login,
                                   password: @password,
                                }
	if(response.body == "true")
	  return true
	else
	  return false
	end
    end
  end

  def run_menu
    #calls the check login function in a loop, until a correct login has been entered
    loop do
      if(check_login)
        break
      else
        puts "username or password incorrect"	      
      end
    end

    #loops through displaying the menu and checking the input from the user
    loop do
      display_menu
      option = STDIN.gets.chomp.upcase
      case option
        when '1'
          puts 'List Existing Threads:'
          display_posts
        when '2'
          puts 'List Single Thread:'
          display_post
        when '3'
          puts 'Create New Thread:'
          create_post
        when 'Q'
          break
        else
          puts "Option #{option} is unknown."
      end
    end
  end

  private

  #function which outputs the menu to the console
  def display_menu
    puts "\nEnter option: "
    puts '1. List Existing Threads'
    puts '2. List Single Thread'
    puts '3. Create new Thread'
    puts 'Q. Quit'
  end

  #displays all the posts
  def display_posts
    begin
      response = RestClient.get "#{@@DOMAIN}/api/posts.json?all", authorization_hash

      puts "Response code: #{response.code}"
      puts "Response cookies:\n #{response.cookies}\n\n"
      puts "Response headers:\n #{response.headers}\n\n"
      puts "Response content:\n #{response.to_str}"

      js = JSON response.body
      js.each do |item_hash|
        item_hash.each do |k, v|
          puts "#{k}: #{v}"
        end
      end
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}"
    end
  end

  #displays a single post
  def display_post
    begin
      # asks the user for the post id
      print "Enter the post ID: "
      id = STDIN.gets.chomp
      response = RestClient.get "#{@@DOMAIN}/api/posts/#{id}.json", authorization_hash

      js = JSON response.body
      js.each do |k, v|
        puts "#{k}: #{v}"
      end
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}"
    end
  end

  #creates a new post
  def create_post
    begin
      #asks the user for the title, body, and whether it should be anonymous
      print "Title: "
      title = STDIN.gets.chomp
      print "Body: "
      body = STDIN.gets.chomp
      print "Post as Anonymous? (y/n): "
      anonymous = STDIN.gets.chomp.upcase == 'Y' ? true : false
      # check user information from login

      # Rails will reject this unless you configure the cross_forgery_request check to
      # a null_session in the receiving controller. This is because we are not sending
      # an authenticity token. Rails by default will only send the token with forms /users/new and
      # /users/1/edit and REST clients don't get those.
      # We could perhaps arrange to send this on a previous
      # request but we would then have to have an initial call (a kind of login perhaps).
      # This will automatically send as a multi-part request because we are adding a
      # File object.
      response = RestClient.post "#{@@DOMAIN}/api/posts.json",

                                 {
                                     post: {
                                         title: title,
                                         body: body,
                                         anonymous: anonymous
                                     },
                                 }, authorization_hash

      if (response.code == 201)
        puts "Created successfully"
      end
      puts "URL for new resource: #{response.headers[:location]}"
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}"
    end
  end

  #this is the authorisation hash which is passed along with most requests
  def authorization_hash
    {Authorization: "Basic #{Base64.strict_encode64("#{@login}:#{@password}")}"}
  end


end

client = CSARestClient.new
client.run_menu
