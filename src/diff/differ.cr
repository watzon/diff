struct Diff
  abstract class Differ
    abstract def diff : Array(Diff::Edit)
  end
end
