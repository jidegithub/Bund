defmodule Bund.Email do
  import Bamboo.Email
  require Logger

  def cast(%{user: user, subject: subject, text: text, html: html, assigns: _assigns}) do
    # Build email struct to be used in `process/1`

    %{to: user.email, subject: subject, text: text, html: html}
  end

  def process(email) do
    # Send email

    Logger.debug("E-mail sent: #{inspect email}")
  end

  def reset_password_email(to, subject, body) do
    new_email()
    |> to(to)
    |> from("olajide.o@ng.lopworks.com")
    |> subject(subject)
    |> html_body(body)
    |> text_body(body)
  end
end