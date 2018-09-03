defmodule Benum do
  @moduledoc """
  A module to add enumerable to bitstring

  from https://gist.github.com/brweber2/b724969b5d1d35443e6c
  """
  defimpl Enumerable, for: BitString do
    def count(collection) when is_binary(collection) do
      {:ok, Enum.reduce(collection, 0, fn _v, acc -> acc + 1 end)}
    end
    def count(_collection) do
      {:error, __MODULE__}
    end
    def member?(collection, value) when is_binary(collection) do
      {:ok, Enum.any?(collection, fn v -> value == v end)}
    end
    def member?(_collection, _value) do
      {:error, __MODULE__}
    end

    def reduce(b,     {:halt, acc}, _fun) when is_binary(b) do
      {:halted, acc}
    end
    def reduce(b,  {:suspend, acc}, fun) when is_binary(b) do
      {:suspended, acc, &reduce(b, &1, fun)}
    end
    def reduce(<<>>,  {:cont, acc}, _fun) do
      {:done, acc}
    end
    def reduce(<<h :: bytes-size(1), t :: binary>>, {:cont, acc}, fun) do
      reduce(t, fun.(h, acc), fun)
    end
  end
end

