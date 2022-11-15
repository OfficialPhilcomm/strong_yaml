# Usage
Config File:
```yml
url: localhost:3000/
port: 3000

remote:
  port: 5000
  greetings:
    - Hello!
    - Welcome!
```

## Example without schema
```ruby
require "strong_yaml"

class Config
  include StrongYAML

  file "config.yml"
end

Config.load

Config.url
# "localhost:3000/"
Config.port
# 3000
Config.remote.port
# 5000
Config.remote.greetings
# ["Hello!", "Welcome!"]
```

## Example with schema
```ruby
require "strong_yaml"

class Config
  include StrongYAML

  file "config.yml"

  schema do
    string :url, default: "localhost:3000/"
    integer :port, default: 3000

    group :remote do
      integer :port, default: 5000
      list :greetings, default: ["Hello!", "Welcome!"]
    end
  end
end

Config.create_or_load
```
