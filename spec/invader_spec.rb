# frozen_string_literal: true

RSpec.describe SpaceInvaders::Invader do
  it 'builds invader from the source' do
    source = <<~INVADER.strip
      ~~~~
      o--o
      -oo-
      ~~~~
    INVADER

    invader = described_class.new(name: 'test', source:)

    expect(invader.name).to eq('test')
    expect(invader.to_s).to eq("o--o\n-oo-")
    expect(invader.dimensions).to eq({ rows: 2, columns: 4 })
  end

  describe '#variants' do
    it 'builds invader variants for `rat` pattern' do
      source = <<~INVADER.strip
        ~~~~
        o--o
        -oo-
        ~~~~
      INVADER

      invader = described_class.new(name: 'test', source:)
      expect(invader.variants.size).to eq(4)
      expect(invader.variants.map(&:to_s)).to eq(['-oo-', 'o--o', "-o\no-", "o-\n-o"])
    end

    it 'builds invader variants for `face` pattern' do
      source = <<~SEGMENT.strip
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

      invader = described_class.new(name: 'test', source:)
      expect(invader.variants.size).to eq(4)
      expect(invader.variants.map(&:to_s)).to eq(
        [
          "ooooooooooo\no-ooooooo-o\no-o-----o-o\n---oo-oo---",
          "--o-----o--\n---o---o---\n--ooooooo--\n-oo-ooo-oo-",
          "--o--\n-o---\nooo--\no-oo-\nooooo\nooo-o\n--o-o\noo---",
          "--o--\n---o-\n--ooo\n-oo-o\nooooo\no-ooo\no-o--\n---oo"
        ]
      )
    end
  end
end
