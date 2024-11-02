# frozen_string_literal: true

require 'mini-levenshtein'

module SpaceInvaders
  DEF_PATTERN = '~~~~'
  SIMILARITY_THRESHOLD = ENV.fetch('SIMILARITY', 0.90).to_f

  class Radar
    def initialize(source:)
      # TODO: Add padding on left/right/top/bottom for better edge case handling
      self.source = source.gsub(DEF_PATTERN, '').strip
    end

    def segments(rows:, columns:)
      rows_count = lines.size
      column_count = lines.first.size

      segments = []
      (rows - 1..rows_count - 1).each do |row_index| # Read rows (top -> bottom)
        (columns - 1..column_count - 1).each do |column_index| # Read columns (left -> right)
          x_range = row_index - rows + 1..row_index
          y_range = column_index - columns + 1..column_index
          segment_source = lines[x_range].map { _1[y_range] }.join("\n") # Radar segment source

          segments << Segment.new(x: x_range, y: y_range, source: segment_source)
        end
      end
      segments
    end

    private

    attr_accessor :source

    def lines
      @lines ||= source.split("\n")
    end
  end

  class Segment
    def initialize(x:, y:, source:)
      self.x = x
      self.y = y
      self.source = source
    end

    def to_s
      source
    end

    def coordinates
      { x:, y: }
    end

    def match?(invader:)
      score = MiniLevenshtein.similarity(source, invader.to_s)
      score > SIMILARITY_THRESHOLD
    end

    private

    attr_accessor :x, :y, :source
  end

  class Invader
    attr_accessor :name

    def initialize(name:, source:)
      self.name = name
      self.source = source.gsub(DEF_PATTERN, '').strip
    end

    def to_s
      source
    end

    def dimensions
      lines = source.split("\n")
      rows = lines.size
      columns = lines.first.size
      { rows:, columns: }
    end

    private

    attr_accessor :source
  end

  class Detector
    attr_accessor :results

    def initialize(radar:)
      self.radar = radar
      self.invaders = []
      self.results = []
    end

    def add_invader(invader:)
      invaders << invader
    end

    def scan
      invaders.each do |invader|
        radar.segments(**invader.dimensions).each do |segment|
          results << { name: invader.name, coordinates: segment.coordinates } if segment.match?(invader:)
        end
      end
    end

    def print
      puts results
    end

    private

    attr_accessor :radar, :invaders
  end
end
