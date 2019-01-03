require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'.freeze
CREDENTIALS_PATH = 'credentials.json'.freeze

# The file token.yaml stores the user's access and refresh tokens, and is
# created automatically when the authorization flow completes for the first
# time.

TOKEN_PATH = 'token.yaml'.freeze
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR_READONLY

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials

def authorize
  client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(base_url: OOB_URI)
    puts 'Open the following URL in the browser and enter the ' \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
      user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end



def parseEmail(email)
  s = email[0,email.index("@")]
  s[0] = s[0].upcase()
  s[s.index(".")+1] = s[s.index(".")+1].upcase()
  s[s.index(".")] = " "
  return s
end


def parseTimeTimes(date)
  return date.hour.to_s+":"+date.min.to_s
end

def calcHowManyBlocks(date,date2)
  blocks = 2*(date2.hour.to_i - date.hour.to_i)
  if (date2.min.to_i > date.min.to_i)
    blocks +=1
  elsif(date2.min.to_i < date.min.to_i)
    blocks -=1
  end
  return blocks
end

def convertToTime(index)
#key = day
#index = half hour
    if index%2 ==0
      return ((index/2).to_s+":"+"00")
    end

  return ((index/2).to_s+":"+"30")
end

def calculate(timeMin,timeMax)
  calender = {}
  # Initialize the API
  service = Google::Apis::CalendarV3::CalendarService.new
  service.client_options.application_name = APPLICATION_NAME
  service.authorization = authorize


  calendar_id = 'YOUR CALENDER URL HERE'
  response = service.list_events(calendar_id,
                                single_events: true,
                                order_by: 'startTime',
                                time_min: timeMin,
                                time_max: timeMax)
                                # time_max: Time.parse("2018-12-07 00:00:00 EST").iso8601)


  #Time.now.iso8601
  #
  #puts 'Upcoming events:'
  #puts 'No upcoming events found' if response.items.empty?

  #MAKE THE TABLEs
  response.items.each do |event|
    start = event.start.date || event.start.date_time

  if !(calender.key?(event.start.date_time.day))
    calender[event.start.date_time.day] = Hash.new 
    index = 0
    while index <= 48
      calender[event.start.date_time.day][index] = Array.new
      index +=1
    end
  end
  end


  #calender[days][hours][people]
  #FILL THE TABLES
  response.items.each do |event|
    start = event.start.date || event.start.date_time
    for index in calcHowManyBlocks(DateTime.new(event.start.date_time.year,event.start.date_time.month,event.start.date_time.day,0,0,0),event.start.date_time)..calcHowManyBlocks(DateTime.new(event.start.date_time.year,event.start.date_time.month,event.start.date_time.day,0,0,0),event.start.date_time)+(calcHowManyBlocks(event.start.date_time, event.end.date_time)-1)
      calender[event.start.date_time.day][index].push(parseEmail(event.creator.email))
    end
  end
  puts 'Times Everyone is Free:'

  test = []
  calender.each_key do |key|
    index = 0
    #puts("found-----------------------")
    test.push(key)
    puts(key)
    #if (key == 27)
    #  puts(calender[key])  
    #end
    while index <= 48
    
      if(calender[key][index] == Array.new)
        
        if ((index >= 18) and (index <= 34))
          test.push(convertToTime(index))
          puts(convertToTime(index))
        end
      end
    index +=1
    end
  end
  #puts calender
end


calculate(Time.parse("2018-11-05 00:00:00 EST").iso8601,Time.parse("2018-11-10 00:00:00 EST").iso8601)

