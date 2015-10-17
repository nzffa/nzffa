class ReaderValidator
  def initialize(reader)
    @reader = reader
  end

  def valid?
    valid = true
    [:forename, :surname, :email].each do |attr|
      if @reader.send(attr).blank?
        valid = false
        @reader.errors.add(attr, 'must not be blank')
      end
    end
    valid
  end
end
