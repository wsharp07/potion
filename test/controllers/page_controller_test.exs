defmodule Potion.PageControllerTest do
  use Potion.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Welcome to Potion!"
  end
end
