require 'artoo'

connection :keyboard, adaptor: :keyboard
device :keyboard, driver: :keyboard, connection: :keyboard

work do
  puts "working now..."

  on keyboard, :key => :keypress
end

def keypress(sender, key)
  puts key
end