defmodule LiveViewStudioWeb.LicenseLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Licenses
  import Number.Currency

  def mount(_params, _session, socket) do
    seats = 2
    {:ok, assign(socket, seats: seats, amount: Licenses.calculate(seats))}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <h1>Team License</h1>
    <div id="license">
      <div class="card">
        <div class="content">
          <div class="seats">
            <img src="images/license.svg">
            <span>
              Your license is currently for
              <strong><%= @seats %></strong> seats.
            </span>
          </div>

          <form phx-change="update">
            <input type="range" min="1" max="10"
                  name="seats" value="<%= @seats %>" />
          </form>

          <div class="amount">
            <%= number_to_currency(@amount, [unit: "€"]) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("update", %{"seats" => seats} = fields, socket) do
    IO.inspect(fields)

    {:noreply,
     assign(
       socket,
       seats: seats,
       amount: Licenses.calculate(String.to_integer(seats))
     )}
  end
end
