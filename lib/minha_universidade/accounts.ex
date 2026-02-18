defmodule MinhaUniversidade.Accounts do
  use Ash.Domain, otp_app: :minha_universidade, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource MinhaUniversidade.Accounts.Token

    resource MinhaUniversidade.Accounts.User do
      define :attach_university, action: :attach_university, args: [:university_id]
    end
  end
end
