# @author Chris Loftus
# @author Daniel Thompson 

require 'rest-client'
require 'json'
require 'base64'
require 'io/console'
class CSARestClient

  @@DOMAIN = 'http://localhost:3000'

  def check_login
    print "Login: "
    login = STDIN.gets.chomp
    print "Password: "
    password = STDIN.noecho(&:gets).chomp

  end

  def run_menu
    loop do
      if(check_login)
        break
      end
    end

    loop do
      display_menu
      option = STDIN.gets.chomp.upcase
      case option
        when '1'
          puts 'List Existing Threads:'
          display_users
        when '2'
          puts 'List Single Thread:'
          display_user
        when '3'
          puts 'Create New Thread:'
          create_user
        when '4'
          puts 'Delete Thread:'
          delete_user
        when 'Q'
          break
        else
          puts "Option #{option} is unknown."
      end
    end
  end

  private

  def display_menu
    puts 'Enter option: '
    puts '1. List Existing Threads'
    puts '2. List Single Thread'
    puts '3. Create new Thread'
    puts '4. Delete Thread'
    puts 'Q. Quit'
  end

  def display_users
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

  def display_user
    begin
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

  def create_user
    begin
      print "Title: "
      title = STDIN.gets.chomp
      print "Body: "
      body = STDIN.gets.chomp
      print "Post as Anonymous? (y/n): "
      anonymous = STDIN.gets.chomp.upcase == 'Y' ? true : false
      print "User ID: "
      user_id = STDIN.gets.chomp
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
                                         anonymous: anonymous,
                                         user_id: user_id,
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

  def delete_user
    begin
      print "Enter the post ID: "
      id = STDIN.gets.chomp
      response = RestClient.delete "#{@@DOMAIN}/api/posts/#{id}.json", authorization_hash

      if (response.code == 204)
        puts "Deleted successfully"
      end
    rescue => e
      puts STDERR, "Error accessing REST service. Error: #{e}\n"
    end
  end

  def authorization_hash
    {Authorization: "Basic #{Base64.strict_encode64('admin:taliesin')}"}
  end


end

client = CSARestClient.new
client.run_menu
