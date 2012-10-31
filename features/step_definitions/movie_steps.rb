# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  	Movie.create( movie ) if not Movie.find_by_title( movie[:title] )
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  if page.respond_to? :should
    page.should have_text(/#{e1}.*#{e2}/m)
  else
    assert /#{e1}.*#{e2}/m.match( page.text )
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"
Then /I should see the following movies: (.*)/ do |movies_list|
  movies_list.split(',').each do |movie|
    assert page.has_content?(movie.strip.gsub(/^\"|\"?$/, ''))
  end
end

Then /I should see (\d+) movie(?:s)?/ do |movie_count|
  assert page.all('#movies tbody tr').count == movie_count.to_i
end

Then /^the director of "(.*)" should be "(.*)"$/i do |title, director|
  assert Movie.find_by_title(title).director.downcase == director.downcase
end

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
	rating_list.split(',').each do |rating|
		check "ratings_#{rating.delete(' ')}" unless uncheck
		uncheck "ratings_#{rating.delete(' ')}" if uncheck
	end
end


When /I (un)?check all ratings/ do |uncheck|
	rating_list = %w(G PG PG-13 NC-17 R)
	rating_list.each do |rating|
		check "ratings_#{rating.strip}" unless uncheck
		uncheck "ratings_#{rating.strip}" if uncheck
	end
end
