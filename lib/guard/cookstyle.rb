require 'guard'
require 'guard/plugin'
require "guard/cookstyle/version"
require "guard/cookstyle/monkey_patch/listen"

module Guard
  class Cookstyle < Plugin
    autoload :Runner, 'guard/cookstyle/runner'

    attr_reader :options, :failed_paths

    def initialize(options = {})
      super

      @options = {
        all_on_start: true,
        keep_failed:  true,
        notification: :failed,
        cli: nil,
        hide_stdout: false,
        cookbook_dirs: %w[cookbooks site-cookbooks]
      }.merge(options)

      @failed_paths = []
    end

    def start
      run_all if @options[:all_on_start]
    end

    def run_all
      UI.info 'Inspecting Chef Cookbook style of all files'
      inspect_with_cookstyle
    end

    def run_on_additions(paths)
      run_partially(paths)
    end

    def run_on_modifications(paths)
      run_partially(paths)
    end

    def reload
      @failed_paths = []
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

    def clean_paths(paths)
      paths = paths.dup
      paths.map! { |path| File.expand_path(path) }
      paths.uniq!
      paths.reject! do |path|
        next true unless File.exist?(path)
        included_in_other_path?(path, paths)
      end
      paths
    end

    def included_in_other_path?(target_path, other_paths)
      dir_paths = other_paths.select { |path| File.directory?(path) }
      dir_paths.delete(target_path)
      dir_paths.any? do |dir_path|
        target_path.start_with?(dir_path)
      end
    end

    def smart_path(path)
      if path.start_with?(Dir.pwd)
        Pathname.new(path).relative_path_from(Pathname.getwd).to_s
      else
        path
      end
    end
  end
end
