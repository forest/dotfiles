begin
  require "jazz_hands"
  JazzHands.prompt_separator = "❯"
rescue LoadError
end

begin
  require "awesome_print"
  AwesomePrint.pry!
rescue LoadError
end

begin
  require "hirb"
  Hirb.enable
rescue LoadError
end

Pry.commands.alias_command "c", "continue"
Pry.commands.alias_command "s", "step"
Pry.commands.alias_command "n", "next"
Pry.commands.alias_command "f", "finish"
Pry.config.editor = "mvim"
