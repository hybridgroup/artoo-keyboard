# Artoo Adaptor For Keyboard Input

This repository contains the Artoo (http://artoo.io/) adaptor for keyboard
input.

Artoo is a open source micro-framework for robotics using Ruby.

For more information about Artoo, check out our repo at https://github.com/hybridgroup/artoo

## Installing

```
gem install artoo-keyboard
```

## Using

```ruby
require 'artoo'

connection :keyboard, adaptor: :keyboard
device :keyboard, driver: :keyboard, connection: :keyboard

work do
  on keyboard, :key => :keypress
end

def keypress(sender, key)
  puts key
end
```
