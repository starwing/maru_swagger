defmodule MaruSwagger.DSL do
  defmacro swagger(options) do
    only = options |> Keyword.get(:only)
    except = options |> Keyword.get(:except)

    guard =
      case {only, except} do
        {nil, nil} -> true
        {nil, _} -> not (Mix.env() in except)
        {_, nil} -> Mix.env() in only
        _ -> raise ":only and :except are in conflict!"
      end

    quote do
      if unquote(guard) do
        @plugs_before {
          MaruSwagger.Plug,
          unquote(options)
          |> Keyword.drop([:only, :except])
          |> Keyword.put(:module, __MODULE__),
          true
        }
      end
    end
  end
end
