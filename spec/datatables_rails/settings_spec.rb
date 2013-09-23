require "spec_helper"

describe DatatablesRails::Settings do
  let(:settings) { DatatablesRails::Settings }
  before(:each) do
    settings.load!("#{File.dirname(__FILE__)}/fixtures/example.yml")
  end

  it "should return yml structure" do
    expect(settings.model_name[:columns]).to eq ["name", "number"]
  end

  it "should raise NoMethodError if root not exist" do
    expect { settings.i_am_not_exist }.to raise_error(NoMethodError, "unknown configuration root i_am_not_exist")
  end
end