class MerchantSerializer
  include JSONAPI::Serializer
  attributes :name
  has_many :items

  def self.format_merchants(merchants)
    {
      data: merchants.map do |merchant|
        {
          id: merchant.id,
          type: 'merchant',
          attributes: {
            name: merchant.name
          }
        }
      end
    }
  end
end
