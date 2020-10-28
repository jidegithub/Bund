defmodule BundWeb.LayoutView do
  use BundWeb, :view

  def is_active_module?(conn, name) do
    a = Phoenix.Controller.controller_module(conn)
    [_, _, d] = (to_string a) |> String.split(".")
    [e, _] = String.split(d, "Controller")
    if e == name, do: " active ", else: ""
  end

end
