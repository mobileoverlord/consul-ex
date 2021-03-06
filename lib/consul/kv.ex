#
# The MIT License (MIT)
#
# Copyright (c) 2014-2015 Undead Labs, LLC
#

defmodule Consul.Kv do
  alias Consul.Endpoint
  alias Consul.Response
  use Consul.Endpoint, handler: Consul.Handler.Kv

  @kv "kv"

  @spec fetch(binary | [binary], Keyword.t) :: Endpoint.response
  def fetch(key, opts \\ []) do
    List.flatten([@kv, key]) |> req_get(opts)
  end

  @spec fetch!(binary | [binary], Keyword.t) :: Response.t | no_return
  def fetch!(key, opts \\ []) do
    case fetch(key, opts) do
      {:ok, value} ->
        value
      {:error, response} ->
        raise(Consul.ResponseError, response)
    end
  end

  @spec keys(binary | [binary]) :: Endpoint.response
  def keys(prefix) do
    List.flatten([@kv, prefix]) |> req_get(keys: true)
  end

  @spec keys!(binary | [binary]) :: Response.t | no_return
  def keys!(prefix) do
    case keys(prefix) do
      {:ok, value} ->
        value
      {:error, response} ->
        raise(Consul.ResponseError, response)
    end
  end

  @spec put(binary | [binary], term, Keyword.t) :: boolean
  def put(key, value, opts \\ []) do
    case List.flatten([@kv, key]) |> req_put(to_string(value), opts) do
      {:ok, %{body: body}} ->
        body
      error ->
        error
    end
  end

  @spec put!(binary | [binary], term, Keyword.t) :: Response.t | no_return
  def put!(key, value, opts \\ []) do
    case put(key, value, opts) do
      {:error, response} ->
        raise(Consul.ResponseError, response)
      result ->
        result
    end
  end

  @spec delete(binary | [binary], Keyword.t) :: Endpoint.response
  def delete(key, opts \\ []) do
    List.flatten([@kv, key]) |> req_delete(opts)
  end

  @spec delete!(binary | [binary], Keyword.t) :: Response.t | no_return
  def delete!(key, opts \\ []) do
    case delete(key, opts) do
      {:ok, value} ->
        value
      {:error, response} ->
        raise(Consul.ResponseError, response)
    end
  end
end
