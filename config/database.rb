require 'sinatra/activerecord'

def self.connect_to_database_prod
  begin
    config = {
      :adapter  => "mysql2",
      :host     => "#{ENV["DATABASE_SERVICE_HOST"]}",
      :port     => "#{ENV["DATABASE_SERVICE_PORT"]}",
      :database => "sampledb"
    }
    if ENV.key?("DATABASE_ROOT_PASSWORD")
      config[:password] = "#{ENV["DATABASE_ROOT_PASSWORD"]}"
    else
      config[:username] = "#{ENV["DATABASE_USER"]}"
      config[:password] = "#{ENV["DATABASE_PASSWORD"]}"
    end

    puts "Connecting to production database (#{config[:username]}@#{config[:host]}:#{config[:port]})..."
    ActiveRecord::Base.establish_connection(config)

    ActiveRecord::Base.connection.active?

  rescue Exception => e
    if not /Can't connect to MySQL server/ =~ e.message
      puts e.message
    end
    return false
  end
end

def self.connect_to_database_test
  begin
    config = {
      :adapter  => "mysql2",
      :host     => "#{ENV["DATABASE_TEST_SERVICE_HOST"]}",
      :port     => "#{ENV["DATABASE_TEST_SERVICE_PORT"]}",
      :database => "sampledb"
    }
    if ENV.key?("DATABASE_ROOT_PASSWORD")
      config[:password] = ENV["DATABASE_ROOT_PASSWORD"]
    else
      config[:username] = ENV["DATABASE_USER"]
      config[:password] = ENV["DATABASE_PASSWORD"]
    end

    puts "Connecting to test database (#{config[:username]}@#{config[:host]}:#{config[:port]})..."
    ActiveRecord::Base.establish_connection(config)

    ActiveRecord::Base.connection.active?

  rescue Exception => e
    if not /Can't connect to MySQL server/ =~ e.message
      puts e.message
    end
    return false
  end
end
