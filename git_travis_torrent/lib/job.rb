require 'active_record' 


class Job< ActiveRecord::Base
    establish_connection(   
    adapter:  "mysql2",
    host:     "10.131.252.160",
    username: "root",
    password: "root",
    database: "zc",  
    encoding: "utf8mb4", 
    collation: "utf8mb4_bin",
    pool:200
)

#set_table_name 'all_repo_data_virtual_prior_merges' 
end