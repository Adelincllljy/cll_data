require File.expand_path('../../lib/all_repo_data_virtual_prior_merge.rb',__FILE__)
require File.expand_path('../../lib/filemodif_info.rb',__FILE__)
require File.expand_path('../../lib/file_path.rb',__FILE__)
require File.expand_path('../../lib/maven_error.rb',__FILE__)
require File.expand_path('../../lib/travis_torrent.rb',__FILE__)
module ParseErroFile
    @thread_num=100
    # def self.do_parse_file(info)
    #     file_arry=[]
    #         result=[]
    #         maven_file=[]
    #         if (!info.maven_slice.empty?)
                 
    #             #puts info.id
    #             maven_file=info.maven_slice[0].gsub(" ", "")
             
             
    #          result= maven_file.scan(/.*?\[ERROR?\](.*):[?\[]/)
    #          result=result.uniq
    #          if result.empty?
    #             result= maven_file.scan(/.*?\/(.*)[;]/)
    #          end
    #          for item in result
    #          file_arry << item[0]
    #          end
    #         end
    #         maven_file=[]
    #         result=[]
    #         result2=[]#记录warning
    #         result3=[]
    #         if (!info.test_inerror.empty?) 
    #             #puts info.test_inerror
    #             for line in info.test_inerror
                    
    #                 if line!=" " and line!="\n"
    #                    # puts line.gsub(" ","") 
    #                     maven_file<< line.gsub(" ","") 
    #                     #maven_file<< line.gsub(" "||"\\n", "")
    #                 end
                
    #             end
    #             maven_file=maven_file.join
    #             #puts maven_file
    #             result = maven_file.scan(/.*?\((.*)?\)[:]/)
    #             result2=maven_file.scan(/.*?foundin(.*)/)
                
    #             if result.include? '.'
    #                 result=result.uniq
    #             else
    #                 result=[]
                    
    #             end
    #             if result2.include? '.'
                    
    #                 result2=result2.uniq
    #             else
    #                 maven_file=maven_file.split("\n")
    #                 tmp=[]
    #                 for item in maven_file
    #                     #result2=item.scan(/.*?[\s\S]*?(.*?)[\.]/)
    #                     if item.include?'#'
    #                         #puts"incude#"
    #                         #result2=item.scan(/.*?(.*?)[#]/)
    #                         item=~ /.*?(.*?)[#](.*?)/
    #                         #puts "incude=== #{$1}"
    #                         if !$1.nil? and $1.match?(/[tT]est/)
    #                             tmp<<$1
    #                         end
    #                     elsif item.include? '->'
    #                         contents=item.split('->')
    #                         for data in contents do
    #                             data=~/.*?(.*?)[\.](.*?)[:]/
    #                             # puts "$1 #{$1}"
    #                             # puts "$1 match :#{$1.match?(/[tT]est/)}"
    #                             # puts $1
    #                             if !$1.nil? and $1.match?(/[tT]est/)
    #                                 tmp<<$1
    #                             end
                                
    #                         end
                            
    #                     else
    #                         item=~ /.*?(.*?)[\.](.*?)[:]/
    #                         if !$1.nil?
    #                         tmp<<$1
    #                         end
    #                     end
                        
    #                 end
    #                 result2=tmp.uniq
    #             end
                
    #             #result3=result3.uniq
    #             #嵌套的数组
    #             for item in result
    #                 file_arry << item[0].gsub(".","\/")
    #             end
    #             for item in result2
    #                 if item.class==Array
    #                 file_arry << item[0].gsub(".","\/")
    #                 else
    #                     file_arry << item.gsub(".","\/")
    #                 end

    #             end
    #             # for item in result3
    #             #     file_arry << item[0]
    #             # end 
    #             #puts "file_arry here"
    #             #puts file_arry
    #         end 
    #         maven_file=[]
    #         result=[]  
    #         result2=[]
    #         if (!info.fail_test.empty?) 
    #             for line in info.fail_test
    #                 if line!=" "&&line!="\n"
    #                     maven_file << line.gsub(" "||"\\n", "")
    #                 end
                
    #             end
    #             maven_file=maven_file.join
    #             result = maven_file.scan(/.*?\((.*)?\)[:]/)
    #             result2=maven_file.scan(/.*?foundin(.*)/)
    #             if result.empty?
                    
    #                 result=maven_file.scan(/.*?\((.*)?\)/)
    #             end
    #             if result.include? '.'
    #                 result=result.uniq
    #             else
    #                 result=[]
                    
    #             end
    #             if result2.include? '.'
    #                 puts "include===="
    #                 result2=result2.uniq
    #             else
    #                 result2=[]
    #                 maven_file=maven_file.split("\n")
    #                 tmp=[]
    #                 for item in maven_file
    #                     if item.include?'#'
    #                         #puts"incude#"
    #                         #result2=item.scan(/.*?(.*?)[#]/)
    #                         item=~ /.*?(.*?)[#](.*?)/
    #                         #puts "incude=== #{$1}"
    #                         if !$1.nil? and $1.match?(/[tT]est/)
    #                             tmp<<$1
    #                         end
    #                     elsif item.include? '->'
    #                         contents=item.split('->')
    #                         for data in contents do
    #                             data=~/.*?(.*?)[\.](.*?)[:]/
    #                             # puts "$1 #{$1}"
    #                             # puts "$1 match :#{$1.match?(/[tT]est/)}"
    #                             # puts $1
    #                             if !$1.nil? and $1.match?(/[tT]est/)
    #                                 tmp<<$1
    #                             end
                                
    #                         end
                            
    #                     else
    #                         item=~ /.*?(.*?)[\.](.*?)[:]/
    #                         if !$1.nil?
    #                         tmp<<$1
    #                         end
    #                     end
    #                 end
    #                 result2=tmp.uniq
    #                 #puts "result2 #{result2}"
    #             end
    #             result=result.uniq
    #             for item in result
    #                 file_arry << item[0].gsub(".","\/")
    #             end
    #             for item in result2
    #                 if item.class==Array
    #                 file_arry << item[0].gsub(".","\/")
    #                 else
    #                     file_arry << item.gsub(".","\/")
    #                 end

    #             end
    #             #puts file_arry
    #         end
    #         file_arry=file_arry.uniq
    #         if !file_arry.empty?
    #         info.error_file=file_arry
    #         info.save
    #         else
    #             info.error_file=nil
    #             info.save
    #         end
    # end
    

    def self.do_parse_file(info)
        file_arry=[]
            result=[]
            maven_file=[]
            if (!info.maven_slice.empty?)
                 
                #puts info.id
                maven_file=info.maven_slice[0].gsub(" ", "")
             
             
             result= maven_file.scan(/.*?\[ERROR?\](.*):[?\[]/)
             result=result.uniq
             if result.empty?
                result= maven_file.scan(/.*?\/(.*)[;]/)
             end
             for item in result
             file_arry << item[0]
             end
            end
            maven_file=[]
            result=[]
            result2=[]#记录warning
            result3=[]
            if (!info.test_inerror.empty?) 
                #puts info.test_inerror
                for line in info.test_inerror
                    
                    if line!=" " and line!="\n"
                       # puts line.gsub(" ","") 
                        maven_file<< line.gsub(" ","") 
                        #maven_file<< line.gsub(" "||"\\n", "")
                    end
                
                end
                maven_file=maven_file.join
                #puts maven_file
                result = maven_file.scan(/.*?\((.*)?\)[:]/)
                result2=maven_file.scan(/.*?foundin(.*)/)
                if !result.empty?
                    if result[0][0].include? '.'
                    
                        result=result.uniq
                    else
                    
                        result=[]
                        
                    end
                end 
                if !result2.empty?
                    
                
                    if result2[0][0].include? '.'
                        
                        result2=result2.uniq
                    end
                else
                    #result2=maven_file.scan(/.*?(.*)[:]/)

                    maven_file=maven_file.split("\n")
                    tmp=[]
                    
                    for item in maven_file
                        #result2=item.scan(/.*?[\s\S]*?(.*?)[\.]/)
                        if item.include?'#'
                            #puts"incude#"
                            #result2=item.scan(/.*?(.*?)[#]/)
                            item=~ /.*?(.*?)[#](.*?)/
                            #puts "incude=== #{$1}"
                            if !$1.nil? and $1.match?(/[tT]est/)
                                tmp<<$1
                            end
                        elsif item.include? '->'
                            puts "->"
                            contents=item.split('->')
                            for data in contents do
                                data=~/.*?(.*?)[\.](.*?)[:]/
                                puts "$1 #{$1}"
                                # puts "$1 match :#{$1.match?(/[tT]est/)}"
                                # puts $1
                                if !$1.nil? and ($1.match?(/[tT]est/) or $1.match?(/[cC]ase/))
                                    tmp<<$1
                                end
                                
                            end
                            
                        else
                            item_arry= item.split(":")
                            for itema in item_arry
                                if itema.count('.')==1
                                    flag=1
                                    break
                                end
                                if itema.count('.')>1
                                    flag=2
                                    break
                                    
                                end
                            end
                            if flag==1   
                                item=~ /.*?(.*?)[\.](.*?)[:]/
                                if !$1.nil?
                                tmp<<$1
                                end
                            elsif flag==2
                                
                                item=~ /.*?(.*?)[:]/
                                
                                if !$1.nil?
                                tmp << $1
                                end
                            else
                                item=~ /.*?(.*?)[\.](.*?)[:]/
                                if !$1.nil?
                                tmp<<$1
                                end
                            end
                        end
                        
                    end
                    result2=tmp.uniq
                end
                
                    
                    #result3=result3.uniq
                    #嵌套的数组
                    
                    for con_info in result
                        
                        file_arry << con_info[0].gsub(".","\/")
                    end
                    
                    #puts file_arry
                
                    for item in result2
                        if item.class==Array
                        file_arry << item[0].gsub(".","\/")
                        else
                            file_arry << item.gsub(".","\/")
                        end

                    end
                    # for item in result3
                    #     file_arry << item[0]
                    # end 
                    #puts "file_arry here"
                
                end 
            maven_file=[]
            result=[]  
            result2=[]
            if (!info.fail_test.empty?) 
                for line in info.fail_test
                    if line!=" "&&line!="\n"
                        maven_file << line.gsub(" "||"\\n", "")
                    end
                
                end
                maven_file=maven_file.join
                #puts maven_file
                result = maven_file.scan(/.*?\((.*)?\)[:]/)
                result2=maven_file.scan(/.*?foundin(.*)/)
                if result.empty?
                    #puts "result.empty?"
                    result=maven_file.scan(/.*?\((.*)?\)/)
                end
                if !result.empty?
                    #puts "!result.empty?"
                    if result[0][0].include? '.'
                        result=result.uniq
                        #puts "result.uniq"
                       # puts result
                    else
                        #puts "222"
                        result=[]
                        
                    end
                end
                if !result2.empty?
                    if result2[0][0].include? '.'
                        #puts "include===="
                        result2=result2.uniq
                    end
                else
                    result2=[]
                    maven_file=maven_file.split("\n")
                    tmp=[]
                    for item in maven_file
                        if item.include?'#'
                            #puts"incude#"
                            #result2=item.scan(/.*?(.*?)[#]/)
                            item=~ /.*?(.*?)[#](.*?)/
                            #puts "incude=== #{$1}"
                            if !$1.nil? and $1.match?(/[tT]est/)
                                tmp<<$1
                            end
                        elsif item.include? '->'
                            contents=item.split('->')
                            for data in contents do
                                data=~/.*?(.*?)[\.](.*?)[:]/
                                # puts "$1 #{$1}"
                                # puts "$1 match :#{$1.match?(/[tT]est/)}"
                                # puts $1
                                if !$1.nil? and $1.match?(/[tT]est/)
                                    tmp<<$1
                                end
                                
                            end
                            
                        else
                            #puts "else"
                            item_arry= item.split(":")
                            for itema in item_arry
                                if itema.count('.')==1
                                    flag=1
                                    break
                                end
                                if itema.count('.')>1
                                    flag=2
                                    break
                                    
                                end
                            end
                            if flag==1   
                                item=~ /.*?(.*?)[\.](.*?)[:]/
                                if !$1.nil?
                                tmp<<$1
                                end
                            elsif flag==2
                                
                                item=~ /.*?(.*?)[:]/
                                
                                if !$1.nil?
                                tmp << $1
                                end
                            else
                                item=~ /.*?(.*?)[\.](.*?)[:]/
                                if !$1.nil?
                                tmp<<$1
                                end
                            end
                        end
                    end
                    result2=tmp.uniq
                    #puts "result2 #{result2}"
                end
                
                result=result.uniq
                for item in result
                    file_arry << item[0].gsub(".","\/")
                end
                for item in result2
                    if item.class==Array
                    file_arry << item[0].gsub(".","\/")
                    else
                        file_arry << item.gsub(".","\/")
                    end

                end
                #puts file_arry
            end
            file_arry=file_arry.uniq
            #puts "file_arry #{file_arry}"
            if !file_arry.empty?
                file_arry=file_arry.reject {|m| m==''}
                info.error_file=file_arry
                info.save
            else
                info.error_file=nil
                info.save
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
                do_parse_file info
                
                
                end
            end
                threads << thread
            end
    
            threads
    end
    
    def self.parse_maven_error_file(user,repo)
        Thread.abort_on_exception = true
        threads=init_parse_maven   
        Maven_error.where("repo_name=? and log_exist=0 and error_type=0 ","#{user}@#{repo}").find_all do |info|
        #Maven_error.where("id=7330").find_each do |info|
            @inqueue.enq info
            # puts info.id
        end
        @thread_num.times do
            @inqueue.enq :END_OF_WORK
        end
        threads.each {|t| t.join}
        puts "parse_mavenUpdate Over"  
    
        return            
             
             
        
    end
    
    def self.maven_test()
        
        Withinproject.where("id =2").find_all do |info|
            file_arry=[]
            result=[]
            maven_file=[]
            if (!info.maven_slice.empty?) 
                #and (info.compliation==1)
                puts info.id
                
                for item in info.maven_slice
                    result=[]
                    maven_file=item.gsub(" ", "")
                    result= maven_file.scan(/.*?\[ERROR?\](.*):[?\[]/)
                    result=result.uniq
                    puts result
                    for item in result
                        file_arry << item
                    end
                end
            end
            maven_file=[]
            result=[]
            result2=[]#记录warning 
            
            if (!info.test_inerror.empty?)
                
                for line in info.test_inerror
                    if line!=" " and line!="\n"
                        maven_file<< line.gsub(" ", "") 
                    end
                
                end
                
                maven_file=maven_file.join
                puts "maven_file:"
                puts maven_file.class
                puts maven_file
                
                result = maven_file.scan(/.*?\((.*)?\)/)
                result2=maven_file.scan(/.*?foundin(.*)/)
                # if result.empty?
                #     result = maven_file.scan(/.*?(.*).*?[\.]/)
                #     puts "result"
                #     puts result.class
                #     puts result
                # end
                if result2.include? '.'
                    puts "include ."
                    result2=result2.uniq
                else
                    maven_file=maven_file.split("\n")
                    tmp=[]
                    for item in maven_file
                        #result2=item.scan(/.*?[\s\S]*?(.*?)[\.]/)
                        if item.include?'#'
                            result2=item.scan(/.*?(.*?)[#]/)
                            if !result2[0].nil?
                                tmp<<result2[0]
                            end
                        else
                            result2=item.scan(/.*?(.*?)[\.]/)
                            if !result2[0].nil?
                            tmp<<result2[0]
                            end
                        end
                    end
                    result2=tmp.uniq
                    puts result2 
                end
                for item in result2
                    puts item[0]
                    file_arry << item[0].gsub(".","\/")
                    puts file_arry
                end
                
                # if result2.empty?
                #     result2=maven_file.scan(/.*?foundin(.*)/)
                    
                # end
                # puts "result==============="
                # puts result
                # puts "result2==============="
                # puts result2
                # puts result2.size
                # result=result.uniq
                # for item in result
                #     file_arry << item
                # end
            end 
            maven_file=[]
            result=[] 
            
            # if (!info.test_in_error.empty?) and (info.test==1)
            #     puts "test_in_error"
            #     puts "info.test_in_error#{info.test_in_error}"
            #     for line in info.test_in_error
            #         if line!=" "&&line!="\n"
            #             maven_file << line.gsub(" ", "")
            #         end
                
            #     end
            #     maven_file=maven_file.join
            #     result = maven_file.scan(/.*?\((.*)?\)[:]/)
            #     if result.empty?
            #         puts"result.empty"
            #         result=maven_file.scan(/.*?\((.*)?\)/)
            #     end
            #     puts "====="
            #     puts result
            #     result=result.uniq
            #     for item in result
            #         puts item[0].class
            #         file_arry << item[0]
            #     end
            # end
            # file_arry=file_arry.uniq
            # if !file_arry.empty?
            # puts file_arry
            # for value in file_arry do
            #     puts value.class
                
            # end
            # end
        end
    
        
    end 

    def self.test_group
        puts Maven_error.select("*").group("build_id").find_each.count
        #Maven_error.select("*").group("build_id").find_each do |info|
        File_path.where("id=5").find_each do |info|
            puts info.filpath.empty?
        
        end

        
    end

    
end

user=ARGV[0]
repo=ARGV[1]
#ParseErroFile.test_group
#ParseErroFile.parse_maven_error_file(user,repo)
#ParseErroFile.maven_test()
# ss=" 1abc1: is 1xxx1"
# a=ss.scan(/1(.*)1:/)
# puts a
#UniversalMediaServer@UniversalMediaServer

  
  