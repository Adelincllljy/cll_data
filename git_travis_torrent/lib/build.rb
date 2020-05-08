require 'active_record'
#require 'activerecord-jdbcmysql-adapter'
class Build < ActiveRecord::Base
  establish_connection(
      adapter:  "mysql2",
      host:     "10.131.252.160",
      username: "root",
      password: "root",
      database: "zc",
      encoding: "utf8mb4",
      collation: "utf8mb4_bin",
      pool:300
  )

end
 
# info=Travistorrent_822017_alldatas.where("tr_build_id=10606").first
    
# if !info.nil?
#     puts info.tr_build_id
#     puts "yes"
# end
