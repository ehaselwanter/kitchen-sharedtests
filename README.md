# Kitchen::SharedTests

This gem allows you to use an external git repo for your tests. This comes in handy if you want to separate the tests from your test-kitchen project. There is a patch pending to make this non intrusive (read feature) in test-kitchen itself

- [Test Artifact Fetch Feature](https://github.com/test-kitchen/test-kitchen/issues/434)

## Installation

Add this line to your application's Gemfile:

    gem 'kitchen-shared-tests'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kitchen-shared-tests

## Usage

Create a Thorfile in your porject and add 

```
require 'bundler'
require 'bundler/setup'
require 'kitchen_sharedtests'
require 'kitchen/sharedtests_thor_tasks'

Kitchen::SharedtestsThorTasks.new
```

to your Thorfile

Add a new option to your `kitchen.yml` pointing to the integration test repo

```
provisioner:
  test_repo_uri: "https://github.com/ehaselwanter/tests-kitchen-example.git"
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/kitchen-shared-tests/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
