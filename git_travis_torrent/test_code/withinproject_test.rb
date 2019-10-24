require 'json'
require 'open-uri'
require 'net/http'
require 'fileutils'
require 'time_difference'
require 'activerecord-import'
require 'travis'
require 'rugged'
require 'travis'
require 'date'


require File.expand_path('../../lib/travis_torrent.rb',__FILE__)
require File.expand_path('../../lib/within_filepath.rb',__FILE__)
require File.expand_path('../../lib/travistorrents.rb',__FILE__)
require File.expand_path('../../lib/job.rb',__FILE__)
require File.expand_path('../../bin/download_job.rb',__FILE__)
require File.expand_path('../../bin/diff_within.rb',__FILE__)
require File.expand_path('../../lib/all_repo_data_virtual_prior_merge.rb',__FILE__) 

require File.expand_path('../../lib/all_repo_data_virtual.rb',__FILE__)
module WithinProjectstest
def self.init_getable
    @inqueue = SizedQueue.new(30)
    threads=[]
            30.times do 
            thread = Thread.new do
                loop do
                info = @inqueue.deq
                break if info == :END_OF_WORK
                item=Withinproject.find_by_sql("select tr_status,job_status,bl_cluster from withinprojects where git_commit='#{info.pre_builtcommit}' group by bl_cluster")
                #item=Withinproject.where("git_commit=?",info.pre_builtcommit).group("bl_cluster").count
                first_item=Withinproject.where("git_commit=?",info.pre_builtcommit).group("bl_cluster").first
                puts item
                num = item.count
                next if item.nil?
                    if first_item.tr_status=='passed'
                        info.prev_tr_status=1
                    else
                        info.prev_tr_status=0
                    end     
                    # num=item.count.each_value.first
                    puts "num:#{num}"
                    cluster=0
                    if num>1#有多条记录也就是一个Build有多个job，可能对应多个cluster
                        puts "前一次build有多条job"
                        item.find_all do |tmp|
                            if !tmp.bl_cluster.nil?
                                cluster+=tmp.bl_cluster.delete('mvncl').to_i
                            end
                                

                        end
                    else
                        puts " 前一次是pass，所以cluster是null"
                        if item.first.bl_cluster.nil? and item.first.tr_status=='passed'
                            cluster=-1
                        elsif item.first.bl_cluster.nil? and item.first.tr_status !='passed'
                            cluster=nil
                        else
                            cluster+=item.first.bl_cluster.delete('mvncl').to_i
                        end
                        
                    end
                    puts "cluster #{cluster}"
                    if ！cluster.nil?
                        cluster=cluster+num*(10**cluster.to_s.size)
                        puts "cluster with lenghten#{cluster}"
                    end
                    #info.prev_bl_cluster=item.bl_cluster.delete('mvncl').to_i
                    # info.prev_gh_src_churn=item.gh_src_churn
                    # info.prev_gh_test_churn=item.gh_test_churn
                    # info.save
                  
                    ActiveRecord::Base.clear_active_connections!
                
                
                end
            end
                threads << thread
            end
    
            threads
    
end


def self.get_table(repo_name)
    Thread.abort_on_exception = true
    threads=init_getable 
    Withinproject.where("gh_project_name=? and tr_build_id=71315172",repo_name).find_each do |info|

        @inqueue.enq info
        
    break 
    end
    30.times do
        @inqueue.enq :END_OF_WORK
    end
       
    threads.each {|t| t.join}
    puts "Update Over"  
    ActiveRecord::Base.clear_active_connections!
    return
end


def self.test(repo_name)
    a=nil
    cluster=0
    # m=a.delete('mvncl').to_i
    # cluster+=m
    puts cluster
    Withinproject.where("gh_project_name=? and tr_build_id=71315172",repo_name).find_each do |info|
        puts info.gh_first_commit_created_at
        puts info.gh_first_commit_created_at.class
        puts info.gh_first_commit_created_at.wday
        
    break 
    end
    # get_table(repo_name)
    
end
end
owner = ARGV[0]
repo = ARGV[1]
#test("#{owner}/#{repo}")
WithinProjectstest.test("#{owner}/#{repo}")