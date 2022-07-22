# frozen_string_literal: true

class MerchantNameCountSerializer
  include JSONAPI::Serializer
  attributes :name

  attributes :count, &:item_count
end
