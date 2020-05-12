struct Diff
  class MyersLinear < Differ
    def initialize(@a : Array(Line), @b : Array(Line))
    end

    def self.diff(a : Array(Line), b : Array(Line))
      new(a, b).diff
    end

    def diff : Array(Diff::Edit)
      diff = [] of Diff::Edit

      walk_snakes do |x1, y1, x2, y2|
        if x1 == x2
          diff << Diff::Edit.new(:insert, nil, @b[y1])
        elsif y1 == y2
          diff << Diff::Edit.new(:delete, @a[x1], nil)
        else
          diff << Diff::Edit.new(:equal, @a[x1], @b[y1])
        end
      end

      diff
    end


    def find_path(left, top, right, bottom)
      box   = Box.new(left, top, right, bottom)
      snake = midpoint(box)

      return nil unless snake

      start, stop = snake

      head = find_path(box.left, box.top, start[0], start[1])
      tail = find_path(stop[0], stop[1], box.right, box.bottom)

      (head || [start]) + (tail || [stop])
    end

    def midpoint(box)
      return nil if box.size == 0

      max = (box.size / 2.0).ceil.to_i

      vf    = Array(Int32).new(2 * max + 1, 0)
      vf[1] = box.left
      vb    = Array(Int32).new(2 * max + 1, 0)
      vb[1] = box.bottom

      (0 .. max).step do |d|
        forwards(box, vf, vb, d) { |snake| return snake }
        backward(box, vf, vb, d) { |snake| return snake }
      end

      nil
    end

    def forwards(box, vf, vb, d)
      (-d .. d).step(2).to_a.reverse_each do |k|
        c = k - box.delta

        if k == -d || (k != d && vf[k - 1] < vf[k + 1])
          px = x = vf[k + 1]
        else
          px = vf[k - 1]
          x  = px + 1
        end

        y  = box.top + (x - box.left) - k
        py = (d == 0 || x != px) ? y : y - 1

        while x < box.right && y < box.bottom && @a[x].text == @b[y].text
          x, y = x + 1, y + 1
        end

        vf[k] = x

        if box.delta.odd? && (-(d - 1) .. (d - 1)).includes?(c) && y >= vb[c]
          yield [[px, py], [x, y]]
        end
      end
    end

    def backward(box, vf, vb, d)
      (-d .. d).step(2).to_a.reverse_each do |c|
        k = c + box.delta

        if c == -d || (c != d && vb[c - 1] > vb[c + 1])
          py = y = vb[c + 1]
        else
          py = vb[c - 1]
          y  = py - 1
        end

        x  = box.left + (y - box.top) + k
        px = (d == 0 || y != py) ? x : x + 1

        while x > box.left && y > box.top && @a[x - 1].text == @b[y - 1].text
          x, y = x - 1, y - 1
        end

        vb[c] = y

        if box.delta.even? && (-d .. d).includes?(k) && x <= vf[k]
          yield [[x, y], [px, py]]
        end
      end
    end

    def walk_snakes(&block : Int32, Int32, Int32, Int32 ->)
      path = find_path(0, 0, @a.size, @b.size)
      return unless path

      path.each_cons(2) do |cons|
        x1, y1 = cons[0]
        x2, y2 = cons[1]
        x1, y1 = walk_diagonal(x1, y1, x2, y2, &block)

        case x2 - x1 <=> y2 - y1
        when -1
          yield x1, y1, x1, y1 + 1
          y1 += 1
        when 1
          yield x1, y1, x1 + 1, y1
          x1 += 1
        else
        end

        walk_diagonal(x1, y1, x2, y2, &block)
      end
    end

    def walk_diagonal(x1, y1, x2, y2, &block : Int32, Int32, Int32, Int32 ->)
      while x1 < x2 && y1 < y2 && @a[x1].text == @b[y1].text
        yield x1, y1, x1 + 1, y1 + 1
        x1, y1 = x1 + 1, y1 + 1
      end
      [x1, y1]
    end
  end
end
