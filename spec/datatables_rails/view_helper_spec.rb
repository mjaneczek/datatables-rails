require "spec_helper"

include DatatablesRails
include ViewHelper

describe ViewHelper, type: :helper do
  before(:all) do
    Settings.load!("#{File.dirname(__FILE__)}/fixtures/example.yml")
  end

  before(:each) do
    Object.any_instance.stub(products_path: "some_fake_path")
  end

  let(:model) do
    model = double(name: "Product")
    allow(model).to receive(:human_attribute_name).with("name").and_return("Product name")
    model
  end

  let(:subject) { datatable_tag(model) }

  it "should render table head" do
    should have_tag("th", text: "first column name")
    should have_tag("th", text: "Product name")
  end

  it "should render table with data attributes" do 
    should have_tag("table", with: { 
      id: "datatables_rails",
      "data-source" => "some_fake_path",
      "data-sorting_column" => "0",
      "data-sorting_type" => "asc",
      "data-columns_without_sorting" => "[0]"
      })
  end
end