require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'interactive_record.rb'

class Student < InteractiveRecord


    self.column_names.each do |attribute|
        attr_accessor  attribute.to_sym
    end

end
