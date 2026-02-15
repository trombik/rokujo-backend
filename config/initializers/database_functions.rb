# SQLite3 does not support regexp operator by default and custom SQL function
# does not persist on disk.
#
# when loading SQLite3Adapter, create a regexp function so that
# `where("text regexp ?", pattern)` works in sqlite3 like `text ~ ?` in
# Postgresql.
#
# ref: https://guides.rubyonrails.org/configuring.html#load-hooks
ActiveSupport.on_load(:active_record_sqlite3adapter) do
  ActiveRecord::ConnectionAdapters::SQLite3Adapter.class_eval do
    alias_method :original_initialize, :initialize
    def initialize(*args)
      original_initialize(*args)

      raw_connection.create_function("regexp", 2) do |function, pattern, expression|
        regex_matcher = Regexp.new(pattern.to_s, Regexp::IGNORECASE)
        function.result = expression.to_s.match(regex_matcher) ? 1 : 0
      end
    end
  end
end
