require 'active_record'
#require 'activerecord-jdbcmysql-adapter'
class Travistorrent_alldatas < ActiveRecord::Base
  establish_connection(
      adapter:  "mysql2",
      host:     "10.131.252.160",
      username: "root",
      password: "root",
      database: "travistorrent2017",
      encoding: "utf8mb4",
      collation: "utf8mb4_bin",
      pool:300
  )
#   serialize :maven_slice, Array
#   serialize :test_inerror, Array
#   serialize :fail_test, Array
#   serialize :error_file, Array
end