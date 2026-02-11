defmodule MinhaUniversidade.UserVerification do
  use Ash.Domain,
    otp_app: :minha_universidade

  resources do
    resource MinhaUniversidade.UserVerification.VerificationRequest
  end
end
