class LocationValidator 
  def self.accepts?(location_value)
    location_value =~ /^(\d{5}|[A-z]\d[A-z]\s\d[A-z]\d)$/
  end
end
