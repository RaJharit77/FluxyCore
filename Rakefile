desc "Compile Crystal transformer"
task :compile do
  Dir.chdir("src/crystal") do
    sh "shards build"
  end
  puts "Binary ready: bin/fluxy_transformer"
end

desc "Run tests"
task :test do
  ruby "test/test_pipeline.rb"
end

task default: :compile