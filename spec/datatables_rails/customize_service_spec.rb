require 'spec_helper'

describe DatatablesRails::CustomizeService do
  let(:service) { DatatablesRails::CustomizeService }

  before(:each) do
    service.register(:symbol) do |field|
      "(#{field.name})"
    end
  end

  it "should call registerd block" do
    field = double(name: "test_name")
    expect(service.try_call(:symbol, field)).to eq "(test_name)"
  end

  it "should return nil if not registerd" do
    expect(service.try_call(:not_exist, Object.new)).to be_nil
  end
end