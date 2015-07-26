require "github_api"
require "pry"

describe GithubApi do
  describe ".pull_request_status" do
    it "returns :open for open pull requests" do
      response_json = pull_request_response_json
      response_json["state"] = "open"
      pull_request_url = "https://api.github.com/repos/thoughtbot/suspenders/pulls/590"
      stub_web_request(pull_request_url, response_json)

      status = GithubApi.pull_request_status(pull_request_url)

      expect(status).to eq(:open)
    end

    it "returns :closed for closed pull requests" do
      response_json = pull_request_response_json
      response_json["state"] = "closed"
      pull_request_url = "https://api.github.com/repos/thoughtbot/suspenders/pulls/590"
      stub_web_request(pull_request_url, response_json)

      status = GithubApi.pull_request_status(pull_request_url)

      expect(status).to eq(:closed)
    end
  end

  def stub_web_request(url, json_response)
    stub_request(:get, url).to_return(body: json_response.to_json)
  end

  def pull_request_response_json
    JSON.parse(File.read("spec/support/github_responses/pull_request.json"))
  end
end
