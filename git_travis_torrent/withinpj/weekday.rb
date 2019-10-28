require 'json'
require 'open-uri'
require 'net/http'
require 'fileutils'
require 'time_difference'
require 'activerecord-import'
require 'travis'
require 'rugged'
require 'travis'



require File.expand_path('../../lib/travis_torrent.rb',__FILE__)
require File.expand_path('../../lib/within_filepath.rb',__FILE__)
require File.expand_path('../../lib/travistorrents.rb',__FILE__)
require File.expand_path('../../lib/job.rb',__FILE__)
require File.expand_path('../../bin/download_job.rb',__FILE__)
require File.expand_path('../../bin/diff_within.rb',__FILE__)
require File.expand_path('../../lib/all_repo_data_virtual_prior_merge.rb',__FILE__) 

require File.expand_path('../../lib/all_repo_data_virtual.rb',__FILE__)
MAVEN_ERROR_FLAG = /COMPILATION ERROR/
module WeekDay
    @thread_num=50
    def self.init_week_day
        @queue = SizedQueue.new(@thread_num)
        threads=[]
                @thread_num.times do 
                thread = Thread.new do
                    loop do
                    info = @queue.deq
                    break if info == :END_OF_WORK
                    puts info.gh_first_commit_created_at
                    puts "weekday：#{info.gh_first_commit_created_at.wday}"
                    info.weekday=info.gh_first_commit_created_at.wday
                    info.save
                    puts "==="
                    # puts "========="
                    # Withinproject.import builds,validate: false
                    ActiveRecord::Base.clear_active_connections!
                    end
                end
                    threads << thread
                end
        
                threads
        
    end
     
    def self.weekday(repo_name)
        Thread.abort_on_exception = true
        threads = init_week_day
        puts "here"
        Withinproject.where("id>? and gh_project_name=? and id=35",0,repo_name).find_each do |info|
            puts info.id
       
            @queue.enq info
        end
        @thread_num.times do   
        @queue.enq :END_OF_WORK
        end
        threads.each {|t| t.join}
        puts "weekdayUpdate Over"
        
    end

    

end