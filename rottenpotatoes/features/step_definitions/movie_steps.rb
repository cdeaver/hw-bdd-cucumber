# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split do |string|
    step %Q{I #{uncheck}check "ratings_#{string}"}
  end
end

Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  group = Movie.all
  group.each do |movie|
    step %Q{I should see "#{movie.title}"}
  end
  
end

Then /I should (not )?see the following movies: (.*)/ do |uncheck, rating_list|
  rating_list.split(", ")  do |string|
    step %Q{I should #{uncheck}see "#{string}"}
  end
end

Then /I should see "(.*)" before "(.*)"/ do |string, string2|
  regexp = /#{string}.*#{string2}/m
  expect(page.body).to match(regexp)
end
