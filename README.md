# Artoo Adaptor For Keyboard Input

This repository contains the Artoo (http://artoo.io/) adaptor for keyboard input.

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

## Documentation

Check out our [documentation](http://artoo.io/documentation/) for lots of information about how to use Artoo.

## IRC

Need more help? Just want to say "Hello"? Come visit us on IRC freenode #artoo

## Contributing

* All active development is in the dev branch. New or updated features must be added to the dev branch. Hotfixes will be considered on the master branch in situations where it does not alter behaviour or features, only fixes a bug.
* All patches must be provided under the Apache 2.0 License
* Please use the -s option in git to "sign off" that the commit is your work and you are providing it under the Apache 2.0 License
* Submit a Github Pull Request to the appropriate branch and ideally discuss the changes with us in IRC.
* We will look at the patch, test it out, and give you feedback.
* Avoid doing minor whitespace changes, renamings, etc. along with merged content. These will be done by the maintainers from time to time but they can complicate merges and should be done seperately.
* Take care to maintain the existing coding style.
* Add unit tests for any new or changed functionality.
* All pull requests should be "fast forward"
  * If there are commits after yours use “git rebase -i <new_head_branch>”
  * If you have local changes you may need to use “git stash”
  * For git help see [progit](http://git-scm.com/book) which is an awesome (and free) book on git


(c) 2012-2014 The Hybrid Group
