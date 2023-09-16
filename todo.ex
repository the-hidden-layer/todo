defmodule TodoList do
  @no_tasks "Nothing to do!"

  defstruct auto_id: 1, entries: Map.new

  def new, do: %TodoList{}

  def add_entry(
    %TodoList{entries: entries, auto_id: auto_id} = todo_list,
    entry
  ) do
    entry = Map.put(entry, :id, auto_id)
    new_entries = Map.put(entries, auto_id, entry)

    %TodoList{
      todo_list |
      entries: new_entries,
      auto_id: auto_id + 1
    }
  end

  def entries(%TodoList{entries: entries}, date) do
    entries
    |> Stream.filter(fn({_, entry}) -> entry.date == date end)
    |> Enum.map(fn({_, entry}) -> entry end)
  end

  def due_today(todo_list) do
    {today, _} = :calendar.local_time
    tasks = todo_list |> entries(today)
    if tasks != [], do: tasks, else: @no_tasks |> IO.puts
  end

  def update_entry(todo_list, %{} = new_entry) do
    update_entry(todo_list, new_entry.id, fn(_) -> new_entry end)
  end

  def update_entry(
    %TodoList{entries: entries} = todo_list,
    entry_id,
    updater_func
  ) do
    case todo_list[entry_id] do
      _ -> todo_list

      old_entry -> 
        old_entry_id = old_entry.id
        new_entry = %{id: ^old_entry_id} = updater_func.(old_entry)
        new_entries = Map.put(entries, new_entry.id, new_entry)
        %TodoList{todo_list | entries: new_entries}
    end
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

