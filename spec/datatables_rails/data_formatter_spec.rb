require 'spec_helper'

describe DatatablesRails::DataFormatter do
  let(:options) do
    double(columns: [:name, :count, :size])
  end

  let(:formatter) do
    templates = double()
    expect(templates).to receive(:try_call).with(:size, anything()).and_return("custom_tempalte").twice
    expect(templates).to receive(:try_call).with(any_args()).and_return(nil).exactly(4).times

    additional_columns = double()
    expect(additional_columns).to receive(:try_call).with(:first, anything()).and_return("additional").twice
    expect(additional_columns).to receive(:try_call).with(:last, anything()).and_return(nil).twice

    DatatablesRails::DataFormatter.new(options, templates, additional_columns)
  end

  it "shoud format source with additional columns and templates" do
    expect(formatter.format_data(source)).to eq [
      ["additional", "name1", "1", "custom_tempalte"],
      ["additional", "name2", "2", "custom_tempalte"]
    ]
  end

  def source
    (1..2).map {|n| double(name: "name#{n}", count: n, size: "#{n}cm")}
  end
end
