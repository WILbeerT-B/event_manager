#Assignment: Time Targeting & Day of the week targeting

require 'csv'
require 'time'

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)
#array holders
all_hours = []
all_days = []

contents.each do |row|
  zipcode = row[:zipcode]
  reg_date = row[:regdate]
  #get the index of space
  space = reg_date.index(' ')
  #get the date from the string regdate
  date = reg_date[0..space-1]
  #get the time from the string regdate
  time = reg_date[space+1..reg_date.length]
  #split the date
  s_date = date.split('/')
  #fix the format of the date to year/month/day
  s_date[0], s_date[1], s_date[2] = s_date[2], s_date[0], s_date[1]
  #put together the date as a string
  f_date = s_date.join('/')
  
  #Using the registration date and time we want to find out what 
  #the peak registration hours / days are.

  #create the Time object
  my_date = Time.parse(f_date +" "+ time)

  #To get the peak registration hours, get the hours from date
  hours = my_date.strftime("%k")
  
  #fix the hours
  hours = hours.gsub(" ", "0") if hours.include?(" ")

  #push hours to all_hours array
  all_hours.push(hours)

  days = my_date.wday.to_s.split()
  for i in 0..days.length-1 do
    day_of_week = case days[i]
      when '0' then "Sunday"
      when '1' then "Monday"
      when '2' then "Tuesday"
      when '3' then "Wednesday"
      when '4' then "Thursday"
      when '5' then "Friday"
      when '6' then "Saturday"
    end
    #puts day_of_week
  end
  #push days to all_days array
  all_days.push(day_of_week)
end

#method to count the number of occurences of each hour/day
def check_peak(nums)
  nums.reduce(Hash.new(0)) do |result, hr|
    result[hr] += 1
    result
  end
end

#method to get the peak hours / days
def get_peak(nums)
  nums.each { |k, v| puts k if v == nums.values.max }
end

#get the peak hours
hours_peak = check_peak(all_hours)
#puts hours_peak
puts "Peak Hours:"
peak_hours = get_peak(hours_peak)
#puts peak_hours

#get the peak days
days_peak = check_peak(all_days)
#puts days_peak
puts "Peak Days:"
peak_days = get_peak(days_peak)
#puts peak_days