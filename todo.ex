defmodule TodoList do
  @no_tasks "Nothing to do!"

  def new, do: MultiMap.new

  def add_entry(todo_list, date, title), do: MultiMap.add(todo_list, date, title)

  def entries(todo_list, date), do: MultiMap.get(todo_list, date)

  def due_today(todo_list) do
    {today, _} = :calendar.local_time
    tasks = todo_list |> entries(today)
    if tasks != [], do: tasks, else: @no_tasks
    |> IO.puts
  end

end

defmodule MultiMap do

  def new, do: Map.new

  def add(map, key, value) do
    Map.update(
      map,
      key,
      [value],
      &[value | &1]
    )
  end

  def get(map, key), do: Map.get(map, key, [])

end

