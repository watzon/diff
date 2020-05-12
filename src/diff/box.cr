struct Diff
  struct Box
    getter left : Int32
    getter top : Int32
    getter right : Int32
    getter bottom : Int32

    def initialize(@left, @top, @right, @bottom)
    end

    def width
      right - left
    end

    def height
      bottom - top
    end

    def size
      width + height
    end

    def delta
      width - height
    end
  end
end
