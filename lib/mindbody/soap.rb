module MindBody::Soap

  def self.to_array_of_strings(list)
    to_array_of('string', list)
  end

  def self.to_array_of_ints(list)
    to_array_of('int', list)
  end

  def self.to_array_of(type, list)
    Array.wrap(list).map {|item| {type => item}}
  end

end
