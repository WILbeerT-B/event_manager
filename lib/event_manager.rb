puts 'Event Manager Initialized!'
if File.exist? 'event_attendees.csv' 
  #contents = File.read('event_attendees.csv')
  #puts contents

  len = 0
  lines = File.readlines('event_attendees.csv')
  lines.each_with_index do |line, index|
    columns = line.split(',')
    puts columns[2] if index > 0
  end
end