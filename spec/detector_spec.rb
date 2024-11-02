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
      ---------------oo-o----o------ooo-o-o-o-----
      -----------------------o--o-----------------
      ------------------------oo------------------
      -----o-o-o-o----o----oo-----------oo-oo-o---
      --oo-o----o-o-o-o----o-o------o-o--o----o---
      -oo-o---o--oo-o-o----o-oo---o-oooo-o---o-o--
      -ooo---o-o-----o-o-o--o--o-----------o------
      -------------o-o-o-o-o-----o-o-o------------
      --------------------------o-o-o-o-o---------
      ~~~~
    RADAR
  end

  it 'detects `rat` invader' do
    invader = SpaceInvaders::Invader.new(name: 'rat', source: invader_source)
    radar = SpaceInvaders::Radar.new(source: radar_source)

    detector = described_class.new(radar:)
    detector.add_invader(invader:)
    detector.scan

    expect(detector.results.size).to eq(2)
    expect(detector.results).to eq(
      [
        { coordinates: { x: 1..2, y: 23..26 }, name: 'rat' },
        { coordinates: { x: 5..6, y: 8..11 }, name: 'rat' }
      ]
    )
  end
end
