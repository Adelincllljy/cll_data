require 'active_record'
#require 'activerecord-jdbcmysql-adapter'
class Prev_passed < ActiveRecord::Base
  establish_connection(
      adapter:  "mysql2",
      host:     "10.131.252.160",
      username: "root",
      password: "root",
      database: "travistorrent",
      encoding: "utf8mb4",
      collation: "utf8mb4_bin",
      pool:500
  )
  serialize :filpath, Array
  #serialize :gradle_slice, Array
  #serialize :maven_warning_slice, Array
end