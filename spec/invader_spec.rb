# frozen_string_literal: true

RSpec.describe SpaceInvaders::Invader do
  let(:source) do
    <<~INVADER.strip
      ~~~~
      o--o
      -oo-
      ~~~~
    INVADER
  end

  it 'builds invader from the source' do
    invader = described_class.new(name: 'test', source:)

    expect(invader.to_s).to eq("o--o\n-oo-")
    expect(invader.dimensions).to eq({ rows: 2, columns: 4 })
  end
end
