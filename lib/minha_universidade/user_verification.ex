defmodule MinhaUniversidade.UserVerification do
  use Ash.Domain,
    otp_app: :minha_universidade,
    extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource MinhaUniversidade.UserVerification.VerificationRequest
  end
end
