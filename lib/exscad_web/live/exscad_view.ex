defmodule ExscadWeb.ExscadView do
  use ExscadWeb, :live_view

  def mount(_params, _session, socket) do
    openscadcode = """
    module example_intersection()
    {
    	intersection() {
    		difference() {
    			union() {
    				cube([30, 30, 30], center = true);
    				translate([0, 0, -25])
    					cube([15, 15, 50], center = true);
    			}
    			union() {
    				cube([50, 10, 10], center = true);
    				cube([10, 50, 10], center = true);
    				cube([10, 10, 50], center = true);
    			}
    		}
    		translate([0, 0, 5])
    			cylinder(h = 50, r1 = 20, r2 = 5, center = true);
    	}
    }

    example_intersection();
    """

    {stldata, _} = System.cmd("docker", ["run", "--rm", "openscad", openscadcode])
    {:ok, assign(socket, stldata: stldata, show: true, openscadcode: openscadcode)}
  end

  def render(assigns) do
    ~H"""
    <div class="codecontrols">
      <button phx-click="render">Render</button>
      <br />
      <%= if @show do %>
        <button phx-click="toggle">Hide Code</button>
        <br />
        <textarea field={@openscadcode} id="openscadcode" style="font-family:Courier"><%= @openscadcode %></textarea>
      <% else %>
        <button phx-click="toggle">Show Code</button>
        <br />
      <% end %>
    </div>
    <div>
      <canvas id="canvas" data-stl={@stldata} phx-hook="canvas" phx-update="ignore">
        Canvas is not supported!
      </canvas>
    </div>
    """
  end

  def handle_event("toggle", %{}, socket) do
    {:noreply, assign(socket, show: not socket.assigns.show)}
  end

  def handle_event("render", %{}, socket) do
    {stldata, _} = System.cmd("docker", ["run", "--rm", "openscad", socket.assigns.openscadcode])
    {:noreply, assign(socket, stldata: stldata)}
  end
end
