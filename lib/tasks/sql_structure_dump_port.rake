Rake::Task["db:structure:dump"].clear

namespace :db do
  namespace :structure do
    desc "Overriding the task db:structure:dump task to remove -i option from pg_dump to make postgres 9.5 compatible"
    task :dump => [:environment, :load_config] do
      puts "Running custom port of db:structure:dump from Rails 4.2.5 - this can be removed when we upgrade to 4.2.5"
      filename = ENV['DB_STRUCTURE'] || File.join(ActiveRecord::Tasks::DatabaseTasks.db_dir, "structure.sql")
      current_config = ActiveRecord::Tasks::DatabaseTasks.current_config
      set_psql_env(current_config)
      # ActiveRecord::Tasks::DatabaseTasks.structure_dump(current_config, filename)
      database = current_config["database"]
      command = "pg_dump -s -x -O -f #{Shellwords.escape(filename)} #{Shellwords.escape(database)}"
      raise 'Error dumping database' unless Kernel.system(command)
      # filename =  File.join(Rails.root, "db", "structure.sql")
      # File.open(filename, "a") { |f| f << "SET search_path TO #{ActiveRecord::Base.connection.schema_search_path};\n\n" }

      if ActiveRecord::Base.connection.supports_migrations? &&
          ActiveRecord::SchemaMigration.table_exists?
        File.open(filename, "a") do |f|
          f.puts ActiveRecord::Base.connection.dump_schema_information
          f.print "\n"
        end
      end
      Rake::Task["db:structure:dump"].reenable
    end
  end

  def set_psql_env(configuration)
    ENV['PGHOST']     = configuration['host']          if configuration['host']
    ENV['PGPORT']     = configuration['port'].to_s     if configuration['port']
    ENV['PGPASSWORD'] = configuration['password'].to_s if configuration['password']
    ENV['PGUSER']     = configuration['username'].to_s if configuration['username']
  end

end
