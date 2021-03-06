# -*- encoding: utf-8 -*-
#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
# Author:: Edmund Haselwanter (<me@ehaselwanter.com>)
#
# Copyright (C) 2012, Fletcher Nichol
# Copyright (C) 2014, Edmund Haselwanter
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'thor'
require 'kitchen'
require 'git'

module Kitchen

  # Kitchen Thor task generator.
  #
  # @author Fletcher Nichol <fnichol@nichol.ca>
  class SharedtestsThorTasks < Thor

    namespace :kitchen

    # Creates Kitchen Thor tasks and allows the callee to configure it.
    #
    # @yield [self] gives itself to the block
    def initialize(*args)
      super
      @config = Kitchen::Config.new :test_base_path => Kitchen::Sharedtests::TEST_BASE_PATH 
      Kitchen.logger = Kitchen.default_file_logger
      yield self if block_given?
      define
    end

    private

    attr_reader :config

    def define
      config.instances.each do |instance|
        command = "run-sharedtests-#{instance.name}"
        self.class.desc command, "Run #{command} test instance"
        self.class.send(:define_method, command.gsub(/-/, '_')) do
          create_or_update_test_repo(instance.provisioner[:test_repo_uri], Kitchen::Sharedtests::TEST_REPO_NAME, config.kitchen_root)
          instance.test(:always)
        end
      end

      config.instances.each do |instance|
        command = "verify-sharedtests-#{instance.name}"
        self.class.desc command, "Run #{instance.name} to verify instance"
        self.class.send(:define_method, command.gsub(/-/, '_')) do
          create_or_update_test_repo(instance.provisioner[:test_repo_uri], Kitchen::Sharedtests::TEST_REPO_NAME, config.kitchen_root)
          instance.verify
        end
      end

      self.class.desc "all-sharedtests", "Run all test instances"
      self.class.send(:define_method, :all_sharedtests) do
        config.instances.each { |i| invoke i.name.gsub(/-/, '_') }
      end

      config.instances.each do |instance|
        command = "diagnose-sharedtests-#{instance.name}"
        self.class.desc command, "Diagnose #{instance.name} test instance"
        self.class.send(:define_method, command.gsub(/-/, '_')) do
          puts instance.diagnose.to_yaml
        end
      end

      self.class.desc "fetch-remote-tests", "Fetch remote tests from provider.test_repo_uri"
      self.class.send(:define_method, "fetch_remote_tests") do
        test_root = File.join(config.kitchen_root,'test')
        Dir.mkdir(test_root) unless File.directory?(test_root)
        create_or_update_test_repo(config.instances.first.provisioner[:test_repo_uri], "integration", test_root)
      end
    end

    def create_or_update_test_repo(test_repo_uri, name, path)

      Kitchen.logger.info("-----> create or update #{test_repo_uri}")
      
      repo_path = File.join(path,name)
      
      if File.directory?(repo_path)
        Kitchen.logger.info("updating #{repo_path} ")
        
        local_repo = Git.open(repo_path)

        # there must be a better way
        if local_repo.status.changed.empty? && local_repo.status.added.empty? \
          && local_repo.status.deleted.empty? && local_repo.status.untracked.empty?
          local_repo.pull
        else
          Kitchen.logger.info("repo not clean, not pulling from #{test_repo_uri}")  
        end
      else 
        Kitchen.logger.info("cloning #{test_repo_uri} #{repo_path} ")
        ::Git.clone(test_repo_uri, name, :path => path, :log => Kitchen.logger)
      end
    end

  end
end