Given(/^that user "([^"]*)" with password "([^"]*)" has logged in$/) do |arg1, arg2|
	  visit '/session/new'
	  fill_in 'login', :with => arg1 
	  fill_in 'password', :with => arg2
	  click_button " Login "
          page.assert_text("Logged in successfully")
end

When(/^the user creates a new anonymous thread with the title "([^"]*)" with the body "([^"]*)"$/) do |arg1, arg2|
	  visit '/posts/new'
	  fill_in 'post_title', :with => arg1 
	  fill_in 'post_body', :with => arg2
	  check('anonymous')
	  click_button "Create Post"
end

Then(/^the current page should contain a new row containing the data:$/) do |expected_results|
  results = [['Title','Author','Unread posts', 'Total number posts']] +
  page.all('tr.data').map {|tr|
  	[ tr.find('.title').text,
          tr.find('.author').text,
          tr.find('.unread').text,
          tr.find('.total').text ]
  }
  expected_results.diff!(results)
end
