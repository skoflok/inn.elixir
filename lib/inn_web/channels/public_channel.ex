defmodule InnWeb.PublicChannel do
  use InnWeb, :channel

  alias Inn.Checker
  alias Inn.Checker.Tin
  alias Inn.RedisClient

  @impl true
  def join("public:checker", payload, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (public:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  def handle_in("validation", %{"body" => body}, socket) do
    RedisClient.rem_outdated_ip()
    number =
      case body do
        %{"number" => val} -> String.to_integer(val)
        _ -> 0
      end

    ip = extract_ip(socket)

    case RedisClient.check_banned(ip) do
      {true, time } ->
        push(socket, "validation", %{
          body: nil,
          status: false,
          data: "Ваш ip-адрес заблокирован до #{time} (UTC)",
          reason: "banned"
        })

      _ ->
        is_valid = Checker.verify_tin_number(number)

        case Checker.create_tin(%{number: number, ip: ip, is_valid: is_valid}) do
          {:ok, tin} ->
            logged_user = %{:is_logged_in => false}
            div = Phoenix.View.render_to_string(InnWeb.PageView, "row.html", tin: tin, logged_user: logged_user , is_admin_page: false)
            
            broadcast!(socket, "validation", %{body: body, status: true, data: div})

          {:error, tin} ->
            broadcast!(socket, "validation", %{body: body, status: false, data: nil})
        end
    end

    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    false
  end

  defp banned?(_payload, _socket) do
    false
  end

  defp extract_ip(socket) do
    {a, b, c, d} = socket.assigns.peer_data.address
    "#{a}.#{b}.#{c}.#{d}"
  end
end
