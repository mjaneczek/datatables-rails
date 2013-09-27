require "spec_helper"

describe DatatablesRails::ActiveRecordSource do
  let(:source_helper) { DatatablesRails::ActiveRecordSource }
  let(:source) do
    double("source")
  end

  it "should order data" do
    expect(source).to receive(:order).with("sort_column ASC")
    source_helper.sort_data(source , "sort_column", "ASC")
  end

  it "should page data" do
    expect(source).to receive(:page).with(3).and_return(source)
    expect(source).to receive(:per_page).with(10)

    source_helper.page_data(source, 3, 10)
  end

  it "should search data" do
    expect_sql = "CAST(col1 AS TEXT) ilike '%find_me%' OR CAST(col2 AS TEXT) ilike '%find_me%'"
    expect(source).to receive(:where).with(expect_sql)

    source_helper.search_data(source, ["col1", "col2"], "find_me")
  end

  it "should get source count" do
    expect_total_count_to_eq_3_if_count_returns(3, {1 => 1, 2 => 2, 3 => 3})
  end

  def expect_total_count_to_eq_3_if_count_returns(*return_values)
    fake_active_record_source = double()

    return_values.each do |value|
      allow(fake_active_record_source).to receive(:count).and_return(value)
      expect(source_helper.get_total_count(fake_active_record_source)).to eq 3
    end
  end

  module ActiveRecord
    class Base
      def self.sanitize_sql_array(query)
        query[0] % query[1]
      end
    end
  end
end