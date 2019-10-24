require File.expand_path('../../lib/all_repo_data_virtual_prior_merge.rb',__FILE__)
require File.expand_path('../../lib/filemodif_info.rb',__FILE__)
require File.expand_path('../../lib/file_path.rb',__FILE__)
require File.expand_path('../../lib/maven_error.rb',__FILE__)
require File.expand_path('../../lib/cll_prevpass.rb',__FILE__)
require 'thread'
require 'activerecord-import'
module ErrorModified
    @thread_num=20 

def self.do_matchfile(file_arry,commit)
    File_path.where("last_build_commit=? and error_modified=0",commit).find_each do |item|
        modif_num=0
        
        #filpath=item.filpath-[" ","","\\n"]
        if !item.filpath.empty? and !file_arry.empty?
            
            for tmps in item.filpath do
                for value in file_arry do
                    
                    if tmps!='' and value!=''
                    #puts "value.class:#{value.class}"
                        if tmps.include? value or value.include? tmps
                            item.error_modified=1
                            modif_num+=1
                            break
                        end
                    end
                end 
            end
            if modif_num>0
                puts "=========#{modif_num}"
            item.modif_num=modif_num
            end
            item.save
        end
    end
        
    
end

def self.init_parse_maven
    @inqueue = SizedQueue.new(@thread_num)
    threads=[]
    @thread_num.times do 
            thread = Thread.new do
                loop do
                info = @inqueue.deq
                break if info == :END_OF_WORK
                do_matchfile info[0],info[1]
                
                
                end
            end
                threads << thread
            end
    
            threads
    
end
def self.update_errormodifiled(user,repo)
    ActiveRecord::Base.clear_active_connections!
    Thread.abort_on_exception = true
    threads=init_parse_maven 
    id_arry=[]
    Maven_error.where("repo_name=?","#{user}@#{repo}").group("all_repo_data_virtual_id").find_each do |info|
        id_arry << info.all_repo_data_virtual_id

    end
    
    for id in id_arry do
        a=[]
        Maven_error.where("all_repo_data_virtual_id=?",id).find_each do |info|
            a=a|info.error_file
            
        end
        a
        
        All_repo_data_virtual.where("id=?",id).find_each do |item|
            
            @inqueue.enq [a,item.commit]
        end
        
        
    end
    
    @thread_num.times do
        @inqueue.enq :END_OF_WORK
    end
       
    threads.each {|t| t.join}
    puts "errormodifiledUpdate Over" 
    ActiveRecord::Base.clear_active_connections! 
    return
    
end

def self.error_type(user,repo)
    ActiveRecord::Base.clear_active_connections!
    Thread.abort_on_exception = true
    threads=init_error_type 
    id_arry=[]
    Maven_error.where("repo_name=?","#{user}@#{repo}").group("all_repo_data_virtual_id").find_each do |info|
        id_arry << info.all_repo_data_virtual_id

    end
    
    for id in id_arry do
        a=[]
        Maven_error.where("all_repo_data_virtual_id=?",id).find_each do |info|
            a << info.error_type
            
        end
        a.uniq!
        a=a.reject{|x| x==nil or x==''}
        a=a.join("")
        
        All_repo_data_virtual.where("id=?",id).find_each do |item|
            
            @inqueue.enq [a,item.commit]
        end
        
        
    end
    
    @thread_num.times do
        @inqueue.enq :END_OF_WORK
    end
       
    threads.each {|t| t.join}
    puts "error_typeUpdate Over" 
    ActiveRecord::Base.clear_active_connections!
    return 
    
    
end

def self.init_error_type
    @inqueue = SizedQueue.new(@thread_num)
    threads=[]
    @thread_num.times do 
            thread = Thread.new do
                loop do
                info = @inqueue.deq
                break if info == :END_OF_WORK
                All_repo_data_virtual_prior_merge.where("last_build_commit=?",info[1]).find_each do |item|
                        item.error_type=info[0]
                        item.save

                end
                
                
                end
            end
                threads << thread
            end
    
            threads    
end

def self.prev_matchfile(file_arry,filpath,last_commit=0,now_commit=0)
    
   
        modif_num=0
        
        #filpath=item.filpath-[" ","","\\n"]
        if !file_arry.empty? and !filpath.empty?
            
            for tmps in file_arry do
                
                
                #puts "tmps.class:#{tmps.class}"
                for value in filpath do
                    
                    
                    #puts "value.class:#{value.class}"
                    if tmps.include? value or value.include? tmps
                       # item.error_modified=1
                        modif_num+=1
                        #puts "modif_num: #{modif_num}"
                        break
                    end
                end 
            end
            if modif_num>0
                puts "=========#{modif_num}"
                if now_commit!=0
                    All_repo_data_virtual_prior_merge.where("last_build_commit=? and repo_name=?",commit,"#{@user}@#{@repo}").find_each do |info|

                        info.prev_modified=modif_num
                        info.save
                    end
                else
                    
                end
            end
            #item.save
        end
    
        
    
end

def self.init_prev_passmodified
    @inqueue = SizedQueue.new(@thread_num)
    threads=[]
    #@thread_num.times do 
            thread = Thread.new do
                loop do
                info = @inqueue.deq
                break if info == :END_OF_WORK
                prev_matchfile info[0],info[1],info[2]
                
                
                end
            #end
                threads << thread
            end
    
            threads
    
end

def self.prev_passmodified(user,repo)
    ActiveRecord::Base.clear_active_connections!
    Thread.abort_on_exception = true
    @user=user
    @repo=repo
    threads=init_prev_passmodified 
    id_arry=[]
    Maven_error.where("repo_name=?","#{user}@#{repo}").group("all_repo_data_virtual_id").find_each do |info|
        id_arry << info.all_repo_data_virtual_id

    end
    
    for id in id_arry do
        a=[]
        Maven_error.where("all_repo_data_virtual_id=?",id).find_each do |info|
            a=a|info.error_file
            
        end
        a
        
        all_repo=All_repo_data_virtual.where("id=?",id).first
        b=[]
        Cll_prevpassed.where("git_commit=?",all_repo.commit).find_each do |item|
            b=b|item.filpath
            
            
        end
        b
        @inqueue.enq [a,b,all_repo.commit]
        
    end
    
    @thread_num.times do
        @inqueue.enq :END_OF_WORK
    end
       
    threads.each {|t| t.join}
    puts "errormodifiledUpdate Over"  
    return
    
end
#=========================================

def self.init_prev_passmodified
    @inqueue = SizedQueue.new(@thread_num)
    threads=[]
    #@thread_num.times do 
            thread = Thread.new do
                loop do
                info = @inqueue.deq
                break if info == :END_OF_WORK
                prev_matchfile info[0],info[1]
                
                
                end
            #end
                threads << thread
            end
    
            threads
    
end


def self.prev_pass_now_modified(user,repo)#前一次成功到last和last到这一次build之间的文件是否重合
    ActiveRecord::Base.clear_active_connections!
    Thread.abort_on_exception = true
    @user=user
    @repo=repo
    threads=init_prev_pass_now 
    id_arry=[]
    File_path.where("repo_name=?","#{user}@#{repo}").find_each do |info|
        id_arry << info.last_build_commit

    end
    id_arry.uniq!
    for last_commit in id_arry do
        b=[]
        
        Cll_prevpassed.where("git_commit=?",last_commit).find_each do |item|
            b=b|item.filpath   #获取failed的build到上一次pass之间的修改文件名        
            
        end
        b
        File_path.where("last_build_commit_= ?",last_commit).find_each do |info|
            @inqueue.enq [info.filpath,b,id,last_commit,info.now_commit]
    
        end
        @inqueue.enq [b,id]    
    end
    @thread_num.times do
        @inqueue.enq :END_OF_WORK
    end
       
    threads.each {|t| t.join}
    puts "pass_nowUpdate Over"  
    return
    
end

end
user=ARGV[0]
repo=ARGV[1]
#ErrorModified.update_errormodifiled(user,repo)
# a=[1,2,3]
# b=''
# a=a.join("")
# puts a

# puts a.class
