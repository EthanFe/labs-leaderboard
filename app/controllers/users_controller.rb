
require 'open-uri'

class UsersController < ApplicationController
  def index
    users = [
      "kapham2",
      "Richardojo86",
      "nickluong",
      "gwatson86",
      "spraguesy",
      "HeadyT0pper",
      "V10LET",
      "mwilliamszoe",
      "Naeblis",
      "sparkbold-git",
      "chelme",
      "EthanFe"
    ]

    base_url = "https://learn.co/"

    @users = []
    users.each do |user|
      labs = get_labs_completed_for_user(user)
      @users << {name: user, labs_completed: labs}
    end
    @users = @users.sort_by do |user|
      user[:labs_completed]
    end.reverse
    @users_json = @users.to_json
  end

  def get_labs_completed_for_user(user)
    # profile_url = base_url + user
    # html = open(profile_url)
    # doc = Nokogiri::HTML(html)
    # something = doc.css("section.site-main div div div div div div div")
    # # something = doc.xpath('//span[contains(@class, "heading") and contains(@class, "heading--level-1")]')
    # # heading heading--level-1 heading--color-green heading--font-size-largest heading--weight-lighter
    # binding.pry
    rand(20)
  end
end
