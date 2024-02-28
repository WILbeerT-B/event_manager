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
  space = reg_date.index(' ')
  #get the date from the string
  date = reg_date[0..space-1]
  #get the time from the string
  time = reg_date[space+1..reg_date.length]
  #split the date
  s_date = date.split('/')
  #fix the format of the date to year/month/day
  s_date[0], s_date[1], s_date[2] = s_date[2], s_date[0], s_date[1]
  #put together the date as a string
  f_date = s_date.join('/')
  
  #Using the registration date and time we want to find out what 
  #the peak registration hours are.

  #create the Time object
  my_date = Time.parse(f_date +" "+ time)

  #To get the peak registration hours, get the hours from date
  hours = my_date.strftime("%k")
  #fix the hours
  if hours.include?(" ")
    hours = hours.gsub(" ", "0")
  end
  all_hours = all_hours.push(hours)

  days = my_date.wday 
  s_days = days.to_s.split()
  for i in 0..s_days.length-1 do
    day_of_week = case s_days[i]
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
  all_days = all_days.push(day_of_week)
end

#method to count the number of occurences of each hour/day
def check_peak(nums)
  nums.reduce(Hash.new(0)) do |result, hr|
    result[hr] += 1
    result
  end
end

peak_hour = check_peak(all_hours)
puts peak_hour
#get the peak hours
peak_hour.each { |k, v| puts k if v == peak_hour.values.max }

peak_day = check_peak(all_days)
puts peak_day
peak_day.each { |k, v| puts k if v == peak_day.values.max }