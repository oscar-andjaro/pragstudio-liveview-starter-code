defmodule LiveViewStudioWeb.SalesDashboardLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Sales

  @refresh_options [{"1s", 1}, {"5s", 5}, {"15s", 15}, {"30s", 30}, {"60s", 60}]

  def mount(_params, _session, socket) do
    socket = assign_stats(socket)
    socket = assign(socket, :interval, "1")

    if connected?(socket), do: set_next_refresh("1")

    {:ok, socket}
  end

  defp set_next_refresh(interval) do
    :timer.send_after(String.to_integer(interval) * 1000, self(), :tick)
  end

  def render(assigns) do
    ~L"""
    <h1>Sales Dashboard</h1>
    <div id="dashboard">
      <div class="stats">
        <div class="stat">
          <span class="value">
            <%= @new_orders %>
          </span>
          <span class="name">
            New Orders
          </span>
        </div>
        <div class="stat">
          <span class="value">
            $<%= @sales_amount %>
          </span>
          <span class="name">
            Sales Amount
          </span>
        </div>
        <div class="stat">
          <span class="value">
            <%= @satisfaction %>%
          </span>
          <span class="name">
            Satisfaction
          </span>
        </div>
      </div>
      <form phx-change="set_interval">
        <select name="refresh_interval">
        <%= options_for_select(get_refresh_options(), @interval) %>
        </select>
      </form>
      <button phx-click="refresh">
        <img src="images/refresh.svg">
        Refresh
      </button>
    </div>
    """
  end

  defp get_refresh_options, do: @refresh_options

  def handle_event("refresh", _, socket) do
    socket = assign_stats(socket)

    {:noreply, socket}
  end

  def handle_event("set_interval", %{"refresh_interval" => interval}, socket) do
    socket = assign(socket, :interval, interval)

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    socket =
      assign(socket,
        new_orders: Sales.new_orders(),
        sales_amount: Sales.sales_amount(),
        satisfaction: Sales.satisfaction()
      )

    set_next_refresh(socket.assigns.interval)

    {:noreply, socket}
  end

  defp assign_stats(socket) do
    assign(socket,
      new_orders: Sales.new_orders(),
      sales_amount: Sales.sales_amount(),
      satisfaction: Sales.satisfaction()
    )
  end
end
