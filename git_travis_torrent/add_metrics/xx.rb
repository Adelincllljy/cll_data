require 'time'
require 'linguist'
require 'thread'
require 'rugged'
require 'json'
require 'fileutils'
require 'open-uri'
require 'net/http'
require 'activerecord-import'

require_relative 'java'
#require File.expand_path('../small_test.rb',__FILE__)
require File.expand_path('../../lib/all_repo_data_virtual_prior_merge.rb',__FILE__)
require File.expand_path('../../lib/filemodif_info.rb',__FILE__)
require File.expand_path('../../lib/file_path.rb',__FILE__)
require File.expand_path('../../lib/cll_prevpass.rb',__FILE__)
require File.expand_path('../../bin/parse_html.rb',__FILE__)
require File.expand_path('../../lib/all_repo_data_virtual.rb',__FILE__)
require File.expand_path('../../lib/commit_info.rb',__FILE__)
require File.expand_path('../../lib/build_number.rb',__FILE__)
require File.expand_path('../../lib/build.rb',__FILE__)
require File.expand_path('../../sola/get_modifiedlines.rb',__FILE__)
require File.expand_path('../../lib/repo_data_travis.rb',__FILE__)

class ClassName
    

def initialize(user,repo)
    @user=user
    @repo=repo
    @thread_number = 30
    build_id_arry=[]
    
end



def indexs
    Thread.abort_on_exception = true
    threads = init_indexs
    All_repo_data_virtual_prior_merge.where("now_build_id=? and repo_name=? ",3896217 ,"#{@user}@#{@repo}").find_each do |info|
        
            
        @queue.enq info
    end
    @thread_number.times do   
    @queue.enq :END_OF_WORK
    end
    threads.each {|t| t.join}
    puts "fail_build_rateUpdate Over=========="
    return 
    
end

def init_indexs
    @queue=SizedQueue.new(@thread_number)
    threads=[]
    @thread_number.times do 
        thread = Thread.new do
        loop do
            info = @queue.deq
            break if info == :END_OF_WORK
            build_number_arry=[]
            m=Math::sqrt(2*Math::PI)
            p m
            alp_f=3
            guasian=0
            p info.build_number
            All_repo_data_virtual_prior_merge.where("now_build_id< ? and repo_name=? and status in ('errored','failed')",info[:now_build_id],"#{@user}@#{@repo}").find_all  do|item|
            
            f=info.build_number-item.build_number
            p f
            p -f*f
            p (-169/18)
            n= Float((-f*f))/Float((2*alp_f*alp_f))
            p n
             x=Math::exp(n)
             p x
            guasian = guasian+(1/(m*alp_f))*x
            
            
           
            
            end
            p guasian
            ActiveRecord::Base.clear_active_connections!
            end
        end
        threads << thread
        end

    threads

end
end
cn=ClassName.new('structr','structr')
cn.indexs