require 'active_record' 


class Maven_error < ActiveRecord::Base
    establish_connection(   
    adapter:  "mysql2",
    host:     "10.141.221.85",
    username: "root",
    password: "root",
    database: "cll_data",  
    encoding: "utf8mb4",
    collation: "utf8mb4_unicode_ci",   
    pool: 200
    
)
serialize :maven_slice, Array
serialize :test_inerror, Array
serialize :fail_test, Array
serialize :error_file, Array

belongs_to :all_repo_data_virtual

#set_table_name 'all_repo_data_virtual_prior_merges' 
end