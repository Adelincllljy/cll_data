require 'active_record' 


class Repo_data_travi< ActiveRecord::Base
    establish_connection(   
    adapter:  "mysql2",
    host:     "10.141.221.85",
    username: "root",
    password: "root",
    database: "cll_data",  
    encoding: "utf8mb4",
    collation: "utf8mb4_unicode_ci",
    pool:200
)
serialize :jobs, Array
#set_table_name 'all_repo_data_virtual_prior_merges' 
end


 
