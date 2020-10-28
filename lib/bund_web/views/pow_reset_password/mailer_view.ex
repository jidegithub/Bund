defmodule BundWeb.PowResetPassword.MailerView do
  use BundWeb, :mailer_view

  def subject(:reset_password, _assigns), do: "Reset password link"
end