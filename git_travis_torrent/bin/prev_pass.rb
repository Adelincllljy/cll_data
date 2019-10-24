
require 'tree' 
require File.expand_path('../../lib/travis_torrent.rb',__FILE__)
require File.expand_path('../../lib/within_filepath.rb',__FILE__)

require File.expand_path('../../lib/job.rb',__FILE__)
require File.expand_path('../../lib/pre_pass.rb',__FILE__)
require File.expand_path('../../lib/cll_prevpass.rb',__FILE__)
require File.expand_path('../../lib/cll_prevpasscommit.rb',__FILE__)

require File.expand_path('../download_job.rb',__FILE__)
require File.expand_path('../diff_within.rb',__FILE__)
require File.expand_path('../diff_test.rb',__FILE__)
require File.expand_path('../diff_prev.rb',__FILE__)

require File.expand_path('../../lib/all_repo_data_virtual_prior_merge.rb',__FILE__) 
require 'activerecord-import'
require 'thread'
class PrevPass
    @thread_num=20 
    def initialize
        
    end
    def self.init_dodiff
        @inqueue = SizedQueue.new(@thread_num)
        threads=[]
                @thread_num.times do 
                thread = Thread.new do
                    loop do
                    info = @inqueue.deq
                    break if info == :END_OF_WORK
                    DiffWithin.test_diff(info[0],info[1],info[2],info[3],info[4])
                    end
                end
                    threads << thread
                end
        
                threads
    end
    def self.find_last_pass(root,type)
        # puts "begin processing"
        #root.print_tree
        recurflag=0
        #puts "root.each_leaf #{root.each_leaf.class}"
        tmp_lefarry=[]
        
        tmp_lefarry=root.each_leaf
        tmp_lefarry.each do |leaf|
            #puts "root.each_leaf.size #{root.each_leaf.size}"
            # puts "i:===#{i}"
            #puts "leaf.name #{leaf.name}"
            # root.print_tree
            # i=i+1
            flag=0
            #puts leaf.content
            if root.name!=leaf.name#处理叶子节点和跟节点一样的情况,防止无线循环
                # puts "处理leaf"
                unless leaf.content.nil? 
                    if leaf.content.last==1
                        # puts "已经找到前一次pass"
                        next
                    end
                    if leaf.content.first.status=='passed'
                        flag=1
                        leaf.content << flag
                        next
                    else
                        
                        if leaf.content.last!=0
                            # puts"叶子还是fail"
                            leaf.content << flag 
                        end 
                        batchs=All_repo_data_virtual_prior_merge.where("build_id<? and repo_name=?",leaf.content.first.build_id,leaf.content.first.repo_name).all
                        # puts "batchs"
                        if batchs.where("now_build_commit=? and repo_name=?",leaf.name,leaf.content.first.repo_name).count>0
                            recurflag=1
                            batchs.where("now_build_commit=? and repo_name=?",leaf.name,leaf.content.first.repo_name).group("last_build_commit").find_each do |all_repo|
                                    
                            
                                leaf << Tree::TreeNode.new(all_repo.last_build_commit,[all_repo] )
                                #puts "all_repo.last_build_commit #{all_repo.last_build_commit}"   
                            end
                        
                        end
                    end
                end
            end
        end
        if recurflag==1
            
            arry1=[]
            arry1=root.each_leaf
            # puts "递归 =================="
            #sleep 2000
            root.remove_all!
            arry1=arry1.group_by { |x| x.name }.map { |k, v| v[0] }
            arry1.each do |leaf|

                root.add(leaf)
                # root_node << Tree::TreeNode.new(n[i],m[i])
                # puts root_node.each_leaf.size
                # i=i+1
                
            end
            find_last_pass(root,type)
        else
        #Thread.abort_on_exception = true
            
        #threads=init_dodiff
        # puts "放入数据库"
        # sleep 20000
        leaf_arry=[]
        root.each_leaf do |leaf|
            
            unless leaf.content.nil?
                if leaf.content.last==1 
                    leaf_arry << leaf.name    
                end
                
            end
        end
        leaf_arry.uniq!
        #puts "leaf_arry#{leaf_arry}"
        #sleep 2000
                if type=='within'
                    # leaf_arry.each do |last_pass|
                       # @inqueue.enq [@user,@repo,last_pass,root.name,2]
                       
                       cll_prevpasscommits
                        DiffPrev.test_diff(@user,@repo,leaf_arry,root.name,2,type)

                    # end
                else
                    # leaf_arry.each do |last_pass|
                        #@inqueue.enq [@user,@repo,leaf.name,root.name,2]
                        # for item in leaf_arry do 


                        #     puts item
                        #     puts item.class
                        # end
                        
                        # puts "#{@user}"
                        # puts root.name
                        # mutex = Mutex.new
                        # mutex.lock
                        if !(leaf_arry.empty? or leaf_arry.nil?)
                            acc={:repo_name=>@user+'@'+@repo,:git_commit=>root.name,:prev_passcommits=>leaf_arry}
                            record=Cll_prevpasscommit.new(acc)
                            record.save
                             #ActiveRecord::Base.clear_active_connections!
                        end
                        # mutex.unlock
                        #
                        #DiffPrev.test_diff(@user,@repo,leaf_arry,root.name,2,type)
                    # end
                end
        end

        # @thread_num.times do   
        # @inqueue.enq :END_OF_WORK
        # end
        # threads.each {|t| t.join}
        # puts "TODIFFUpdate Over"
    end
    def self.init_prev_pass
        @queue = SizedQueue.new(@thread_num)
        threads=[]
        mutex = Mutex.new
        puts "in prev"
        @thread_num.times do
                thread = Thread.new do
                    loop do
                    info = @queue.deq
                    break if info == :END_OF_WORK
                    # builds=[]
                    # items=[]
                    #puts "#{@user}@#{@repo}"
                    # if info[1]=='wihtin'
                    #     if Prev_passed.where("git_commit=?",info[0]).count>0
                    #         next
                    #     end
                    # else
                        
                    #     if Cll_prevpasscommit.where("git_commit=?",info[0]).count>0
                    #         puts "next"
                    #         next
                            
                    #     end
                    # end
                    #@thread_num.times do 
                    #mutex.lock
                    root_node=Tree::TreeNode.new(info[0])
                    All_repo_data_virtual_prior_merge.where("now_build_commit=? and repo_name=?",info[0],"#{@user}@#{@repo}").group("last_build_commit").find_each do |all_repo|
                        #info.pre_builtcommit
                        #puts "all_rpeo.id#{all_repo.id}"
                        #puts "all_repo.last_build_commit #{all_repo.last_build_commit}"
                        root_node << Tree::TreeNode.new(all_repo.last_build_commit,[all_repo])
                        
                    end
                    
                       #@queue2.enq [root_node,info[1]]
                    #root_node.print_tree
                    #puts root_node
                    find_last_pass(root_node,info[1])
                    #mutex.unlock
                    
                    
                    # puts "========="
                    # Withinproject.import builds,validate: false
                    
                    end
                end
                    threads << thread
                end
        
                threads 
        
    end
    

    def self.cll_prevpass(user,repo)
        #ActiveRecord::Base.clear_active_connections!
        @user=user
        @repo=repo
        Thread.abort_on_exception = true
        all_repo_data_virtualarry=[]
        cll_prevpassarry=[]
       
        All_repo_data_virtual.where("id>? and repo_name=? and status  in ('errored','failed')",0,"#{user}@#{repo}").group("commit").find_each do |info|
            all_repo_data_virtualarry<< info.commit
        #Withinproject.where("pre_builtcommit=?","f20692facf4c00bcafc26908fb51bde98ab45562").find_each do |info|
        end
        Cll_prevpasscommit.where("repo_name=?","#{user}@#{repo}").find_each do |item|
            cll_prevpassarry << item.git_commit
        end
        tmp=all_repo_data_virtualarry-cll_prevpassarry
        puts "tmp #{tmp.size}"
        threads = init_prev_pass
        #@queue.enq ['8d71c34f73be60d97f1a85063b447012c8f44517','cll']#测试有merge的情况是导致last_build_commit的build时间时间晚于now_build_commit,且build_id>now_build,这种情况就没有把这个父commit加进去
        for commit in tmp do
          @queue.enq [commit,'cll']
       
        end
        @thread_num.times do   
        @queue.enq :END_OF_WORK
        end
        threads.each {|t| t.join}
        puts "TreeUpdate Over"
        ActiveRecord::Base.clear_active_connections!
        return
        #threads.each {|t| puts t.status}
        
    end

    def self.prev_diff(user,repo)
        @user=user
        @repo=repo
        Thread.abort_on_exception = true
        threads = init_prevdiff
        Cll_prevpasscommit.where("repo_name=?","#{user}@#{repo}").find_all do |info|
            @inqueue.enq info

        end
        @thread_num.times do   
            @inqueue.enq :END_OF_WORK
            end
            threads.each {|t| t.join}
            #threads.each {|t| puts t.status}
            puts "PathUpdate Over"
            ActiveRecord::Base.clear_active_connections!
            #ActiveRecord::Base.connection.close
            #threads.each {|t| puts t.status}
            return
    end
     
    def self.init_prevdiff
        @inqueue=SizedQueue.new(@thread_num)
        threads=[]
        #@thread_num.times do 
          thread = Thread.new do
            loop do
              info = @inqueue.deq
              break if info == :END_OF_WORK
              if Cll_prevpassed.where("git_commit=?",info.git_commit).count>0
                next
              end
              DiffPrev.test_diff(@user,@repo,info.prev_passcommits,info.git_commit,2,'cll')
             
              
            #end
          end
          threads << thread
        end
      
        threads
      end  
      
    
    def self.prev_pass(repo_name)
        #ActiveRecord::Base.clear_active_connections!
        Thread.abort_on_exception = true
        threads = init_prev_pass
        Withinproject.where("id>? and gh_project_name=? and prev_tr_status=0",0,repo_name).group("pre_builtcommit").find_each do |info|
        
        #Withinproject.where("pre_builtcommit=?","f20692facf4c00bcafc26908fb51bde98ab45562").find_each do |info|
        
        @queue.enq [info.pre_builtcommit,'within']
        end
        @thread_num.times do   
        @queue.enq :END_OF_WORK
        end
        threads.each {|t| t.join}
        #threads.each {|t| puts t.status}
        puts "TreeUpdate Over"
        ActiveRecord::Base.clear_active_connections!
        #ActiveRecord::Base.connection.close
        #threads.each {|t| puts t.status}
        return
        
    end   
    def self.run(flag)
        parent_dir = File.expand_path('../../repo_name.txt',__FILE__)
        repo_name=IO.readlines(parent_dir)
        i=0
        repo_name.each do |line|
            line = JSON.parse(line)
            puts line
            @user = line.split('/').first
            @repo = line.split('/').last
            @parent_dir = File.join('build_logs/',  "#{@user}@#{@repo}")
            #if i>=11
            # process(line.split('/').first,line.split('/').last)
            #commitinfo(@user,@repo)
            ActiveRecord::Base.clear_active_connections!
            if i >=11
                if flag=='within'
                PrevPass.prev_pass(line)
                else
                PrevPass.cll_prevpass(@user,@repo)
                #build_state_threads(line.split('/').first,line.split('/').last)
                end
                i+=1
            else
                i+=1
            end
            
            #else
            #  i+=1
        end
    end
end

#PrevPass.run('within')
