require 'active_record' 


class All_repo_data_virtual< ActiveRecord::Base
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
serialize :jobs_arry, Array
serialize :jobs_state, Array
has_many :maven_errors
end
 
#puts All_repo_data_virtual.where("repo_name=?","UniversalMediaServer@UniversalMediaServer").group(:commit,:branch).count(:commit)
#puts All_repo_data_virtual.find_by_sql("SELECT * FROM all_repo_data_virtuals where repo_name='UniversalMediaServer@UniversalMediaServer' group by commit,branch  having count(*)>1 order by commit asc").count