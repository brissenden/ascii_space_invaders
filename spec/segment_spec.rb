# frozen_string_literal: true

RSpec.describe SpaceInvaders::Segment do
  let(:invader_source) do
    <<~SEGMENT.strip
      ~~~~
      --o-----o--
      ---o---o---
      --ooooooo--
      -oo-ooo-oo-
      ooooooooooo
      o-ooooooo-o
      o-o-----o-o
      ---oo-oo---
      ~~~~
    SEGMENT
  end

  let(:segment) { described_class.new(x: 1, y: 2, source: invader_source) }

  describe '#coordinates' do
    it 'returns coordinates' do
      expect(segment.coordinates).to eq({ x: 1, y: 2 })
    end
  end

  describe '#dimensions' do
    it 'returns dimensions' do
      expect(segment.dimensions).to eq({ rows: 8, columns: 11 })
    end
  end

  describe '#dimensions' do
    it 'returns formatted source' do
      expect(segment.to_s).to eq("--o-----o--\n---o---o---\n--ooooooo--\n-oo-ooo-oo-\nooooooooooo\no-ooooooo-o\no-o-----o-o\n---oo-oo---")
    end
  end

  describe '#sub_segments' do
    it 'builds sub-segments (all rows, 2 columns)' do
      sub_segments = segment.sub_segments(rows: 8, columns: 2).map(&:to_s)

      expect(sub_segments.size).to eq(10)
      expect(sub_segments.first).to eq("--\n--\n--\n-o\noo\no-\no-\n--")
      expect(sub_segments.last).to eq("--\n--\n--\no-\noo\n-o\n-o\n--")
    end

    it 'builds sub-segments (2 rows, all columns)' do
      sub_segments = segment.sub_segments(rows: 2, columns: 11).map(&:to_s)

      expect(sub_segments.size).to eq(7)
      expect(sub_segments.first).to eq("--o-----o--\n---o---o---")
      expect(sub_segments.last).to eq("o-o-----o-o\n---oo-oo---")
    end

    it 'builds 2 x 2 square sub-segments' do
      sub_segments = segment.sub_segments(rows: 2, columns: 2).map(&:to_s)

      expect(sub_segments.size).to eq(70)
      expect(sub_segments.first).to eq("--\n--")
      expect(sub_segments.last).to eq("-o\n--")
    end
  end

  describe '#match?' do
    it 'matches invader with 100% similarity' do
      invader = SpaceInvaders::Invader.new(name: 'face', source: invader_source)
      expect(segment.match?(other_segment: invader)).to be(true)
    end

    it 'matches corrupted invader' do
      source = <<~INVADER.strip
        ~~~~
        --o--------
        -------o---
        --oo-oooo--
        -oo-ooo-oo-
        oooo-oooooo
        o-ooooo-o-o
        o-o-----o-o
        ---oo-oo---
        ~~~~
      INVADER
      invader = SpaceInvaders::Invader.new(name: 'face', source:)
      expect(segment.match?(other_segment: invader)).to be(true)
    end

    it 'skips the match if the noise is too high' do
      source = <<~INVADER.strip
        ~~~~
        --o--------
        -------o---
        --oo----o--
        -oo-ooo-oo-
        oo-------oo
        o----------
        o-o-----o-o
        ---oo-oo---
        ~~~~
      INVADER
      invader = SpaceInvaders::Invader.new(name: 'face', source:)
      expect(segment.match?(other_segment: invader)).to be(false)
    end
  end
end
