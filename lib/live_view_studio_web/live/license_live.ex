defmodule LiveViewStudioWeb.LicenseLive do
  use LiveViewStudioWeb, :live_view
  alias LiveViewStudio.Licenses

  def mount(_params, _session, socket) do
    seats = 2
    {:ok, assign(socket, seats: seats, amount: Licenses.calculate(seats))}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
  end
end
