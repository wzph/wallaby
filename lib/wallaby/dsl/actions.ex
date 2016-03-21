defmodule Wallaby.DSL.Actions do
  alias Wallaby.Session
  alias Wallaby.Node
  alias Wallaby.DSL.Matchers
  alias Wallaby.DSL.Finders
  import Wallaby.XPath

  def fill_in(session, query, with: value) when is_binary(value) do
    Finders.find(session, {:xpath, fillable_field(query)})
    |> fill_in(with: value)
  end

  def fill_in(%Node{session: session, id: id}, with: value) when is_binary(value) do
    node
    |> set_value
    Session.request(
      :post,
      "#{session.base_url}session/#{session.id}/element/#{id}/value",
      %{value: [value]}
    )
    session
  end

  def clear(session, query) when is_binary(query) do
    Finders.find(session, {:xpath, fillable_field(query)})
    |> clear()
  end

  def clear(%Node{session: session, id: id}) do
    Session.request(:post, "#{session.base_url}session/#{session.id}/element/#{id}/clear")
  end

  def choose(%Session{}=session, query) when is_binary(query) do
    Finders.find(session, {:xpath, radio_button(query)})
    |> click
  end

  def choose(%Node{}=node) do
    click(node)
  end

  def check(%Node{}=node) do
    unless Matchers.checked?(node) do
      click(node)
    end
    node
  end
  def check(%Session{}=session, query) do
    Finders.find(session, {:xpath, checkbox(query)})
    |> check
    session
  end

  def uncheck(%Node{}=node) do
    if Matchers.checked?(node) do
      click(node)
    end
    node
  end
  def uncheck(%Session{}=session, query) do
    Finders.find(session, {:xpath, checkbox(query)})
    |> uncheck
    session
  end

  def click(session, query) do
    Finders.find(session, query)
  end

  def click(%Node{session: session, id: id}) do
    Session.request(:post, "#{session.base_url}session/#{session.id}/element/#{id}/click")
  end
end
