defmodule Issues.GithubIssues do
  require Logger

  @user_agent [{"User-agent", "Elixir yiqiao.wang96@gmail.com"}]
  @github_url Application.get_env(:issues, :github_url)

  def fetch(user, project) do
    Logger.info "Fetching user #{user}'s project #{project}"
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Logger.info "Successful response"
        Logger.debug fn -> inspect(body) end
        {:ok, Poison.Parser.parse!(body)}
      {_, %HTTPoison.Response{status_code: err_code}} ->
        Logger.error "Error #{err_code} returned"
        {:error, "Error code: #{err_code}"}
    end
  end
end
