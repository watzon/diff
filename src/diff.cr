require "./diff/**"

# TODO: Add merging with diff3 https://blog.jcoglan.com/2017/05/08/merging-with-diff3/

struct Diff
  @diff : Array(Diff::Edit)

  def initialize(@a : String, @b : String, @differ : Differ.class = Myers)
    @diff = @differ.diff(lines(@a), lines(@b))
  end

  def self.new(a : String, b : String, differ = Myers)
    new(a, b, differ.new)
  end

  def self.new(a : IO, b : IO, differ = Myers)
    new(a.rewind.gets_to_end, b.rewind.gets_to_end, differ)
  end

  def lines(document)
    document = document.is_a?(IO) ? document.rewind.gets_to_end : document
    lines = document.lines
    lines.map_with_index do |line, i|
      Line.new(i + 1, line)
    end
  end

  def to_s(io : IO, colorize = true)
    Diff::Printer.new(io, colorize).print(@diff)
  end
end
