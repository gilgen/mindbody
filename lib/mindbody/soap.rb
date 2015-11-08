module MindBody::Soap

  def self.to_array_of_strings(list)
    Array(list).map {|item| {'string' => item}}
  end

  def self.to_array_of_ints(list)
    Array(list).map {|item| {'int' => item}}
  end

end
