defmodule Inn.Checker do
  @moduledoc """
  The Checker context.
  """

  import Ecto.Query, warn: false
  alias Inn.Repo

  alias Inn.Checker.Tin

  alias InnProtocol

  use Paginator

  @doc """
  Returns the list of tins.

  ## Examples

      iex> list_tins()
      [%Tin{}, ...]

  """
  def list_tins do
    Repo.all(Tin)
  end

  def list_paging(page , limit \\ 5) do
    o = (page - 1) * limit

    query =
      from(t in Tin,
        order_by: [desc: t.inserted_at],
        limit: ^limit,
        offset: ^o
      )

    Repo.all(query)
  end

  def meta_paging(page, limit \\ 5 ) do
    query = from(t in Tin, select: count(t.id))
    total = Repo.one(query)

    last_page = if rem(total,limit)===0, do: total/limit, else: div(total,limit) + 1
    previous_page = if page <= 1 , do: 1, else: page-1
    next_page = if page < last_page, do: page + 1, else: last_page
    meta = %{
      :current_page => page,
      :next_page => next_page, 
      :previous_page => previous_page,
      :first_page => 1,
      :last_page => last_page,
      :total => total
      
    }
  end

  @doc """
  Gets a single tin.

  Raises `Ecto.NoResultsError` if the Tin does not exist.

  ## Examples

      iex> get_tin!(123)
      %Tin{}

      iex> get_tin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tin!(id), do: Repo.get!(Tin, id)

  def get_tin(id), do: Repo.get(Tin, id)

  @doc """
  Creates a tin.

  ## Examples

      iex> create_tin(%{field: value})
      {:ok, %Tin{}}

      iex> create_tin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tin(attrs \\ %{}) do
    %Tin{}
    |> Tin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tin.

  ## Examples

      iex> update_tin(tin, %{field: new_value})
      {:ok, %Tin{}}

      iex> update_tin(tin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tin(%Tin{} = tin, attrs) do
    tin
    |> Tin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tin.

  ## Examples

      iex> delete_tin(tin)
      {:ok, %Tin{}}

      iex> delete_tin(tin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tin(%Tin{} = tin) do
    Repo.delete(tin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tin changes.

  ## Examples

      iex> change_tin(tin)
      %Ecto.Changeset{data: %Tin{}}

  """
  def change_tin(%Tin{} = tin, attrs \\ %{}) do
    Tin.changeset(tin, attrs)
  end

  def verify_tin_number(number) do
    InnProtocol.validate(number)
  end
end
