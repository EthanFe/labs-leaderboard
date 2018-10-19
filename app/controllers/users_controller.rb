
require 'open-uri'

class UsersController < ApplicationController
	skip_before_action :verify_authenticity_token
  def index
    
  end

  def get_labs_completed_for_user(agent, user, base_url)
    profile_url = base_url + user
    doc = agent.get(profile_url)
    labs = doc.css("div.col--size-1of4 > span.heading").text
  end

  def get_user_data
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

    base_url = "https://learn.co/"

    labs = get_labs_completed_for_user(agent, params[:name], base_url).to_i
    render json: {name: params[:name], labs: labs}
  end

  def save_data
    snapshot = Snapshot.create
    params[:users].each do |username, labs|
      user = User.find_or_create_by(name: username)
      user_snapshot = snapshot.user_snapshots.create(user_id: user.id, labs: labs)
    end
  end
end