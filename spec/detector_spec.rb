# frozen_string_literal: true

RSpec.describe SpaceInvaders::Detector do
  let(:invader_source) do
    <<~INVADER.strip
      ~~~~
      o--o
      -oo-
      ~~~~
    INVADER
  end
  let(:radar_source) do
    <<~RADAR.strip
      ~~~~
      -o-------------o--o----o------ooo-o-o-o-----
      o---------ooo----------o--o----------------o
      ------------------------oo------------------
      ------------------------------------o--o----
      o---------ooo-----------oo-----------oo----o
      -o--o-------------------------------------oo
      ~~~~
    RADAR
  end

  it 'detects `rat` invader' do
    invader = SpaceInvaders::Invader.new(name: 'rat', source: invader_source)
    segment = SpaceInvaders::Segment.new(source: radar_source)

    detector = described_class.new(segment:)
    detector.add_invader(invader:)
    detector.scan

    expect(detector.results.size).to eq(4)
    expect(detector.results).to eq(
      [
        { name: 'rat', coordinates: { x: 1..2, y: 23..26 } }, # center
        { name: 'rat', coordinates: { x: 3..4, y: 36..39 } }, # right
        { name: 'rat', coordinates: { x: 5..5, y: 1..4 } }, # bottom left corner
        { name: 'rat', coordinates: { x: 0..1, y: 0..1 } } # top left corner
      ]
    )
  end
end
