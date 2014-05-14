# -*- encoding: utf-8 -*-
#
# Author:: Fletcher Nichol (<fnichol@nichol.ca>)
#
# Copyright (C) 2012, Fletcher Nichol
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
      @config = Kitchen::Config.new :test_base_path => ::TEST_BASE_PATH 
      Kitchen.logger = Kitchen.default_file_logger
      yield self if block_given?
      define
    end

    private

    attr_reader :config

    def define
      config.instances.each do |instance|
        self.class.desc instance.name, "Run #{instance.name} test instance"
        self.class.send(:define_method, instance.name.gsub(/-/, '_')) do
          create_or_update_test_repo("https://github.com/ehaselwanter/tests-kitchen-example.git", "shared_test_repo", :path => Dir.pwd)
          instance.test(:always)
        end
      end

      config.instances.each do |instance|
        command = "verify-#{instance.name}"
        self.class.desc command, "Run #{command} to verify instance"
        self.class.send(:define_method, command.gsub(/-/, '_')) do
          create_or_update_test_repo("https://github.com/ehaselwanter/tests-kitchen-example.git", "shared_test_repo", :path => Dir.pwd)
          instance.verify
        end
      end

      self.class.desc "all", "Run all test instances"
      self.class.send(:define_method, :all) do
        config.instances.each { |i| invoke i.name.gsub(/-/, '_') }
      end

      config.instances.each do |instance|
        self.class.desc "diagnose-#{instance.name}", "Diagnose #{instance.name} test instance"
        self.class.send(:define_method, "diagnose_#{instance.name.gsub(/-/, '_')}") do
          puts instance.diagnose
        end
      end
    end

    def create_or_update_test_repo(repo_url,name,path)
      repo_path = File.join(Dir.pwd,name)
      if File.directory?(repo_path)
        Kitchen.logger.info("updating #{repo_path} ")
        local_repo = Git.open(repo_path, :log => Kitchen.logger)
        local_repo.pull
      else 
        Kitchen.logger.info("cloning repo_path ")
        ::Git.clone(repo_url, "shared_test_repo", :path => Dir.pwd, :log => Kitchen.logger)
      end
    end

  end
end