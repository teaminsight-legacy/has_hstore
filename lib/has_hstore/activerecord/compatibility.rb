# Inspired from Rails 4.X work and https://github.com/softa/activerecord-postgres-hstore
# This only adds support for hstore in migrations and schema dumping. This does not
# handle converting hashes to hstore string format or vice versa.

# Extends AR to add Hstore functionality.
module ActiveRecord

  module ConnectionAdapters

    class TableDefinition

      # Adds hstore type for migrations. So you can add columns to a table like:
      #   create_table :people do |t|
      #     ...
      #     t.hstore :info
      #     ...
      #   end
      def hstore(*args)
        options = args.extract_options!
        column_names = args
        column_names.each { |name| column(name, 'hstore', options) }
      end

    end

    class PostgreSQLColumn < Column

      # Adds the hstore type for the column.
      def simplified_type_with_hstore(field_type)
        field_type == 'hstore' ? :hstore : simplified_type_without_hstore(field_type)
      end

      alias_method_chain :simplified_type, :hstore
    end

    class PostgreSQLAdapter < AbstractAdapter
      def native_database_types_with_hstore
        native_database_types_without_hstore.merge({:hstore => { :name => "hstore" }})
      end

      alias_method_chain :native_database_types, :hstore
    end
  end
end
