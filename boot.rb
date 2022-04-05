require "./boot/kernel"

# load app files

app_files = Dir["./app/**/*.rb"].sort

app_files.each do |file|
  require file
end

Console.logger.info("Boot", "app files loaded")

Console.logger.info("Boot", "completed")
