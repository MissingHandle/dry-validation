RSpec.describe Dry::Validation::Schema, 'for an array' do
  context 'When a schema has a property that is an array' do
    subject(:schema) do
      sub_schema = Dry::Validation.Schema do
        required(:prefix).filled
        required(:value).filled
      end

      Dry::Validation.Schema do
        required(:some_array_prop).each(sub_schema)
      end
    end

    let(:valid_data) {
      {
        some_array_prop: [{ prefix: 1, value: 123 }, { prefix: 2, value: 456 }]
      }
    }
    let(:invalid_data) {
      {
        some_array_prop: [{ prefix: 1, value: nil }, { prefix: nil, value: 456 }]
      }
    }

    it 'valid data results in success' do
      expect(schema.(valid_data)).to be_success
    end

    it 'valid data results in no messages' do
      expect(schema.(valid_data).messages).to be_empty
    end

    it 'invalid data results in expected messages' do
      result = schema.(invalid_data)

      expect(result.messages).to eql(
        some_array_prop: {
          0 => { value: ["must be filled"] },
          1 => { prefix: ["must be filled"] }
        }
      )
    end
  end
end