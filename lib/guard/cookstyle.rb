require 'guard'
require 'guard/plugin'
require 'guard/rubocop'
require 'cookstyle'
require "guard/cookstyle/version"
require "guard/cookstyle/monkey_patch/listen"

module Guard
  class Cookstyle < ::Guard::RuboCop
    class_eval do
      autoload :Runner, 'guard/cookstyle/runner'

      def initialize(options = {})
        super

        @options = {
          all_on_start: true,
          keep_failed:  true,
          notification: :failed,
          cli: nil,
          hide_stdout: false,
          cookbook_dirs: %w[.]
        }.merge(options)

        @failed_paths = []
      end

      def run_all
        UI.info 'Inspecting Chef Cookbook style of all files'
        inspect_with_cookstyle
      end

      private

      def run_partially(paths)
        paths += @failed_paths if @options[:keep_failed]
        paths = clean_paths(paths)

        return if paths.empty?

        displayed_paths = paths.map { |path| smart_path(path) }
        UI.info "Inspecting Chef Cookbook style: #{displayed_paths.join(' ')}"

        inspect_with_cookstyle(paths)
      end

      def inspect_with_cookstyle(paths = [])
        runner = Runner.new(@options)
        passed = runner.run(paths)
        @failed_paths = runner.failed_paths
        throw :task_has_failed unless passed
      rescue StandardError => error
        UI.error 'The following exception occurred while running guard-cookstyle: ' \
                "#{error.backtrace.first} #{error.message} (#{error.class.name})"
      end
    end
  end
end
