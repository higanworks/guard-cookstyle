# https://github.com/guard/listen/wiki/Duplicate-directory-errors
if Gem::Version.new(2.8) < Gem::Version.new(Listen::VERSION)
  require 'listen/record/symlink_detector'
  module Listen
    class Record
      class SymlinkDetector
        def _fail(_, _)
          fail Error, "Don't watch locally-symlinked directory twice"
        end
      end
    end
  end
end
