# frozen_string_literal: true

module UndercoverChecks
  class ResultParser
    FileResult = Struct.new(:path, :coverage, :nodes)

    attr_reader :total_undercover

    def initialize(min_coverage, result)
      @min_coverage = min_coverage
      @result = result
      build
    end

    def build
      @files_results = {}
      @result.each do |result|
        path = result.file_path
        @files_results[path] ||= FileResult.new(path, 0.0, [])
        @files_results[path].nodes << result.pretty_print_lines
      end

      for_total_to_cover = 0
      for_total_to_covered = 0
      @files_results.each_value do |file_result|
        number_of_line_to_cover = file_result.nodes.flatten(1).count(&:first)
        number_of_line_to_covered = file_result.nodes.flatten(1).count { |node| node.first&.positive? }
        for_total_to_cover += number_of_line_to_cover
        for_total_to_covered += number_of_line_to_covered
        file_result.coverage = number_of_line_to_covered.to_f / number_of_line_to_cover
      end
      @total_undercover = (for_total_to_covered.to_f / for_total_to_cover) * 100
    end

    def markdown
      md = +''
      @files_results.each_value do |result|
        md << "### `#{result.path}` (#{(result.coverage * 100).round(2)}%)\n"
        result.nodes.each do |node|
          md << "```diff\n"
          node.each { |line| md << line_to_md(line) }
          md << "```\n"
        end
      end
      md
    end

    def title
      return 'Undercover: No coverage required' if nothing_undercover?

      "Undercover: #{@total_undercover.round(2)}% (required #{@min_coverage}%)"
    end

    def success?
      return 'success' if nothing_undercover?

      @total_undercover >= @min_coverage ? 'success' : 'failure'
    end

    private

    def line_to_md(line)
      diff_char =
        case line.first
        when 0
          '-'
        when nil
          ' '
        else
          '+'
        end
      "#{diff_char} #{line.last.first} #{line.last.last}\n"
    end

    def nothing_undercover?
      @result.empty?
    end
  end
end
