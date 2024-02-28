file = 'event_attendees.csv'

#Iteration 0: Loading a file
#===========================

puts 'Event Manager Initialized!'
#check if file exist
if File.exist? file 

#reading the whole file
contents = File.read(file)
puts contents


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
