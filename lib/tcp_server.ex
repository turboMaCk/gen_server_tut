defmodule TcpServer do
  use GenServer

  def start_link() do
    ip = Application.get_env :gen_tcp, :ip, {127,0,0,1}
    port = Application.get_env :gen_tcp, :port, 6666
    GenServer.start_link(__MODULE__, [ip, port], [])
  end

  def init [ip, port] do
    {:ok, listen_socket} = :gen_tcp.listen(port, [:binary, {:packet, 0},
                                                  {:active, true}, {:ip, ip}])
    {:ok, socket} = :gen_tcp.accept listen_socket
    {:ok, %{ip: ip, port: port, socket: socket}}
  end

  def handle_info({:tcp, socket, packet}, state) do
    IO.inspect packet, label: "Incoming packet"
    :gen_tcp.send socket, "Hi Blackode \n"
    {:noreply, state}
  end

  def handle_info({:tcp_closed, socket}, state) do
    IO.inspect "Socket has been closed"
    {:noreply, state}
  end

  def handle_indfo({:tcp_error, socket, reason}, state) do
    IO.inspect socket, label: "Connection closed du to #{reason}"
    {:norreply, state}
  end

end
