expand :clean, paths: :gitignore

tool "db-migrate" do
  desc "run database migrations"
  flag :version, default: ""
  flag :env, default: "development"
  def run
    ENV["RACK_ENV"] = env

    require "./boot/kernel"

    Sequel.extension :migration

    if !DB.tables.include?(:schema_info)
      # create table
      DB.create_table(:schema_info) do
        Int :version
      end
    end

    if DB[:schema_info].first.nil?
      # create record
      DB[:schema_info].insert(version: 0)
    end

    version_pre = DB[:schema_info].first[:version]
    version_target = version.length.nonzero? ? version.to_i : version_pre

    Console.logger.info("Toys", "migrate version current #{version_pre} target #{version_target}")

    if version_pre != version_target
      Sequel::Migrator.run(DB, "db/migrations", target: version_target)
    end

    version_post = DB[:schema_info].first[:version]

    Console.logger.info("Toys", "migrate version post #{version_post}")
  end
end
