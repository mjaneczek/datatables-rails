require 'spec_helper'

describe DatatablesRails::JsonGenerator do
  let(:generator) { DatatablesRails::JsonGenerator }

  it "should return empty answer if data is nil" do
    expect(generator.generate(1)).to eq({
      sEcho: 1,
      aaData: [],
      iTotalRecords: 0,
      iTotalDisplayRecords: 0
    })
  end

  it "should put all parameters into json" do
    expect(generator.generate(1, [1, 2, 3], 10, 20)).to eq({
      sEcho: 1,
      aaData: [1, 2, 3],
      iTotalRecords: 10,
      iTotalDisplayRecords: 20
    })
  end
end