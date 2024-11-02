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

  it 'builds segment from the source' do
    expect(segment.to_s).to eq(invader_source)
    expect(segment.coordinates).to eq({ x: 1, y: 2 })
  end

  it 'matches invader with 100% similarity' do
    invader = SpaceInvaders::Invader.new(name: 'face', source: invader_source)
    expect(segment.match?(invader:)).to be(true)
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
    expect(segment.match?(invader:)).to be(true)
  end

  it 'matches partial invader' do
    partial_row_source = <<~INVADER.strip
      ~~~~
      -----------
      -----------
      -----------
      --o--------
      -------o---
      --oo-oooo--
      -oo-ooo-oo-
      oooo-oooooo
      ~~~~
    INVADER
    invader = SpaceInvaders::Invader.new(name: 'face', source: partial_row_source)
    expect(segment.match?(invader:)).to be(true)

    partial_column_source = <<~INVADER.strip
      ~~~~
      ---o-------
      --o--------
      oooo-------
      oo-oo------
      oooooo-----
      oooo-o-----
      ---o-o-----
      -oo--------
      ~~~~
    INVADER
    invader = SpaceInvaders::Invader.new(name: 'face', source: partial_column_source)
    expect(segment.match?(invader:)).to be(true)
  end

  it 'skips the match if the noise is too high' do
    source = <<~INVADER.strip
      ~~~~
      --o--------
      -------o---
      --oo-oooo--
      -oo-ooo-oo-
      oooo-o---oo
      o-----o-o-o
      o-o-----o-o
      ---oo-oo---
      ~~~~
    INVADER
    invader = SpaceInvaders::Invader.new(name: 'face', source:)
    expect(segment.match?(invader:)).to be(false)
  end
end
