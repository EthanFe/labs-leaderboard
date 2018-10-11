
require 'open-uri'

class UsersController < ApplicationController
  def index

    email = ENV['LEARN_LOGIN_EMAIL']
    password = ENV['LEARN_LOGIN_PASSWORD']

    # Create a new mechanize object
    agent = Mechanize.new

    # Load the postmarkapp website
    page = agent.get("https://learn.co")

    # Select the first form
    form = agent.page.forms.first
    form.field_with(:name => "user[email]").value = email
    form.field_with(:name => "user[password]").value = password

    # Submit the form
    page = form.submit form.buttons.first

    users = [
      "kapham2",
      "Richardojo86",
      "nickluong",
      "gwatson86",
      "spraguesy",
      "HeadyT0pper",
      "V10LET",
      "mwilliamszoe",
      "NaebIis",
      "sparkbold-git",
      "chelsme",
      "EthanFe",
      "morgvanny",
      "jordantredaniel"
    ]

    @emoji_list = {
      "kapham2": "doge",
      "Richardojo86": "hotpocket",
      "gwatson": "panda_face",
      "nickluong": "crying_frog",
      "chelsme": "lasagnacat",
      "EthanFe": "monkey_face",
      "V10LET": "christmas_tree",
      "HeadyT0pper": "table_tennis_paddle_and_ball",
      "NaebIis": "cat",
      "mwilliamszoe": "fries",
      "sparkbold-git": "metro",
      "spraguesy": "the_plague",
      "jordantredaniel": "jordan",
      "morgvanny": "morgan-freeman",
    }

    base_url = "https://learn.co/"

    @users = []
    users.each do |user|
      labs = get_labs_completed_for_user(agent, user, base_url).to_i
      @users << {name: user, labs_completed: labs}
    end
    @users = @users.sort_by do |user|
      user[:labs_completed]
    end
    @max_labs_completed = @users.last[:labs_completed]
    @users_json = @users.to_json
  end

  def get_labs_completed_for_user(agent, user, base_url)
    profile_url = base_url + user
    doc = agent.get(profile_url)
    labs = doc.css("div.col--size-1of4 > span.heading").text
  end
end