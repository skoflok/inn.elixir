defmodule InnWeb.PublicChannel do
  use InnWeb, :channel

  alias Inn.Checker
  alias Inn.Checker.Tin

  @impl true
  def join("public:checker", payload, socket) do
    ip = extract_ip(socket)

    if banned?(payload, socket) do
      {:error,
       %{
         reason:
           "Ваш ip-адрес #{ip} заблокирован. До окончания блокировки #{10}. После окончания блокировки перезагрузите страницу",
         ip: ip
       }}
    else
      {:ok, socket}
    end

    # if authorized?(payload) do
    #   {:ok, socket}
    # else
    #   {:error, %{reason: "unauthorized"}}
    # end
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
    number =
      case body do
        %{"number" => val} -> String.to_integer val
        _ -> 0
      end

    ip = extract_ip(socket)
    is_valid = Checker.verify_tin_number(number)

    IO.inspect(number, label: "#######")

    case Checker.create_tin(%{number: number, ip: ip, is_valid: is_valid}) do
      {:ok, tin} ->
        broadcast!(socket, "validation", %{body: body, status: true, data: tin})

      {:error, tin} ->
        broadcast!(socket, "validation", %{body: body, status: false, data: nil})
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
