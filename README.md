# VendingMachine

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/vending_machine`. To experiment with that code, run `bin/console` for an interactive prompt.

## Notes / Upgrades

* This is designed such that the machine is single user only, an extensive rewrite of the float module at the very least would be required to make it multiuser/thread safe
* There is no persistence of the stock or float currently, I chose to work on functionality over creating a database schema (of any kind)
* Currently only one product can be bought per transaction.  If we wanted to allow people to buy multiple products I would probably move most of the logic in VendingMachine into a new module VendingMachine::Cart (or similar name)/  Then the VendingMachine module would have two instances of this, one for the current requested products and payment and one for the current stock and float (since the functionality required for those parts is identical, albeit slightly reversed)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vending_machine'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vending_machine

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the VendingMachine project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/vending_machine/blob/master/CODE_OF_CONDUCT.md).
