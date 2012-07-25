require 'rake'
require 'erb'

desc "install the dot files into user's home directory"
task :install do
  # clone oh-my-zsh if it doesn't already exist
  unless File.directory?(File.join(ENV['HOME'], '.oh-my-zsh'))
    system %Q{git clone https://github.com/sorin-ionescu/oh-my-zsh.git ~/.oh-my-zsh}
    system %Q{cd ~/.oh-my-zsh && git submodule update --init --recursive && cd ..}
  end

  replace_all = false
  Dir['*'].each do |file|
    next if %w[Rakefile README.mkd LICENSE yadr gitconfig.sh].include? file

    if File.exist?(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"))
      if File.identical?(file, File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"))
        puts "identical ~/.#{file.sub('.erb', '')}"
      elsif replace_all
        replace_file(file)
      else
        print "overwrite ~/.#{file.sub('.erb', '')}? [ynaq] "
        case $stdin.gets.chomp
        when 'a'
          replace_all = true
          replace_file(file)
        when 'y'
          replace_file(file)
        when 'q'
          exit
        else
          puts "skipping ~/.#{file.sub('.erb', '')}"
        end
      end
    else
      link_file(file)
    end
  end

  # yadr configs and aliases
  # link yadr/custom/* into ~/.yadr/custom/*
  Dir['yadr/custom/*'].each do |folder|
    puts "linking ~/.#{folder}"
    system %Q{echo ln -s "$PWD/#{folder}" "$HOME/.#{folder}"}
  end

  # run custom setup scripts
  Dir['*.sh'].each do |file|
    system %Q{sh #{file}}
  end
end

def replace_file(file)
  system %Q{rm -rf "$HOME/.#{file.sub('.erb', '')}"}
  link_file(file)
end

def link_file(file)
  if file =~ /.erb$/
    puts "generating ~/.#{file.sub('.erb', '')}"
    File.open(File.join(ENV['HOME'], ".#{file.sub('.erb', '')}"), 'w') do |new_file|
      new_file.write ERB.new(File.read(file)).result(binding)
    end
  else
    puts "linking ~/.#{file}"
    system %Q{ln -s "$PWD/#{file}" "$HOME/.#{file}"}
  end
end

def link_folder(folder)
  puts "linking ~/.#{folder}"
  system %Q{echo ln -s "$PWD/#{folder}/" "$HOME/.#{folder}"}
end
