class DeliveryDateValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      if value.present? && value > Time.zone.now
        record.errors.add(attribute, :date, message: "deve ser uma data no passado ou igual à data atual")
      end
    end
  end