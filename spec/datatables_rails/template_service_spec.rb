require 'spec_helper'

describe DatatablesRails::TemplateService do
  let(:template) { DatatablesRails::TemplateService }

  before(:each) do
    template.register(:field_name) do |field|
      "(#{field.name})"
    end
  end

  it "should get custom template of field" do
    field = double(name: "test_name")
    expect(template.try_get(:field_name, field)).to eq "(test_name)"
  end

  it "should return nil if template not exist" do
    expect(template.try_get(:not_exist, Object.new)).to be_nil
  end
end