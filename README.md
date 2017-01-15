# Reco4life

封装[Reco4life开发者平台](http://www.reco4life.com/wiki/%E9%A6%96%E9%A1%B5)提供的API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'reco4life'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install reco4life

## Usage

```ruby
require 'reco4life'

begin
  Reco4life.user_name = 'your_user_name'
  Reco4life.api_key ='your_api_key'

  Reco4life.devices.each do |sn|
    next unless Reco4life.online? sn
    Reco4life.turn_on sn
    puts Reco4life.powered_on? sn
  end
rescue => e
  puts e
end
```

## License

[MIT License](http://opensource.org/licenses/MIT).
