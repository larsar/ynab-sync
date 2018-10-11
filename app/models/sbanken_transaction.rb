class SbankenTransaction < Item
  jsonb_accessor :properties,
                 memo: :string

end