# Kitchen::SharedTests

This gem allows you to use an external git repo for your tests. This comes in handy if you want to separate the tests from your test-kitchen project. There is a patch pending to make this non intrusive (read feature) in test-kitchen itself

- [Test Artifact Fetch Feature](https://github.com/test-kitchen/test-kitchen/issues/434)

## Installation

Add this line to your application's Gemfile:

    gem 'kitchen-sharedtests'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kitchen-sharedtests

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

Then you can either overwrite your local integration folder or run from a new integration test folder.

```
thor kitchen:fetch-remote-tests

± kitchen diagnose |grep test_base_path
        test_base_path: /....../puppet-kitchen-example/test/integration
        test_base_path: /....../puppet-kitchen-example/test/integration
        test_base_path: /....../puppet-kitchen-example/test/integration
```

will clone the in the `provisioner.test_repo_uri` to `test/integration`

```
thor kitchen:all-sharedtests 
```

and the other `kitchen:*-sharedtests*` tasks will create a folder `./shared_test_repo` and point `test_base_path` to this folder

```
± thor kitchen:diagnose-sharedtests-default-ubuntu-1204|grep test_base_path
    !ruby/sym test_base_path: /....../puppet-kitchen-example/shared_test_repo
    !ruby/sym test_base_path: /....../puppet-kitchen-example/shared_test_repo
    !ruby/sym test_base_path: /....../puppet-kitchen-example/shared_test_repo
```    

```
± thor -T
kitchen
-------
thor kitchen:all-sharedtests                           # Run all test instances
thor kitchen:diagnose-sharedtests-default-ubuntu-1204  # Diagnose default-ubuntu-1204 test instance
thor kitchen:fetch-remote-tests                        # Fetch remote tests from provider.test_repo_uri
thor kitchen:run-sharedtests-default-ubuntu-1204       # Run run-sharedtests-default-ubuntu-1204 test instance
thor kitchen:verify-sharedtests-default-ubuntu-1204    # Run default-ubuntu-1204 to verify instance
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/kitchen-shared-tests/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
