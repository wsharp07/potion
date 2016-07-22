defmodule Potion.PageControllerTest do
  use Potion.ConnCase

  test "GET /" do
    conn = get build_conn(), "/"
    assert html_response(conn, 200) =~ "<!-- Page Index -->"
  end
end
