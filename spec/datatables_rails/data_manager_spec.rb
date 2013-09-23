require 'spec_helper'

describe DatatablesRails::DataManager do
  before(:each) do
    DatatablesRails::Settings.load!("#{File.dirname(__FILE__)}/fixtures/example.yml")
  end

  let(:manager) do 
    manager = DatatablesRails::DataManager.new({ sEcho: 1 })
    def manager.detect_class_name
      @source_class_name = "model_name"
    end
    manager
  end

  let(:source) { [double(name: "Test1", number: "1"), double(name: "Test2", number: "2")] }

  it "should return empty answer if empty source" do 
    expect(manager.generate_json([])).to eq({
      sEcho: 1,
      aaData: [],
      iTotalRecords: 0,
      iTotalDisplayRecords: 0
    })
  end

  it "should return json data with all elements" do
    expect_json_source eq [["Test1", "1"], ["Test2", "2"]]
  end

  it "should use options from parameters if passed" do
    @options = { columns: ["name"], filter_module: "ArraySource" }
    expect_json_source eq [["Test1"], ["Test2"]]
  end

  def expect_json_source(matcher)
    expect(manager.generate_json(source, options: @options)[:aaData]).to matcher
  end

end