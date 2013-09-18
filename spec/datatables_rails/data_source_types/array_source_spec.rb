require "spec_helper"

describe DatatablesRails::ActiveRecordSource do
  let(:source_helper) { DatatablesRails::ArraySource }
  let(:source) do
    [double(name: "A"), double(name: "AB"), double(name: "C")]
  end

  it "should order data" do
    {"asc" => "A", "desc" => "C"}.each do |key, value|
      data = source_helper.sort_data(source, "name", key)
      expect(data.first.name).to eq value
    end
  end

  it "should page data" do
    source = (0..100).to_a
    data = source_helper.page_data(source, 3, 10)

    expect(data).to eq (20..29).to_a
  end

  it "should search data" do
    {"B" => "AB", "C" => "C"}.each do |key, value|
      data = source_helper.search_data(source, ["name"], key)
      expect(data.first.name).to eq value
    end
  end
end