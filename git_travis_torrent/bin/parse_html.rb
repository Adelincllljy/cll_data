require 'net/http'
require 'open-uri'
require 'json'
require 'date'
require 'time'
require 'fileutils'
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

class ParseHtml
  $REQ_LIMIT=4990
def self.download_diff(url, wait_in_s = 1)
  if (wait_in_s > 64)
    STDERR.puts "Error: Giveup: We can't wait forever for #{url}"
    return 0
  elsif (wait_in_s > 1)
    sleep wait_in_s
  end

  begin
    begin
      log_url = url
      STDERR.puts "Attempt 1 #{log_url}"
      diff = Net::HTTP.get_response(URI.parse(log_url)).body
      return diff
    rescue
      # Workaround if log.body results in error.
      log_url = url
      STDERR.puts "Attempt 2 #{log_url}"
      diff = Net::HTTP.get_response(URI.parse(log_url)).body
      return diff
    end

    File.open(name, 'w') { |f| f.puts log }
    log = '' # necessary to enable GC of previously stored value, otherwise: memory leak
  rescue
    error_message = "Retrying, but Could not get log #{name}"
    #puts error_message
    
    download_diff(url, wait_in_s*2)
  end
end

def self.github_commit (owner, repo, sha,k)
  
  parent_dir = File.join('commits', "#{owner}@#{repo}")
  commit_json = File.join(parent_dir, "#{sha}.json")
  FileUtils::mkdir_p(parent_dir)

  r = nil
  i=1
  if File.exists? commit_json  
      r= begin
        JSON.parse File.open(commit_json).read
    rescue
      {}
      
    end
    return r if !r.empty?
  end

  unless r.nil? or r.empty?
      return r
    
  else
   

  url = "https://api.github.com/repos/#{owner}/#{repo}/commits/#{sha}"
  #puts "Requesting #{url} "

  contents = nil
  begin
    #puts "begin"
    #puts $token[k]
    r = open(url, 'User-Agent' => 'ghtorrent', 'Authorization' => "token #{$token[k]}")
    
    @remaining = r.meta['x-ratelimit-remaining'].to_i
    #puts "@remaining"
    puts "@remaining#{@remaining}"
    @reset = r.meta['x-ratelimit-reset'].to_i
    contents = r.read
    JSON.parse contents
  rescue OpenURI::HTTPError => e
    @remaining = e.io.meta['x-ratelimit-remaining'].to_i
    @reset = e.io.meta['x-ratelimit-reset'].to_i
    puts  "Cannot get #{url}. Error #{e.io.status[0].to_i}"
    puts "#{$token[k]}:#{@remaining}"
    {}
  rescue StandardError => e
    @remaining = e.io.meta['x-ratelimit-remaining'].to_i
    @reset = e.io.meta['x-ratelimit-reset'].to_i
    puts "Cannot get #{url}. General error: #{e.message}"
    puts "#{$token[k]}:#{@remaining}"

    {}
  ensure
    File.open(commit_json, 'w') do |f|
      f.write contents unless r.nil?
      if r.nil? and 5000 - @remaining >= 6
        github_commit(owner, repo, sha,k)
      end
      
    
    end

    if 5000 - @remaining >= $REQ_LIMIT
      to_sleep = 500
      puts "Request limit reached, sleeping for #{to_sleep} secs"
      puts "@remaining#{@remaining}"
      
      puts token[k]
      sleep(to_sleep)
      if k!=7
        k=k+1
      else
        k=0
      end
      github_commit(owner, repo, sha,k)
      #
    end
  end
end
end
end

#puts ParseHtml.download_diff('https://travis-ci.org/structr/structr/jobs/68165554')
