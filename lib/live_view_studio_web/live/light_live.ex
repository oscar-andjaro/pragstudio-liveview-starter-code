defmodule LiveViewStudioWeb.LightLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    IO.inspect(socket)
    socket = assign(socket, :brightness, 50)
    IO.inspect(socket)
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>Light</h1>
    <div id="light">
      <div class="meter">
        <span style="width: <%= @brightness %>%;"><%= @brightness %>%</span>
      </div>

      <button phx-click="off">
        <img src="images/light-off.svg"/> OFF
      </button>

      <button phx-click="down">
        <img src="images/down.svg"/>
      </button>

      <button phx-click="up">
        <img src="images/up.svg"/>
      </button>

      <button phx-click="on">
        <img src="images/light-on.svg"/> ON
      </button>
    </div>
    """
  end

  def handle_event(event, _, socket) do
    case event do
      "on" -> {:noreply, assign(socket, :brightness, 100)}
      "off" -> {:noreply, assign(socket, :brightness, 0)}
      "down" -> {:noreply, update(socket, :brightness, &(&1 - 10))}
      "up" -> {:noreply, update(socket, :brightness, fn brightness -> brightness + 10 end)}
      _ -> {:noreply, assign(socket, :brightness, 0)}
    end
  end
end
