#puts File.expand_path('../../fix_sql.rb',__FILE__)
require File.expand_path('../../fix_sql.rb',__FILE__)
require File.expand_path('../parse_error_file.rb',__FILE__)
require File.expand_path('../error_modified.rb',__FILE__)
require File.expand_path('../maven_compilation.rb',__FILE__)
require File.expand_path('../maven_test.rb',__FILE__)
require File.expand_path('../diff_test.rb',__FILE__)
require File.expand_path('../../lib/all_repo_data_virtual_prior_merge.rb',__FILE__)
require File.expand_path('../prev_pass.rb',__FILE__)
def run(user=0,repo=0) 
    # DiffTest.test_diff(user,repo)
    # FixSql.delete_canceled
    #FixSql.merge_processdup(user,repo)
    # FixSql.update_last_build_status(user,repo)#now_build_id
    # FixSql.update_now_build_status2(user,repo)#now_status
    # FixSql.update_now_label(user,repo)
    
    # FixSql.update_fail_build_rate(user,repo)
    # FixSql.update_now_startime(user,repo)
    # FixSql.update_timediff(user,repo) 
    #  FixSql.update_job_number(user,repo)
    #FixSql.update_prevchurn(user,repo)
    # #  MavenCompilation.save_maven_errors(user,repo)
   
    # #  ParseErroFile.parse_maven_error_file(user,repo)#正则提取出错误的文件名
    #    ErrorModified.update_errormodifiled(user,repo)
    #     ErrorModified.error_type(user,repo)
    #     FixSql.update_errtypeforpass(user,repo)
    # FixSql.update_srcmodified(user,repo)
    FixSql.update_teamsize(user,repo)
    #FixSql.update_bl_cluster(user,repo)
    # PrevPass.cll_prevpass(user,repo)
    # PrevPass.prev_diff(user,repo)
    # ErrorModified.prev_passmodified(user,repo)

      #build_state_threads(line.split('/').first,line.split('/').last)
      
    

end
def write_file_add(contents,parent_dir)
  #json_file = File.join(parent_dir, filename)
  if contents.class == Array
    
      contents.flatten!
  # Remove empty entries
      contents.reject! { |c| c.empty? }
  end
  if File.exists? parent_dir
    #puts "all_commit:#{all_commits}"
    
  
    
  # Remove empty entries
    
    #puts "initial builds size #{contents.size}"
    if contents.empty?
      error_message = "Error could not get any repo information for #{parent_dir}."
      puts error_message    
      exit(1)
    end
  
    File.open(parent_dir, 'a') do |f|
    f.puts(JSON.dump(contents)) 
    end
  
  else
    File.open(parent_dir, 'a') do |f|
    f.puts JSON.dump(contents)
    end
  end

    
end

def method_name
  parent_dir = File.expand_path('../../repo_name.txt',__FILE__)
    repo_name=IO.readlines(parent_dir)
    i=0
    repo_name.each do |line|
        line = JSON.parse(line)
        ActiveRecord::Base.clear_active_connections!
        puts line
        user=line.split('/').first
        repo=line.split('/').last
        # parent_dir = File.join('build_logs/',  "#{user}@#{repo}")
        # new_dir=File.join('commits/',"sql.txt")
        # # if i>=0
        # # process(line.split('/').first,line.split('/').last)
        # #commitinfo(@user,@repo)
        
        if i>=0
           run(user,repo)
           #break
        end
        i=i+1
        #   i+=1
        #break
        #  
        

       
       
    end
end
method_name
  
 