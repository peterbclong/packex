defmodule Packex.Routes do
  use Maru.Router

  @moduledoc """
  Package manipulation end-points.
  """

  plug Plug.Logger

  plug Plug.Parsers,
    pass: ["*/*"],
    json_decoder: Poison,
    parsers: [:urlencoded, :json]

  namespace :packages do

    post do
      id =
        conn.params
        |> populate_products()
        |> populate_price("USD")
        |> Packex.Store.create()
      conn
      |> put_status(201)
      |> put_resp_header("location", "/packages/" <> id)
      |> text("created")
    end

    get do
      json(conn, Packex.Store.read_all())
    end

    route_param :id, type: :string do

      get do
        json(conn, populate_price(Packex.Store.read(params[:id]), Map.get(conn.params, "currency", "USD")))
      end

      delete do
        json(conn, Packex.Store.delete(params[:id]))
      end

      put do
        conn.params
        |> populate_products()
        |> populate_price("USD")
        |> Packex.Store.update()
        conn
        |> put_status(204)
        |> text("")
      end
    end
  end

  defp populate_products(package) do
    Map.replace(package,
                "products",
                Enum.map(Map.get(package, "products"),
                         &Map.merge(&1, Packex.ProductService.product_info(Map.get(&1, "id")))))
  end

  defp populate_price(package, currency) do
    Map.put(package,
            "price",
            Packex.ExchangeRateService.exchange_rate(currency) *
              Enum.reduce(Map.get(package, "products"), 0.0, &(Map.get(&1, "usdPrice", 0.0) + &2)))
  end
end

