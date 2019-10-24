require 'active_record'
#require 'activerecord-jdbcmysql-adapter'
class Withinproject < ActiveRecord::Base
  establish_connection(
      adapter:  "mysql2",
      host:     "10.131.252.160",
      username: "root",
      password: "root",
      database: "travistorrent",
      encoding: "utf8mb4",
      collation: "utf8mb4_unicode_ci",
      pool:300
  )
  serialize :maven_slice, Array
  serialize :test_inerror, Array
  serialize :fail_test, Array
  serialize :error_file, Array
end
