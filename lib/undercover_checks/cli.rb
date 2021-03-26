# frozen_string_literal: true

# app_id: 81455
# app_installation_id: 11913774
# app_secret e1a9a3078beba126107859546dc0a8c9f178c26d

require 'undercover'
require_relative 'github_checks'
require_relative 'result_parser'

module UndercoverChecks
  class CLI
    def self.run(args)
      cli_args = Hash[args.each_slice(2).to_a]
      args = {}
      args[:repository] = cli_args['--repository']
      args[:sha] = cli_args['--sha']
      args[:lcov_path] = cli_args['--lcov']
      args[:minimum_delta] = (cli_args['--minimum-delta'] || 80).to_i
      args[:app_id] = cli_args['--app-id']
      args[:app_installation_id] = cli_args['--app-installation-id']
      args[:app_secret] = cli_args['--app-secret']

      raise 'repository is required (--repository).' unless args[:repository]
      raise 'sha commmit is required (--sha).' unless args[:sha]
      raise 'app-id is required (--app-id).' unless args[:app_id]
      raise 'app-installation-id commmit is required (--app-installation-id).' unless args[:app_installation_id]
      raise 'app-secret commmit is required (--app-secret).' unless args[:app_secret]

      undercover_args = ['-c', 'origin/master']
      undercover_args.concat(['--lcov', args[:lcov_path]]) if args[:lcov_path]

      options = Undercover::Options.new.parse(undercover_args)
      report = Undercover::Report.new(Undercover::CLI.changeset(options), options).build.flagged_results
      parser = ResultParser.new(args[:minimum_delta], report)
      GithubChecks
        .new(*args.values_at(:repository, :sha, :app_id, :app_installation_id, :app_secret))
        .send_result(
          parser.success?,
          parser.title,
          parser.markdown
        )
    end
  end
end
