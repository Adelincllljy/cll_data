require 'active_record' 


class Build_number< ActiveRecord::Base
    establish_connection(   
    adapter:  "mysql2",
    host:     "10.141.221.85",
    username: "root",
    password: "root",
    database: "cll_data",  
    encoding: "utf8mb4",
    collation: "utf8mb4_bin",
    pool: 200
)


#set_table_name 'all_repo_data_virtual_prior_merges' 
end