
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
    last_snapshot = (Snapshot.all.sort_by { |snapshot| snapshot.created_at}).last
    
    snapshot = Snapshot.create
    params[:users].each do |username, labs|
      user = User.find_or_create_by(name: username)
      user_snapshot = snapshot.user_snapshots.create(user_id: user.id, labs: labs)
    end

    Snapshot.check_duplicate_snapshot(last_snapshot, snapshot)
  end

  def get_data
    render json: User.get_data_per_day
  end

  def test_get_full_history_data

    events = []
    events_fetched = 0
    # user_id = "369995"
    user_id = params[:id]
    finished_fetching = false
    while (!finished_fetching)
      json = fetch_data(user_id, events_fetched)
      events.concat(json["events"])
      finished_fetching = json["includes_final_event"]
      events_fetched = events.length
    end
    
    render json: events
    

    # labs = test_get_labs_completed_for_user(agent, params[:name], base_url).to_i
    # render json: {name: params[:name], labs: labs}
  end

  def fetch_data(user_id, events_fetched)
    api_response = RestClient.get("https://learn.co/api/v1/student_profile/timeline?user_id=#{user_id}&offset=#{events_fetched}", headers={
      "Accept": "application/json",
      "Accept-Encoding": "gzip, deflate, br",
      "Accept-Language": "en-US,en;q=0.9",
      "Connection": "keep-alive",
      "Content-Type": "application/json",
      "Cookie": "ajs_group_id=null; ajs_anonymous_id=%2293bda9cb-3471-4065-8655-3f2e27173799%22; _ga=GA1.2.348582742.1534294089; hubspotutk=0e8a6c5dec1e1b0ef0247b5682b50c29; intercom-id-j4d6dyie=89e20200-0858-4123-bdaa-a7f1b63f3491; ajs_user_id=%222de37786-dada-4343-b5ec-91f1d5c6d2d7%22; intercom-lou-j4d6dyie=1; mp_fa5e54be62f97438f0487c9b7064feb2_mixpanel=%7B%22distinct_id%22%3A%20%222de37786-dada-4343-b5ec-91f1d5c6d2d7%22%2C%22mp_lib%22%3A%20%22Segment%3A%20web%22%2C%22%24initial_referrer%22%3A%20%22%24direct%22%2C%22%24initial_referring_domain%22%3A%20%22%24direct%22%2C%22mp_name_tag%22%3A%20%22ethan.b.feinberg%40gmail.com%22%2C%22id%22%3A%20%222de37786-dada-4343-b5ec-91f1d5c6d2d7%22%2C%22first_name%22%3A%20%22EthanFe%22%2C%22last_name%22%3A%20null%2C%22learn_uuid%22%3A%20%222de37786-dada-4343-b5ec-91f1d5c6d2d7%22%2C%22learn_organization%22%3A%20%22In%20Person%22%2C%22date_of_birth%22%3A%20null%2C%22user_type%22%3A%20%22student%22%2C%22github_username%22%3A%20%22EthanFe%22%2C%22%24created%22%3A%20%222018-06-14T05%3A27%3A04.563Z%22%2C%22%24email%22%3A%20%22ethan.b.feinberg%40gmail.com%22%2C%22%24first_name%22%3A%20%22EthanFe%22%7D; __hstc=112149531.0e8a6c5dec1e1b0ef0247b5682b50c29.1534294089915.1534450806984.1534636685376.6; seg_xid=5bf00ca2-2947-4763-96df-5cb285737466; seg_xid_fd=learn.co; seg_xid_ts=1537369723413; intercom-session-j4d6dyie=dWVZM2xtRVo1QkZJTlI4aWpGT1g0ZXFMN1YvSEhqeTJvQ1BtOEQvY2VqeWI1MDVmSFlzU2xoa09oVFQxRU1HVC0tRGJnV2lPODFaY3RpN1Z3ZkY0QWZ6QT09--098fbbd2559c126858b3fc26b314cd7a0810ffe8; _feyonce_session=S1~VXFWVHRWdEdiZ2l4S2pwU2tsdmVtMmJnQkRLK3ZIUU4xZFFGNWZxSGFiTUN2ME1LYTQreEF6TTNnbjFTdkRkMlNORkpsUmdyaTc0OVNCVTNWVUdDQVFRSlZLdzlGNXZlVEN4bklWT08wdmhzanFEQ2JGNmVYbm42RlNuMlplL1hrOERIT0R3bUtTNytvVmJaYTAvZm8yN1poS05ETHZBZDZlckRZUDVaVTRyMWpCMzBJVnd5UTlVRFloSVYvVGw2R3pqbExDbGJsZlJXWHBBL0NnWkk2bTE3TjdjQ0REeUpDdS9seVltb2RCbnRWRkRSbEg5bU5JTFNVN1hiR1VlNEhxUzJYS1BVYm5jQjBYbXdzdHpQWXAySTFJdlk0V1NKdGNsK0tVOThLbzhqd0ozWTBFYXNON1QyYk1oRGdoRmppeDB5K0l2OHNSbUZBUmkyalR5OG5HbThNWWtocjhBTWVISlFMRkNzbyt3PS0tUkhINGFQSnV0bnBvdGExMlQvbjNiZz09--45af2a933c65a3c137b5e587ca8d88525d128c4a",
      "Host": "learn.co",
      "If-None-Match": `W/"32823889a8bc6c5eb7c23a03f749db72"`,
      "Referer": "https://learn.co/kapham2",
      "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36",
      "X-CSRF-Token": "m7S/ZOFkSUDLVjccyVyMFmJgLZKYi7fOCR3oqjdf1fxG1agM+judXIAXx0xPlWUWaXmtr4sCX+qyGG8mi4q6pg=="
    })
    JSON.parse(api_response)
  end
end