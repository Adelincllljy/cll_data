require 'active_record' 


class Commit_info < ActiveRecord::Base
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
serialize :commit_parents, Array
#set_table_name 'all_repo_data_virtual_prior_merges' 
end
# Commit_info.where("close_fixed_resolved=?",'').find_each do |commit|
    
#      commit[:close_fixed_resolved]=nil
#      commit.save
        
# end