struct Diff
  struct Edit
    getter type : Edit::Type
    getter old_line : Line?
    getter new_line : Line?

    def initialize(@type : Edit::Type, @old_line : Line?, @new_line : Line?)
      unless @old_line || @new_line
        raise "An edit must contain either an old_line or a new_line, but both are nil"
      end
    end

    def old_number
      old_line ? old_line.not_nil!.number.to_s : ""
    end

    def new_number
      new_line ? new_line.not_nil!.number.to_s : ""
    end

    def text
      (old_line || new_line).not_nil!.text
    end

    enum Type
      Insert
      Delete
      Equal
    end
  end
end
