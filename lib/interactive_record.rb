require_relative "../config/environment.rb"
require 'active_support/inflector'
require 'pry'

class InteractiveRecord

  def self.table_name
      self.to_s.downcase.pluralize
  end

  def initialize(properties={})
      properties.each do |key, value|
          self.send("#{key}=", value)
      end
  end

  def self.column_names
      DB[:conn].results_as_hash = true
      sql = "pragma table_info('#{table_name}')"
      table_info = DB[:conn].execute(sql)

      attrs = []
      table_info.each do |column|
          attrs << column['name']
      end
      attrs
  end

  def table_name_for_insert
      self.class.table_name
  end

  def col_names_for_insert
     self.class.column_names.delete_if{|col| col == "id"}.join(", ")
  end

  def values_for_insert
      vals = []
      self.class.column_names.each do |value|
        vals << "'#{send(value)}'" unless send(value) == nil
      end
      vals.join(", ")
  end

 def save
    sql = <<-SQL
        INSERT INTO #{self.table_name_for_insert} (#{self.col_names_for_insert})
        VALUES (#{self.values_for_insert});
    SQL
    DB[:conn].execute(sql)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{self.table_name_for_insert}")[0][0]
  end

  def self.find_by_name(name)
        sql = <<-SQL
            SELECT * FROM #{self.table_name} WHERE name = ?;
        SQL
        DB[:conn].execute(sql, name)
  end






  def self.find_for_insert_values(property={})
      vals = []
      property.each do |key, value|
        #   binding.pry
        vals << "#{key.to_s} = ?"
      end
      vals.join(", ")
    #   binding.pry
  end








  def self.find_by(property={})

      sql = <<-SQL
          SELECT * FROM #{self.table_name};
          WHERE name = ?;
      SQL
      binding.pry
      DB[:conn].execute(sql,"Susan")
  end
end
