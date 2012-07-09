class DashboardsController < ApplicationController
  
  def show
    @me = FbGraph::User.me(current_user.access_token).fetch
    friends = @me.friends
    @birthdays = get_birthdays(friends)
    
    rawevents = @me.events
    @events = get_events(rawevents)
  end
  
  def get_birthdays(friends)
    require 'fb_graph'
    birthdays = Hash.new
    
    rawbirthdays = FbGraph::Query.new(
      'SELECT uid,name,birthday_date 
        FROM user 
        WHERE uid 
        IN
          (
            SELECT uid2 
            FROM friend 
            WHERE uid1 = me()
           )
      '
    ).fetch(current_user.access_token)
    
    rawbirthdays.each do |friend|
      friend_uid = friend["uid"]
      picture = "https://graph.facebook.com/#{friend_uid}/picture?type=large"
      date = friend["birthday_date"].to_s
      time = Time.new
      birthday_date = date[0...5] + "/" + time.year.to_s
      
      birthdays[friend_uid] = [
        "name" => friend['name'],
        "birthday" => birthday_date,
        "picture" => picture,
        "uid" => friend_uid
      ]
    end
      
    return birthdays
  end
  
  def get_events(rawevents)
    events = Hash.new
    
    rawevents.each do |event|
      eventid = event.raw_attributes["id"]
      start = ""
      enddate = ""
      date = ""
      
      #format start date
      start_date = event.raw_attributes["start_time"].gsub("T", "-")
      start_parts = start_date.split('-')
      if start_parts.present?
        start = start_parts[1].to_s + " " + start_parts[2].to_s + ", " + start_parts[0].to_s + " " + start_parts[3].to_s
      end
      #format end date
      end_date = event.raw_attributes["end_time"].gsub("T", "-")
      end_parts = end_date.split('-')
      if end_parts.present?
        enddate = end_parts[1].to_s + " " + end_parts[2].to_s + ", " + end_parts[0].to_s + " " + end_parts[3].to_s
      end
      #format date string
      if start_parts.present? && end_parts.present?
        date = start_parts[1].to_s + "/" + start_parts[2].to_s + "/" + start_parts[0].to_s + " to " + end_parts[1].to_s + "/" + end_parts[2].to_s + "/" + end_parts[0].to_s
      end
      #create events array
      events[eventid] = [
        "id" => event.raw_attributes["id"],
        "name" => event.raw_attributes["name"],
        "start" => start,
        "end" => enddate,
        "date" => date,
        "description" => event.description,
        "picture" => event.picture,
        "rsvp" => event.raw_attributes["rsvp_status"]
      ]
    end
    
    return events
  end
  
  def debug
    #for testing purposes only
    
    @me = FbGraph::User.me(current_user.access_token).fetch
    friends = @me.friends
    @birthdays = get_birthdays(friends)
    
    rawevents = @me.events
    @events = get_events(rawevents)
  end
  
end
