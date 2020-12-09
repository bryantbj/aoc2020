defmodule Util do
  @doc """
  Taken from https://gist.github.com/veelenga/6057bdef7227bb4a23fcdd2394e0abec#gistcomment-2201444
  """
  def flatten(list, depth \\ -2), do: flatten(list, depth + 1, []) |> Enum.reverse()
  def flatten(list, 0, acc), do: [list | acc]
  def flatten([h | t], depth, acc) when h == [], do: flatten(t, depth, acc)

  def flatten([h | t], depth, acc) when is_list(h),
    do: flatten(t, depth, flatten(h, depth - 1, acc))

  def flatten([h | t], depth, acc), do: flatten(t, depth, [h | acc])
  def flatten([], _, acc), do: acc
end
