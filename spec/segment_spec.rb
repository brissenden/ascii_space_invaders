# frozen_string_literal: true

RSpec.describe SpaceInvaders::Segment do
  let(:source) do
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

  let(:corrupted_source) do
    <<~INVADER.strip
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
  end

  let(:wrong_source) do
    <<~INVADER.strip
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
  end

  let(:segment) { described_class.new(x: 1, y: 2, source:) }

  it 'builds segment from the source' do
    expect(segment.to_s).to eq(source)
    expect(segment.coordinates).to eq({ x: 1, y: 2 })
  end

  it 'matches invader with 100% similarity' do
    invader = SpaceInvaders::Invader.new(name: 'face', source:)
    expect(segment.match?(invader:)).to be(true)
  end

  it 'skips the match if the noise is too high' do
    invader = SpaceInvaders::Invader.new(name: 'face', source: wrong_source)
    expect(segment.match?(invader:)).to be(false)
  end
end
