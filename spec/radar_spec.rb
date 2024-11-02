# frozen_string_literal: true

RSpec.describe SpaceInvaders::Radar do
  let(:source) do
    <<~RADAR.strip
      ~~~~
      --------ooooooo-
      ------o---------
      -----o----------
      -----o-o-o-o----
      --oo-o----o-o-o-
      ~~~~
    RADAR
  end

  let(:radar) { described_class.new(source:) }

  it 'builds segments (all rows, 2 columns wide) from the source' do
    segments_of_two = radar.segments(rows: 5, columns: 2).map(&:to_s)

    expect(segments_of_two.size).to eq(15)
    expect(segments_of_two.first).to eq("--\n--\n--\n--\n--")
    expect(segments_of_two.last).to eq("o-\n--\n--\n--\no-")
  end

  it 'builds 2 x 2 square segments from the source' do
    segments_of_two = radar.segments(rows: 2, columns: 2).map(&:to_s)

    expect(segments_of_two.size).to eq(60)
    expect(segments_of_two.first).to eq("--\n--")
    expect(segments_of_two.last).to eq("--\no-")
  end
end
