# frozen_string_literal: true

require 'openssl'
require 'uri'
require 'net/http'
require 'time'
require 'base64'
require 'jwt'

module UndercoverChecks
  class GithubChecks
    def initialize(repository, sha, app_id, app_installation_id, app_secret)
      @repository = repository
      @sha = sha
      @app_id = app_id
      @app_installation_id = app_installation_id
      @app_secret = app_secret
    end

    def send_result(conclusion, title, content)
      body = {
        name: 'Undercover checks',
        head_sha: @sha,
        details_url: 'https://www.github.com',
        status: 'completed',
        completed_at: Time.now.utc.iso8601,
        conclusion: conclusion,
        output: {
          title: title,
          summary: 'Diff coverage',
          text: content
        }
      }
      post_check(body)
    end

    private

    def build_app_jwt
      payload = {
        iat: Time.now.to_i,
        exp: Time.now.to_i + (10 * 60),
        iss: @app_id
      }

      JWT.encode(payload, OpenSSL::PKey::RSA.new(@app_secret), 'RS256')
    end

    def app_access_token
      uri = URI.parse("https://api.github.com/app/installations/#{@app_installation_id}/access_tokens")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.request_uri, { 'Authorization' => "Bearer #{build_app_jwt}" })
      res = http.request(req)
      JSON.parse(res.body)['token']
    end

    def post_check(body)
      uri = URI.parse("https://api.github.com/repos/#{@repository}/check-runs")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      req = Net::HTTP::Post.new(uri.request_uri,
                                { 'Authorization' => "token #{app_access_token}",
                                  'Accept' => 'application/vnd.github.antiope-preview+json' })
      req.body = body.to_json
      res = http.request(req)
      res.body
    end
  end
end
