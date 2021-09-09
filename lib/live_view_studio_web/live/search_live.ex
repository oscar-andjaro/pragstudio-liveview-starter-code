defmodule LiveViewStudioWeb.SearchLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Stores

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       zip: "",
       stores: Stores.list_stores(),
       loading: false
     )}
  end

  def render(assigns) do
    ~L"""
    <h1>Find a Store</h1>
    <div id="search">
    <form phx-submit="zip_search">
      <input name="zip" value="<%= @zip %>" placeholder="Insert the ZIP code here" style="width: 400px; padding: 3px 10px;"/>
      <button style="display: none;">Search</button>
    </form>

    <%= if @loading do %>
    <div class="loader">
      Loading...
    </div>
    <% end %>

    <div class="stores">
    <ul>
      <%= for store <- @stores do %>
        <li>
          <div class="first-line">
            <div class="name">
              <%= store.name %>
            </div>
            <div class="status">
              <%= if store.open do %>
                <span class="open">Open</span>
              <% else %>
                <span class="closed">Closed</span>
              <% end %>
            </div>
          </div>
          <div class="second-line">
            <div class="street">
              <img src="images/location.svg">
              <%= store.street %>
            </div>
            <div class="phone_number">
              <img src="images/phone.svg">
              <%= store.phone_number %>
            </div>
          </div>
        </li>
      <% end %>
    </ul>
    </div>

    </div>

    """
  end

  def handle_event("zip_search", %{"zip" => zip}, socket) do
    send(self(), {:perform_zip_search, zip})

    {:noreply,
     assign(
       socket,
       zip: zip,
       loading: true
     )}
  end

  def handle_info({:perform_zip_search, zip}, socket) do
    socket =
      case Stores.search_by_zip(zip) do
        [] ->
          socket |> put_flash(:info, "No results found") |> assign(loading: false, stores: [])

        _ ->
          assign(
            socket,
            stores: Stores.search_by_zip(zip),
            loading: false
          )
      end

    {:noreply, socket}
  end
end
