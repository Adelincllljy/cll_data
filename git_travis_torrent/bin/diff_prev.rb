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
require File.expand_path('../../lib/travis_torrent.rb',__FILE__)
require File.expand_path('../../lib/within_filepath.rb',__FILE__)
require File.expand_path('../../lib/pre_pass.rb',__FILE__)
require File.expand_path('../../lib/tmp_prevpassed.rb',__FILE__)
require File.expand_path('../../lib/cll_prevpass.rb',__FILE__)


require File.expand_path('../parse_html.rb',__FILE__)
#require File.expand_path('../../fix_sql.rb',__FILE__)
@user=ARGV[0]
@repo=ARGV[1]
@out_queue = SizedQueue.new(2000)
$token = [
  "67d9c1839e5d323b5e5375e78c1ae1045acd4e76",#小白
  "eff3fad7c4e987c03faa1b396836190a2cd0fda1",#双双
  "4faaec64a3225ba0635a3bf9956d086da6851cd5",#我
  "14bbbef635caa5f21da2b344c92d82aca9c2e6ed",#xue
  "f853014921d9f44e2027ffc5f1d1a9430564b3a9",#麒麟
  "60908621dd20b8db05803435d6cd6096dfcac5f5",#何川
  "bfcc138aaed1e14c6118abf357b66bf225baf1df",#刘德卫
  "855e1cacc1d020202fe4333c660354d5e848c7fb"#学弟
]
$REQ_LIMIT = 4990
$text_file=["md","doc","docx","txt","csv","json","xlsx","xls","pdf","jpg","ico","png","jpeg","ppt","pptx","tiff","swf"]
$thread_number=40
module DiffPrev
    def self.test_diff(user,repo,last_pass,now_build,lef,type)
        @user=user
        @repo=repo
        @last_pass=last_pass
        checkout_dir =File.expand_path(File.join('..','..','..','sequence', 'repository', user+'@'+ repo),File.dirname(__FILE__)) 
        for lastpass in last_pass do
            
            # if Cll_prevpassed.where("git_commit=? and prev_passcommit=?",now_build,lastpass).count>0
            #   next
            # else
              do_diff(now_build,user,repo,checkout_dir,lastpass,lef,type)
            # end
        end
    
    end

    def self.do_diff(now_build,user,repo,checkout_dir,lastpass,lef,type)
        begin
            from = repos.lookup(now_build)
            to = repos.lookup(lastpass)
            
            state = :none
            #arry= diff.stat#number of filesmodified/added/delete
            
            
            #记录一下两次build修改的文件,key:build_id,value:[filepath]
            temp_filepath=[]
            flag=0
            diff.patch.lines.each do |line|
                if line.start_with? '---' and flag==0
                file_path = line.strip.split('--- ')[1]
                if file_path.nil?
                
                next
                end
                if file_path.strip.split('a/',2)[1].nil?
                    flag=1
                    next
                else
                    temp_filepath<<file_path.strip.split('a/',2)[1]
                end
                
                file_name = File.basename(file_path)#文件名
                #puts file_name
                #file_dir = File.dirname(file_path)#路径/可以用来判断是否是test文件
                next if file_path.nil?
                
                
                    
                end
                if line.start_with? '+++' and flag==1
                file_path = line.strip.split('+++ ')[1]
                if file_path.nil?
                    
                
                next
                end
                if file_path.strip.split('b/',2)[1].nil?
                    flag=0
                    next
                else
                    temp_filepath<<file_path.strip.split('b/',2)[1]
                end
                
                #puts file_path
                file_name = File.basename(file_path)#文件名
                #puts file_name
                #file_dir = File.dirname(file_path)#路径/可以用来判断是否是test文件
                next if file_path.nil?
                
                
                flag=0
                end
        
                
            end
            #puts build[:build_id]
            if type=='cll'
                acc={:repo_name=>@user+'@'+@repo,:git_commit=>now_build,:prev_passcommit=>lastpass,:filpath=>temp_filepath}
                filepaths=Cll_prevpassed.new(acc)
                filepaths.save
            end
            if type=='within'
                acc={:repo_name=>@user+'/'+@repo,:git_commit=>now_build,:prev_passcommit=>lastpass,:filpath=>temp_filepath}
                filepaths=Prev_passed.new(acc)
                #filepaths=Tmp_passed.new(acc)
                filepaths.save
                ActiveRecord::Base.clear_active_connections!
            end
            
        rescue => exception
            c=git_compare(now_build,lastpass,user,repo,rand(0..7))
            unless c.empty?
                puts "处理diff"
                if lef!=0
                  diff_compare(c,now_build,lastpass,lef,type)
                # else
                #   diff_compare(c,build,0)
                end
                
            end
        end
            
        
    end

    def self.git_compare(now,last,owner,repo,num)
        parent_dir = File.join('compare', "#{owner}@#{repo}")
        commit_json = File.join(parent_dir, "#{last[0,7]}@#{now[0,7]}.json")
        FileUtils::mkdir_p(parent_dir)
    
        r = {}
        
      if File.exists? commit_json
          r= begin
            JSON.parse File.open(commit_json).read
        rescue
          {}
        
        end
      end
      unless r.empty?
        return r
      end
      if r.empty? ||  !(File.exists? commit_json)
      
        unless r.nil? || r.empty?
            return r
          
        else
        
    
        url = "https://api.github.com/repos/#{owner}/#{repo}/compare/#{last}...#{now}"
        puts "Requesting #{url} (#{@remaining} remaining)"
    
        contents = nil
        begin
          puts "begin"
          
          r = open(url, 'User-Agent' => 'ghtorrent', 'Authorization' => "token #{$token[num]}")
          
          @remaining = r.meta['x-ratelimit-remaining'].to_i
          puts "@remaining"
          puts @remaining
          @reset = r.meta['x-ratelimit-reset'].to_i
          contents = r.read
          JSON.parse contents
        rescue OpenURI::HTTPError => e
          @remaining = e.io.meta['x-ratelimit-remaining'].to_i
          @reset = e.io.meta['x-ratelimit-reset'].to_i
          puts  "Cannot get #{url}. Error #{e.io.status[0].to_i}"
          puts @remaining
          puts $token[num]
          {}
        rescue StandardError => e
          puts "Cannot get #{url}. General error: #{e.message}"
          puts $token[num]
          {}
        ensure
          File.open(commit_json, 'w') do |f|
            f.write contents unless r.nil?
            if r.nil? and 5000 - @remaining >= 6
              puts "xxxxx"
              git_compare(now, last, owner,repo,rand(0..7))
            end
            
          
          end
    
          if 5000 - @remaining >= $REQ_LIMIT
            to_sleep = 500
            puts $token[num]
            puts "Request limit reached, sleeping for #{to_sleep} secs"
            if num!=7
              num+=1
            else
              num=0
            end
            git_compare(now, last, owner,repo,num)
            #sleep(to_sleep)
          end
        end
      end
    end
    end 
    
    
    def self.diff_compare(compare_json,build,lastpass=0,flag,type)
      
      #number of filesmodified/added/delete
      
      line_added=0
      line_deleted=0
      
      temp_filepath=[]
          
      for info in compare_json['files']
        line_added+=info['additions']
        line_deleted+=info['deletions']
        temp_filepath<< info['filename']
        
        end
      
        
      #parse_html=ParseHtml.new
      
      
      if type=='cll'
      
        acc={:repo_name=>@user+'@'+@repo,:git_commit=>build,:prev_passcommit=>lastpass,:filpath=>temp_filepath}
        filepaths=Cll_prevpassed.new(acc)
        filepaths.save
      
      else
        acc={:repo_name=>@user+'/'+@repo,:git_commit=>build,:prev_passcommit=>lastpass,:filpath=>temp_filepath}
        filepaths=Prev_passed.new(acc)
        #filepaths=Tmp_passed.new(acc)
        filepaths.save
        ActiveRecord::Base.clear_active_connections!
      end
    
    end
    
    
end