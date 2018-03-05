require 'byebug'



class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |attr|
      send(:define_method, "#{attr}=".to_sym) do |value|
        instance_variable_set("@" + attr.to_s, value)
      end

      send(:define_method, attr.to_sym) do
        instance_variable_get("@" + attr.to_s)
      end
    end
  end
end
