require 'json'
require 'cookstyle'
require 'guard/rubocop/runner'

module Guard
  class Cookstyle
    # This class runs `cookstyle` command, retrieves result and notifies.
    # An instance of this class is intended to invoke `cookstyle` only once in its lifetime.
    class Runner < ::Guard::RuboCop::Runner
      class_eval do
        def build_command(paths)
          command = ['rubocop']

          if should_add_default_formatter_for_console?
            command.concat(%w[--format progress]) # Keep default formatter for console.
          end

          command.concat(['-r', 'cookstyle'])
          command.concat(['--format', 'json', '--out', json_file_path])
          command << '--force-exclusion'
          command.concat(args_specified_by_user)

          if paths.any?
            command.concat(paths)
          else
            command.concat(@options[:cookbook_dirs])
          end
          command
        end
      end
    end
  end
end
