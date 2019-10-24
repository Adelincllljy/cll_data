#gem 'activerecord', '< 5.2.3'
require 'active_record' 
require 'activerecord-import'
#require 'activerecord-jdbcmysql-adapter'
require 'rugged'
require File.expand_path('../travis_torrent.rb',__FILE__)
class Test< ActiveRecord::Base
    establish_connection(   
    adapter:  "mysql2",
    host:     "10.131.252.160",
    username: "root",
    password: "root",
    database: "cll_data",  
    encoding: "utf8mb4", 
    collation: "utf8mb4_bin"
)
belongs_to :category
serialize :jobs, Array
#set_table_name 'all_repo_data_virtual_prior_merges' 
end

c=[{ "parents": [
  {
    "sha": "e1894d0f34628d8b7313ca53fe71dc7e9ea300a3",
    "url": "https://api.github.com/repos/google/guava/commits/e1894d0f34628d8b7313ca53fe71dc7e9ea300a3",
    "html_url": "https://github.com/google/guava/commit/e1894d0f34628d8b7313ca53fe71dc7e9ea300a3"
  },
  {
    "sha": "x3189d0f34628d8b7313ca53fe71dc7e9ea300a3",
    "url": "https://api.github.com/repos/google/guava/commits/e1894d0f34628d8b7313ca53fe71dc7e9ea300a3",
    "html_url": "https://github.com/google/guava/commit/e1894d0f34628d8b7313ca53fe71dc7e9ea300a3"
  }
],
"commit": {
    "author": {
      "name": "cgdecker",
      "email": "cgdecker@google.com",
      "date": "2015-12-14T21:53:16Z"
    },
    "committer": {
      "name": "Chris Povirk",
      "email": "cpovirk@google.com",
      "date": "2015-12-14T22:23:15Z"
    }}},{"commit": {
      "author": {
        "name": "cgdecker",
        "email": "cgdecker@google.com",
        "date": "2015-12-14T21:53:16Z"
      },
      "committer": {
        "name": "Chris Povirk",
        "email": "cpovirk@google.com",
        "date": "2015-12-14T22:23:15Z"
      }}}]
d=[{"test":22},"test":33]

  # puts c[0].has_key? :parents
  #  c=format("%.3f",Float(2)/3)
  #  puts c
  #   end
  

# ss=[{:build_id=>1,:repo_name=>"xb"},{:build_id=>2,:repo_name=>"wx"}]
# ss.map  do |build|
#   if build[:build_id]==1
#     build[:new]=nil
#   else
#     build[:old]=nil
#   end
# end
#puts ss[0][:new].nil?

# puts Test.where("repo_name=?","cll5").find_each.size
# if Test.where("repo_name=?","cll5").find_each.size!=0
#     puts"test"
#     Test.where("repo_name=?","cll5").find_each do |test|
        
#     puts test[:build_id]
#     end
 
# else 
#     puts "nofind"

# end






   
owner=ARGV[0]
repo=ARGV[1]
# Test.select("id,repo_name,build_id").where("id>1").find_each do |info|
#    hash=info.attributes.deep_symbolize_keys
#    hash.delete(:repo_name)
   
#    puts hash
#    #.delete(:id)
   
# end
Test.select("id,repo_name,build_id").where("id>2").find_each do |info|
  info.repo_name='newname'
  info.save

end
Test.select("id,repo_name,build_id").where("id>2").find_each do |info|
  puts info.repo_name

end
# test.attributes.deep_symbolize_keys

  #  puts test.repo_name
  #  puts test
#test_build_prior_commit(owner,repo)
def test_patch
  checkout_dir =File.expand_path(File.join('..','..','..','sequence', 'repository', 'Unidata@thredds'),File.dirname(__FILE__))
  repos = Rugged::Repository.new(checkout_dir)
  from = repos.lookup('49429686c3be8c3cb0aea17fca3e6684706d5fa1')
  to = repos.lookup('f63544cc69b49664a0487bf064ce0c7f64b40641')
  puts "from #{from}"
  puts "to #{to}"
  diff = to.patch(from)
  puts diff.content
  puts "patch"
  diff.patch.lines do |line|
    puts line
  end
  
  #.lines.each do |line|
end
def write_file_add(contents,parent_dir,filename)
  json_file = File.join(parent_dir, filename)
  puts json_file
  if contents.class == Array
    
      contents.flatten!
  # Remove empty entries
      contents.reject! { |c| c.empty? }
  end
  if File.exists? json_file
    #puts "all_commit:#{all_commits}"
    
  
    
  # Remove empty entries
    
    puts "initial builds size #{contents.size}"
    if contents.empty?
      error_message = "Error could not get any repo information for #{parent_dir}."
      puts error_message    
      exit(1)
    end
  
    File.open(json_file, 'a') do |f|
    f.puts(JSON.dump(contents)) 
    end
  
  else
    File.open(json_file, 'a') do |f|
    f.puts JSON.dump(contents)
    end
  end

    
end
