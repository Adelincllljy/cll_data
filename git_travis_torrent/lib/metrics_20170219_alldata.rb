require 'active_record'
#require 'activerecord-jdbcmysql-adapter'
class Metrics_20170219_alldatas < ActiveRecord::Base
  establish_connection(
      adapter:  "mysql2",
      host:     "10.141.221.85",
      username: "root",
      password: "root",
      database: "cll_data",
      encoding: "utf8mb4",
      collation: "utf8mb4_unicode_ci",
      pool:300
  )
  
end