struct Diff
  class Myers < Differ
    def initialize(@left : Array(Line), @right : Array(Line))
    end

    def self.diff(left : Array(Line), right : Array(Line))
      new(left, right).diff
    end

    def diff : Array(Diff::Edit)
      diff = [] of Diff::Edit

      backtrack do |prev_x, prev_y, x, y|
        a_line, b_line = @left[prev_x]?, @right[prev_y]?

        if x == prev_x
          diff.unshift(Diff::Edit.new(:insert, nil, b_line))
        elsif y == prev_y
          diff.unshift(Diff::Edit.new(:delete, a_line, nil))
        else
          diff.unshift(Diff::Edit.new(:equal, a_line, b_line))
        end
      end

      diff
    end


    def shortest_edit
      n = @left.size
      m = @right.size
      max = n + m

      v = Array(Int32).new(2 * max + 1, 0)
      trace = [] of Array(Int32)

      (0 .. max).step do |d|
        trace << v.clone

        (-d .. d).step(2) do |k|
          if k == -d || (k != d && v[k - 1] < v[k + 1])
            x = v[k + 1]
          else
            x = v[k - 1] + 1
          end

          y = x - k

          while x < n && y < m && @left[x].text == @right[y].text
            x, y = x + 1, y + 1
          end

          v[k] = x

          return trace if x >= n && y >= m
        end
      end

      trace
    end

    def backtrack
      x = @left.size
      y = @right.size

      shortest_edit.each_with_index.to_a.reverse_each do |v, d|
        k = x - y

        if k == -d || (k != d && v[k - 1] < v[k + 1])
          prev_k = k + 1
        else
          prev_k = k - 1
        end

        prev_x = v[prev_k]
        prev_y = prev_x - prev_k

        while x > prev_x && y > prev_y
          yield x - 1, y - 1, x, y
          x, y = x - 1, y - 1
        end

        yield prev_x, prev_y, x, y if d > 0

        x, y = prev_x, prev_y
      end
    end
  end
end
