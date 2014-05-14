require 'kitchen/sharedtests/version'

module Kitchen
  module Sharedtests
    TEST_REPO_NAME = "shared_test_repo"
    TEST_REPO_BASE_PATH = File.join(Dir.pwd, TEST_REPO_NAME)
    TEST_BASE_PATH = File.join(TEST_REPO_BASE_PATH, "/test/integration")
  end
end