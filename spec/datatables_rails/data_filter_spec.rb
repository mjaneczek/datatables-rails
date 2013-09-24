require 'spec_helper'

describe DatatablesRails::DataFilter do
  let(:filter) do
    filter = DatatablesRails::DataFilter.new(
      "model_name", request_params, options,
       empty_customize_service, 
       empty_customize_service)
  end

  let(:request_params) do
    double(
      page: example.metadata[:page] || 1,
      per_page: example.metadata[:per_page] || 5,
      sort_column_index: 0,
      sort_direction: example.metadata[:sort_direction] || "asc", 
      search_text: example.metadata[:search_text])
  end

  let(:options) do
    double(columns: ["name"], filter_column: ["name"], filter_module: DatatablesRails::ArraySource)
  end

  let(:empty_customize_service) do
    customize_service = double()
    allow(customize_service).to receive(:try_call).with(any_args()).and_return(nil)
    allow(customize_service).to receive(:items).with(any_args()).and_return({})
    customize_service
  end

  it "shoud reutrn first 5 records" do
    compare_by_name(filter.get_filtered_data(source), source[0..4])
  end

  it "shoud sort data", sort_direction: "desc" do
    compare_by_name(filter.get_filtered_data(source), source.reverse![0..4])
  end

  it "shoud filter by search text", search_text: "name2" do
    compare_by_name(filter.get_filtered_data(source), source[2..2])
    expect(filter.get_source_count_after_filter).to eq 1
  end

  it "shoud filter by page / per page", page: 2, per_page: 3 do
    compare_by_name(filter.get_filtered_data(source), source[3..5])
  end

  it "shoud filter by custom filter" do 
    additional_filters = double()
    allow(additional_filters).to receive(:try_call).with("model_name", anything(), anything()).and_return(source[0..1])

    filter = DatatablesRails::DataFilter.new("model_name", request_params, options,
      additional_filters, empty_customize_service)

    compare_by_name(filter.get_filtered_data(source), source[0..1])
  end


  def compare_by_name(first_source, second_source)
    first_source_names = first_source.map {|s| s.name }
    second_source_names = second_source.map {|s| s.name }

    expect(first_source_names).to eq second_source_names
  end

  def source
    10.times.map {|i| double(name: "name#{i}")}
  end
end