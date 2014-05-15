require 'kitchen/sharedtests/version'

module Kitchen
  module Sharedtests
    TEST_REPO_NAME = "shared_test_repo"
    TEST_REPO_BASE_PATH = File.join(Dir.pwd, TEST_REPO_NAME)
    # this is the path to the directory containing the integration test suites
    TEST_BASE_PATH = TEST_REPO_BASE_PATH
  end
end