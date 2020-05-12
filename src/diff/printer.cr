require "cor"

struct Diff
  class Printer
    TAGS = {
      Edit::Type::Equal => " ",
      Edit::Type::Delete => "-",
      Edit::Type::Insert => "+",
    }

    COLORS = {
      Edit::Type::Equal => Cor.color(:white),
      Edit::Type::Delete => Cor.color(:red),
      Edit::Type::Insert => Cor.color(:green),
    }

    LINE_WIDTH = 4

    def initialize(@output : IO = STDOUT, @colorize = false)
      @colors = @colorize ? COLORS : {} of Edit::Type => Cor
    end

    def print(diff)
      diff.each do |edit|
        print_edit(edit)
      end
    end

    def print_edit(edit)
      col = @colors.fetch(edit.type, nil)
      tag = TAGS[edit.type]

      # old_line = edit.old_number.rjust(LINE_WIDTH, ' ')
      # new_line = edit.new_number.rjust(LINE_WIDTH, ' ')
      text = edit.text.rstrip

      line = "#{tag}    #{text}"
      colored = col ? Cor.truecolor_string(line, fore: col) : line

      @output.puts colored
    end
  end
end
