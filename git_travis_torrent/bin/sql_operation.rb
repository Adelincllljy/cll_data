#puts File.expand_path('../../fix_sql.rb',__FILE__)
require File.expand_path('../../fix_sql.rb',__FILE__)
require File.expand_path('../parse_error_file.rb',__FILE__)
require File.expand_path('../error_modified.rb',__FILE__)
require File.expand_path('../maven_compilation.rb',__FILE__)
require File.expand_path('../maven_test.rb',__FILE__)
require File.expand_path('../commit_info_file.rb',__FILE__)
# require File.expand_path('../diff_test.rb',__FILE__)
require File.expand_path('../../lib/all_repo_data_virtual_prior_merge.rb',__FILE__)
require File.expand_path('../../add_previnfo.rb',__FILE__)
# require File.expand_path('../prev_pass.rb',__FILE__)
def run(user=0,repo=0) 
    # DiffTest.test_diff(user,repo)
    # FixSql.update_now_build_status2(user,repo)#now_status
    # FixSql.delete_canceled
    
    # FixSql.update_last_build_status(user,repo)#now_build_id
    # FixSql.delete_null(user,repo)
    # FixSql.merge_processdup(user,repo)##now_build_id,commit_size,last_build_commit都重复
    
    
    # FixSql.update_now_label(user,repo)
    
    # FixSql.update_fail_build_rate(user,repo)
    # FixSql.update_now_startime(user,repo)
    # FixSql.update_timediff(user,repo) 
    # FixSql.update_job_number(user,repo)
    # FixSql.update_prevchurn(user,repo)  
    # # MavenCompilation.save_maven_errors(user,repo) 
    # # ParseErroFile.parse_maven_error_file(user,repo)#正则提取出错误的文件名
    # # ParseErroFile.fixparse_maven_error_file(user,repo)#查漏补缺，前一次提取文件名漏掉的

    # ErrorModified.update_errormodifiled(user,repo)
    # ErrorModified.update_errornum(user,repo)
    # ErrorModified.error_type(user,repo)
    # FixSql.update_errtypeforpass(user,repo)
    # FixSql.update_srcmodified(user,repo)
    # PrevPass.cll_prevpass(user,repo)
    # PrevPass.prev_diff(user,repo)
    # ErrorModified.prev_passmodified(user,repo)
    # FixSql.update_weekday(user,repo)
    # FixSql.upadate_newlabel(user,repo)
    # FixSql.update_teamsize(user,repo)
    # FixSql.update_errormodif(user,repo)
    # FixSql.update_nowduration(user,repo)
    # FixSql.fixmerge_commit(user,repo)
      #build_state_threads(line.split('/').first,line.split('/').last)
      # AddPrevinfo.add_prev_info(user,repo)
      ModuleName.insert_commit(user,repo)




    # FixSql.update_job_state(user,repo)#no
    #FixSql.diff_build_type#不需要
    #FixSql.update_last_label(user,repo)#no
    #FixSql.father_id(user,repo)
    #FixSql.update_now_build_commit#这个后面不需要补充 了,在diff_test代码里直接把now_build_commit加上了
    #FixSql.update_file_moidfied#这个后面不需要补充了,在diff_test代码里直接把now_build_commit加上了
    

    # MavenTest.save_maven_errors(user,repo)#不需要了
    
    #FixSql.test_diff(user,repo)#后面不需要补充了,在diff_test中已经把提取文件名的代码优化了
    
    #FixSql.update_commit_size#后面不需要补充已经在diff_test中加上去了
    #FixSql.update_last_label(user,repo)#在diff_test中补充了,不需要再加进去
    #FixSql.update_type_error(user,repo)#不需要已经在mavencompilation中使用

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
  # parent_dir = File.expand_path('../../new_reponame.txt',__FILE__)
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
        
        end
        i=i+1
        #   i+=1
        #break
        #  
        

       
       
    end
end
method_name
  
  #run(owner,repo)

  #SELECT last_label,filesmodified,line_added,line_deleted,src_modified,num_author,failed_build_rate,time_diff,now_label FROM cll_data.all_repo_data_virtual_prior_merges where repo_name='UniversalMediaServer@UniversalMediaServer' order by build_id asc;