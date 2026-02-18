defmodule MinhaUniversidade.UserVerification.Changes.AttachUniversityToUser do
  use Ash.Resource.Change

  def change(changeset, _opts, _ctx) do
    Ash.Changeset.after_action(changeset, fn changeset, result ->
      university_id = Map.get(result, :applied_university_id)
      user_id = Map.get(result, :user_id)

      MinhaUniversidade.Accounts.attach_university(user_id, university_id, authorize?: false)
      {:ok, result}
    end)
  end
end
