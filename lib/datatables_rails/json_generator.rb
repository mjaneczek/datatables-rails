module DatatablesRails
  class JsonGenerator
    class << self
      def generate(echo_number, data = [], total_records = 0, total_display_records = 0)
        {
          sEcho: echo_number,
          aaData: data,
          iTotalRecords: total_records,
          iTotalDisplayRecords: total_display_records
        }
      end
    end
  end
end