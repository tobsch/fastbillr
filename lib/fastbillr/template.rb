module Fastbillr
  class Template < Fastbillr::Model
    property :id, from: :TEMPLATE_ID
    fastbill_properties :template_name
  end
end
