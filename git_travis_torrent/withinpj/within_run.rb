require File.expand_path('../weekday.rb',__FILE__)

def run(repo_name)
    user=repo_name.split('/').first
    repo=repo_name.split('/').last
   
    # get_allpj
    # update_prev_startime(repo_name)
    # update_fixprevstartime(repo_name)
    # # update_timediff(repo_name)
     
    # #update_fail_build_rate(repo_name)
    # #fix_trstatus(repo_name)
    # prev_builtcommit(repo_name)
    # update_job_number(repo_name)
    # #save_maven_errors
    # #DiffWithin.test_diff(user,repo,0,0,0)
    # get_table(repo_name)
    WeekDay.weekday(repo_name)
    #parse_maven_error_file(repo_name)
    # update_errormodifiled(repo_name)
    
    # prev_pass(repo_name)
    
    #update_fail_build_rate(repo_name)
end




def method_name
    #run 'structr/structr'

    i=0
    #name_arry=['facebook/presto','Jasig/cas','jsprit/jsprit','lemire/RoaringBitmap']
    parent_dir = File.expand_path('../../repo_name.txt',__FILE__)
    repo_name=IO.readlines(parent_dir)
    i=0
    repo_name.each do |line|
        line = JSON.parse(line)
        puts line
        ActiveRecord::Base.clear_active_connections!
        if i>=0
        # process(line.split('/').first,line.split('/').last)
        #commitinfo(@user,@repo)
        
        run line
        i+=1
        

        
        else 
        i+=1
        end
    end
    
end

method_name