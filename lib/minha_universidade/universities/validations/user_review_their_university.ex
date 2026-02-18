defmodule MinhaUniversidade.Universities.Validations.UserReviewTheirUniversity do
  use Ash.Resource.Validation

  def validate(_changeset, _opts, context) do
    %{actor: actor, source_context: %{university_id: university_id}} = context

    IO.inspect(university_id)
    IO.inspect(actor.university_id)

    if actor.university_id == university_id do
      :ok
    else
      {:error, "You can only review your own university"}
    end
  end
end
