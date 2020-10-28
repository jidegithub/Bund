defmodule BundWeb.PowMailer do
  use Pow.Phoenix.Mailer
  use Bamboo.Mailer, otp_app: :bund
  
  import Bamboo.Email
  require Logger

  # def cast(%{user: user, subject: subject, text: text, html: html, assigns: _assigns}) do
  #   # Build email struct to be used in `process/1`

  #   %{to: user.email, subject: subject, text: text, html: html}
  # end
  
  def cast(%{user: user, subject: subject, text: text, html: html}) do
    new_email()
    |> to(user.email)
    |> from("olajide.o@ng.lopworks.com")
    |> subject(subject)
    |> html_body(html)
    |> text_body(text)
  end


  # def process(email) do
  #   # Send email
  #   deliver_now(email)
  #   # Logger.debug("E-mail sent: #{inspect email}")
  # end

  
  def process(email) do
    deliver_now(email)
  end
end