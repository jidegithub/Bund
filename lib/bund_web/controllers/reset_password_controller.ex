defmodule PowResetPassword.Phoenix.ResetPasswordController do
  use BundWeb, :controller

  # alias Bund.Repo
  alias Plug.Conn
  alias PowResetPassword.{Phoenix.Mailer, Plug}
  # alias Pow.{Plug}
  alias Pow.Plug, as: PowPlug
  use Pow.Extension.Phoenix.Controller.Base
  # alias BundWeb.Router.Helpers, as: Router
  # alias BundWeb.Router.Routes

  plug :load_user_from_reset_token when action in [:edit, :update]
  plug :assign_update_path when action in [:edit, :update]


  

  @spec process_new(Conn.t(), map()) :: {:ok, map(), Conn.t()}
  def process_new(conn, _params) do
    {:ok, Plug.change_user(conn), conn}
  end

  # prepares the browser to display a new email reset form
  @spec respond_new({:ok, map(), Conn.t()}) :: Conn.t()
  def respond_new({:ok, changeset, conn}) do
    conn
    |> assign(:changeset, changeset)
    |> assign(:msg, "")
    |> render("new.html")
  end

  # if there is an error verifying the email inputted
  def respond_create({:error, _any, conn}), do: default_respond_create(conn)

  # when there is no error, it sends the actual mail
  @spec respond_create({:ok | :error, map(), Conn.t()}) :: Conn.t()
  def respond_create({:ok, %{token: token, user: user}, conn}) do
    url = routes(conn).url_for(conn, __MODULE__, :edit, [token])
    deliver_email(conn, user, url)

    default_respond_create(conn)
  end

  def respond_create({:error, changeset, conn}) do
    case PowPlug.__prevent_user_enumeration__(conn, nil) do
      true ->
        conn
        |> put_flash(:info, extension_messages(conn).maybe_email_has_been_sent(conn))
        |> redirect(to: routes(conn).session_path(conn, :new))

      false ->
        conn
        |> assign(:changeset, changeset)
        |> put_flash(:error, extension_messages(conn).user_not_found(conn))
        |> render("new.html")
    end
  end

  
  # called by respond_create when there is an error or not, and further displayes the notification. also serves as a default
  defp default_respond_create(conn) do
    msg = "success"
    conn
    # |> put_flash(:info, "Password link successfully sent")
    # |> redirect(to: Routes.pow_reset_password_reset_password_path(conn, :new))
    |> render("success.html", layout: {BundWeb.LayoutView, "app.html"}, msg: msg)
  end

  # process the creation by getting the specific user that requested the reset and create a reset-token
  def process_create(conn, %{"user" => user_params}) do
    PowResetPassword.Plug.create_reset_token(conn, user_params)
  end

  
  # finds the email module and forward email
  defp deliver_email(conn, user, url) do
    email = Mailer.reset_password(conn, user, url)

    Pow.Phoenix.Mailer.deliver(conn, email)
  end

  # defp default_respond_create(conn) do
  #   conn
  #   |> put_flash(:info, "Password link successfully sent from default")
  #   |> assign(:msg, "Success")
  #   |> put_flash(:info, extension_messages(conn).email_has_been_sent(conn))
  #   |> redirect(to: Routes.session_path(conn, :new))
  # end

  def process_edit(conn, _params) do
    {:ok, Plug.change_user(conn), conn}
  end

  def respond_edit({:ok, changeset, conn}) do
    conn
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end


  

  def process_update(conn, %{"user" => user_params}) do
    Plug.update_user_password(conn, user_params)
  end

  def respond_update({:ok, _user, conn}) do
    conn
    |> put_flash(:info, extension_messages(conn).password_has_been_reset(conn))
    |> redirect(to: routes(conn).session_path(conn, :new))
  end
  def respond_update({:error, changeset, conn}) do
    conn
    |> assign(:changeset, changeset)
    |> render("edit.html")
  end

   defp load_user_from_reset_token(%{params: %{"id" => token}} = conn, _opts) do
    case Plug.user_from_token(conn, token) do
      nil ->
        conn
        |> put_flash(:error, extension_messages(conn).invalid_token(conn))
        |> redirect(to: routes(conn).path_for(conn, __MODULE__, :new))
        |> halt()

      user ->
        Plug.assign_reset_password_user(conn, user)
    end
  end

  defp assign_update_path(conn, _opts) do
    token = conn.params["id"]
    path  = routes(conn).path_for(conn, __MODULE__, :update, [token])
    Conn.assign(conn, :action, path)
  end

end