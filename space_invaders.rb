# frozen_string_literal: true

require 'mini-levenshtein'

module SpaceInvaders
  DEF_PATTERN = '~~~~'

  class Segment
    SIMILARITY_THRESHOLD = ENV.fetch('SIMILARITY', 0.90).to_f

    def initialize(source:, x: 0, y: 0)
      self.x = x
      self.y = y
      self.source = source.gsub(DEF_PATTERN, '').strip
    end

    def to_s
      source
    end

    def total_rows
      lines.size
    end

    def total_columns
      lines.first.size
    end

    def dimensions
      { rows: total_rows, columns: total_columns }
    end

    def coordinates
      { x:, y: }
    end

    def match?(other_segment:)
      score = MiniLevenshtein.similarity(source, other_segment.to_s)
      score > SIMILARITY_THRESHOLD
    end

    def sub_segments(rows:, columns:)
      rows_count = lines.size
      column_count = lines.first.size

      segments = []
      (rows - 1..rows_count - 1).each do |row_index| # Read rows (top -> bottom)
        (columns - 1..column_count - 1).each do |column_index| # Read columns (left -> right)
          x_range = row_index - rows + 1..row_index
          y_range = column_index - columns + 1..column_index

          segments << trim(rows: x_range, columns: y_range)
        end
      end
      segments
    end

    def edges(rows:, columns:)
      horizontal_edges(rows:) + vertical_edges(columns:)
    end

    def horizontal_edges(rows:)
      [
        { rows: 0..rows - 1, columns: 0..total_columns }, # top edge
        { rows: total_rows - rows..total_rows, columns: 0..total_columns } # bottom edge
      ].map do |dimensions|
        trim(**dimensions)
      end
    end

    def vertical_edges(columns:)
      [
        { rows: 0..total_rows, columns: 0..columns - 1 }, # left edge
        { rows: 0..total_rows, columns: total_columns - columns..total_columns } # right side
      ].map do |dimensions|
        trim(**dimensions)
      end
    end

    private

    attr_accessor :x, :y, :source

    def trim(rows:, columns:)
      new_source = lines[rows].map { _1[columns] }.join("\n")

      rows = rows.min + Array(x).min..rows.max + Array(x).min
      columns = columns.min + Array(y).min..columns.max + Array(y).min

      Segment.new(source: new_source, x: rows, y: columns)
    end

    def lines
      source.split("\n")
    end
  end

  class Invader < Segment
    attr_accessor :name

    def initialize(name:, source:)
      super(source:)
      self.name = name
    end

    def variants
      sub_rows = dimensions[:rows] / 2
      sub_columns = dimensions[:columns] / 2

      horizontal_edges(rows: sub_rows).reverse + vertical_edges(columns: sub_columns).reverse
    end
  end

  class Detector
    attr_accessor :results

    def initialize(segment:)
      self.segment = segment
      self.invaders = []
      self.results = []
    end

    def add_invader(invader:)
      invaders << invader
    end

    def scan
      invaders.each do |invader|
        # Main area scanning
        segment.sub_segments(**invader.dimensions).each do |sub_segment|
          next unless sub_segment.match?(other_segment: invader)

          results << {
            name: invader.name,
            coordinates: sub_segment.coordinates
          }
        end

        # Edge cases scanning
        segment_edges = segment.edges(
          rows: invader.dimensions[:rows] / 2,
          columns: invader.dimensions[:columns] / 2
        )
        invader_variants = invader.variants
        segment_edges.zip(invader_variants).each do |edge_segment, invader_variant|
          edge_segment.sub_segments(**invader_variant.dimensions).each do |sub_segment|
            next unless sub_segment.match?(other_segment: invader_variant)

            results << {
              name: invader.name,
              coordinates: sub_segment.coordinates
            }
          end
        end
      end
    end

    def summary
      segment.total_rows.times do |x|
        segment.total_columns.times do |y|
          if results.any? { _1[:coordinates][:x].include?(x) && _1[:coordinates][:y].include?(y) }
            print 'x'
          else
            print '-'
          end
        end
        puts "\n"
      end
    end

    private

    attr_accessor :segment, :invaders
  end
end
