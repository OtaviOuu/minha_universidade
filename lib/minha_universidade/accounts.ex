defmodule MinhaUniversidade.Accounts do
  use Ash.Domain, otp_app: :minha_universidade, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource MinhaUniversidade.Accounts.Token
    resource MinhaUniversidade.Accounts.User
  end
end
