require 'rugged'
require_relative 'java'
require 'open-uri'
class ExtractGitInfoGh

  include JavaData

  def initialize(user,repo)
    @token = ["baeb194686215604af80044f10ef4ffb32c903cb",
              "d50d8c48d4a0e60f8c7201c70368d303c3bdc625",
              "7f11251413da346325b636301bf394efc172f431",
              "623f6c239d614b0c12ed94642815efe39a69d59b",#我
              "e7ee74749713821a882af6955212ca5926df2889",#我2
              # "1e2e6a896a4f081f6cbf8e99003980d36a01153f",#xue
              # "44702440fac7f14adbd57e7cb08084c4dd036c32",#思聪
              # "2a47b42a0135dcb6b3fedaf2f5fb09752521fc96",#国哥
              # "7192bcb7171a87b84fe8cec6303dc851fecbf3cd",#施博文
              "4d37d731bc445de2421f4fbe7bf8ff772ce9af0b",#谢东方
              # "38dbc6ce08b536f86b226afa533e8198f03ccf11",#谢隽丰
              "43d40a4f7e730416d7642b727c75674e7b39241b",#涂轩涵
              "fbc83d122891cb443b1c5c02cdfd491cd6d8e042"#吴帅
    ]
    @dir_name = "repo"
    dir_path = File.expand_path(@dir_name, File.dirname(__FILE__))
    Dir.mkdir(dir_path) if Dir.exists?(dir_path) == false
    @user=user
    @repo=repo
    @thread_number=30
    info=All_repo_data_virtual_prior_merge.where("repo_name=? and gh_team_size is not null","#{@user}@#{@repo}").order("now_build_id asc").first
    @first_id=info.now_build_id
    p @first_id
    last_info=All_repo_data_virtual_prior_merge.where("repo_name=? and gh_team_size is not null","#{@user}@#{@repo}").order("now_build_id asc").last
    
    @last_id=last_info.now_build_id
    p @last_id
    # checkout_dir =File.expand_path(File.join('..','..','..','sequence', 'repository',user+'@'+repo),File.dirname(__FILE__))
    # # puts checkout_dir
    # @git = Rugged::Repository.new(checkout_dir)
  end
# url = "https://github.com/checkstyle/checkstyle/archive/354124f81461a8d6ba2264be07c5ea52c0ef05d9.zip"
  def download_zip(url, file_path)
    `wget #{url} -O #{file_path}`
    $?.success?
  end

  def unpack_zip(file_path, dir_path)
    `unzip #{file_path} -d repo/`
  end

#获取sha对应commit，git库文件列表
  def all_files(dir_path, filter = lambda { |x| true })
    files = []
    begin
      Dir.chdir(dir_path)
      Dir.glob("**/*.java").each do |f|
      file = Hash.new
      file[:name] = f
      file[:path] = File.join(dir_path, f)
      files << file
      end
    rescue => exception
      puts "no such file"
    end
    
    if files.size <= 0
      puts "No files for commit #{dir_path}"
    end
    files.select { |x| filter.call(x) }
  end

  def run(repo_name, sha)
    url = "https://github.com/#{repo_name}/archive/#{sha}.zip"
    file_path = File.expand_path(File.join(@dir_name, "#{repo_name.sub(/\//, '@')}-#{sha}.zip"), File.dirname(__FILE__))
    download_exit_status = false
    download_exit_status = download_zip(url, file_path) if !File.exists?(file_path) == true
    return [nil, nil] if download_exit_status == false
    start = repo_name.index("/")
    puts repo_name
    puts"start #{start}"
    dir_path = File.expand_path(File.join(@dir_name, "#{repo_name[start..-1]}-#{sha}"), File.dirname(__FILE__))
    unpack_zip(file_path, dir_path) if File.exists?(dir_path) == false
    src_line_number = src_lines(dir_path)
    p src_line_number
    test_case_number = num_test_cases(dir_path)
    p test_case_number
    gh_test_cases_per_kloc = test_case_number / (src_line_number.to_f / 1000)
    assertion_number = num_assertions(dir_path)
    p assertion_number
    gh_asserts_cases_per_kloc = assertion_number / (src_line_number.to_f / 1000)
    return [gh_test_cases_per_kloc, gh_asserts_cases_per_kloc]
  end

  def stripped(f)
    @stripped ||= Hash.new
    unless @stripped.has_key? f
      @stripped[f] = strip_comments(File.read(f[:path]))
    end
    @stripped[f]
  end

  def count_lines(files, include_filter = lambda { |x| true })
    return nil if files.nil?
    files.map { |f|
      stripped(f).lines.select { |x|
        not x.strip.empty?
      }.select { |x|
        include_filter.call(x)
      }.size
    }.reduce(0) { |acc, x| acc + x }
  end

  def src_files(dir_path)
    all_files(dir_path, src_file_filter)
  end

  def src_lines(dir_path)
    count_lines(src_files(dir_path))
  end

  def test_files(dir_path)
    all_files(dir_path, test_file_filter)
  end

  def test_lines(dir_path)
    count_lines(test_files(dir_path))
  end

  def num_test_cases(dir_path)
    count_lines(test_files(dir_path), test_case_filter)
  end

  def num_assertions(dir_path)
    count_lines(test_files(dir_path), assertion_filter)
  end
  def start_per_sloc
    Thread.abort_on_exception = true
    threads = init_persloc
    puts " start_per_sloc==="
    
    All_repo_data_virtual_prior_merge.where("now_build_id >=? and now_build_id<=? and repo_name=?  and ((sloc_flag=1 and test_density is null) or sloc_flag=0 )",@first_id,@last_id,"#{@user}@#{@repo}").find_all do |info|
      
      @queue.enq info
    end
    @thread_number.times do   
    @queue.enq :END_OF_WORK
    end
    threads.each {|t| t.join}
    puts "Update Over"
  end

  def init_persloc
    @queue=SizedQueue.new(@thread_number)
    threads=[]
    @thread_number.times do 
      thread = Thread.new do
        loop do
          info = @queue.deq
          break if info == :END_OF_WORK

          gh_test_cases_per_kloc, gh_asserts_cases_per_kloc = run(info.repo_name.gsub('@','/'), info.now_build_commit)
          info.test_density=gh_test_cases_per_kloc
          info.assert_density=gh_asserts_cases_per_kloc
          info.sloc_flag=1
          info.save
          
        end
        end
        threads << thread
      end

    threads
    
  end

end
dir = Dir.open("../")

# repo = ExtractGitInfoGh.new()
# 运行run方法时，提供仓库名和sha值
# gh_test_cases_per_kloc, gh_asserts_cases_per_kloc = repo.run("ChenZhangg/autofix", "39b65a6e591ceb801aced2db28fc784a1146607c")