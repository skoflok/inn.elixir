defmodule Inn.RedisClient do
  @sets_name "banned"
  @default_ban_time 60

  import DateTime

  def get_banned(formating \\ true) do
    base = ["ZRANGE", @sets_name, "0", "-1"]
    {:ok, list} = Redix.command(:redix, base ++ ["WITHSCORES"])

    case formating do
      true -> format(list)
      _ -> list
    end
  end

  def list_paging(page, limit \\ 5) do
    base = ["ZRANGE", @sets_name]
    {:ok, total} = Redix.command(:redix, ["ZCOUNT", @sets_name, "-inf", "+inf"])

    offset = ((page - 1) * limit) |> IO.inspect(label: "offset")
    last = (offset + limit - 1) |> IO.inspect(label: "last")
    {:ok, paging} = Redix.command(:redix, base ++ [offset, last, "WITHSCORES"])

    formatted = format(paging)
    meta = meta_paging(total, page, limit)

    %{:data => formatted, :meta => meta}
  end

  defp meta_paging(0, page, limit) do
    %{
      :current_page => 1,
      :next_page => 1,
      :previous_page => 1,
      :first_page => 1,
      :last_page => 1,
      :total => 0
    }
  end

  defp meta_paging(total, page, limit) do
    last_page = if rem(total, limit) === 0, do: total / limit, else: div(total, limit) + 1
    previous_page = if page <= 1, do: 1, else: page - 1
    next_page = if page < last_page, do: page + 1, else: last_page

    %{
      :current_page => page,
      :next_page => next_page,
      :previous_page => previous_page,
      :first_page => 1,
      :last_page => last_page,
      :total => total
    }
  end

  def set_banned(ip, nil) do
    timestamp = to_unix(utc_now) + @default_ban_time
    Redix.command(:redix, ["ZADD", @sets_name, "CH", timestamp, ip])
  end

  def set_banned(ip, time) do
    timestamp = to_unix(utc_now) + time
    Redix.command(:redix, ["ZADD", @sets_name, "CH", timestamp, ip])
  end

  def get_by_range(start, finish, formating \\ true) do
    base = ["ZRANGEBYSCORE", @sets_name, start, finish]
    {:ok, list} = Redix.command(:redix, base ++ ["WITHSCORES"])

    case formating do
      true -> format(list)
      _ -> list
    end
  end

  defp format(list) do
    list |> Enum.chunk_every(2) |> Enum.map(fn [a, b] -> %{:ip => a, :time => b} end)
  end

  def check_banned(ip) do
    {:ok, score} = Redix.command(:redix, ["ZSCORE", @sets_name, ip])

    case score do
      nil -> false
      _ -> true
    end
  end

  def rem_outdated_ip() do
    current_time = to_unix(utc_now)
    Redix.command(:redix, ["ZREMRANGEBYSCORE", @sets_name, "-inf", "(#{current_time}"])
  end

  def rem_banned(ip) do
    {:ok, result} = Redix.command(:redix, ["ZREM", @sets_name, ip])
  end
end
