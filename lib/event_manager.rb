file = 'event_attendees.csv'

#Iteration 0: Loading a file
#===========================

#puts 'Event Manager Initialized!'
#check if file exist
#if File.exist? file 

#reading the whole file
#contents = File.read(file)
#puts contents

=begin
  #read the file line by line
  lines = File.readlines(file)
  lines.each_with_index do |line, index|
    
    #skip the header 
    next if index == 0  
    columns = line.split(',')
    first_name = columns[2] 
    puts first_name
  end
end
=end

#Iteration 1: Parsing with CSV
#=============================

=begin

require 'csv'
puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]
  zipcode = row[:zipcode]
  puts "#{name} #{zipcode}"
end

=end

#Iteration 2: Cleaning up our zip codes
#======================================
=begin

require 'csv'

def clean_zipcode(zipcode)
  if zipcode.nil?
    '00000'
  elsif zipcode.length < 5
    zipcode.rjust(5, '0')
  elsif zipcode.length > 5
    zipcode[0..4]
  else
    zipcode
  end
end

#refactored method
#def clean_zipcode(zipcode)
  #zipcode.to_s.rjust(5, '0')[0..4]
#end

puts 'EventManager initialized.'

contents = CSV.open(
  file,
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])

  # if the zip code is exactly five digits, assume that it is ok
  # if the zip code is more than five digits, truncate it to the first five digits
  # if the zip code is less than five digits, add zeros to the front until it becomes five digits

  

  puts "#{name} #{zipcode}"
end
=end


#Iteration 3: Using Google’s Civic Information
#=============================================

=begin
require 'csv'
require 'google/apis/civicinfo_v2'

civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    legislators = civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    )
    legislators = legislators.officials
    legislator_names = legislators.map(&:name)
    legislator_names.join(", ")
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]

  zipcode = clean_zipcode(row[:zipcode])

  legislators = legislators_by_zipcode(zipcode)

  puts "#{name} #{zipcode} #{legislators}"
end
=end

#Iteration 4: Form Letters
#=========================

=begin
require 'csv'
require 'google/apis/civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5,"0")[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = 'AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw'

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: 'country',
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id,form_letter)
  Dir.mkdir('output') unless Dir.exist?('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  legislators = legislators_by_zipcode(zipcode)

  form_letter = erb_template.result(binding)

  #save_thank_you_letter(id,form_letter)
end
=end

#Assignment: Clean phone numbers
require 'csv'

def clean_phone(phone)
    
  spcl_chars = [" ", ".", "-", "(", ")"]
  for i in 0..spcl_chars.length-1 do
    if phone.include? spcl_chars[i]
      phone = phone.delete spcl_chars[i]
    end
  end

  #If the phone number is 11 digits and the first number is 1, trim the 1 and use the remaining 10 digits
  if phone.length == 11 && phone[0] == "1"
    phone = phone[1..10]
  
  #If the phone number is 11 digits and the first number is not 1, then it is a bad number
  #If the phone number is less than 10 digits, assume that it is a bad number
  #If the phone number is more than 11 digits, assume that it is a bad number
  elsif (phone.length == 11 && phone[0] != "1") || phone.nil? || phone.length < 10 || phone.length > 11
    phone = ''
  else #If the phone number is 10 digits, assume that it is good
    phone 
  end
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  name = row[:first_name]
  phone = clean_phone(row[:homephone])
  
  puts "#{name} #{phone}"
end