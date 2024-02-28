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