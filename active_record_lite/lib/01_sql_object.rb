require_relative 'db_connection'
require 'byebug'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
# include ActiveSupport::Inflector

  def self.columns
    return @cols if @recieved_cols
    @recieved_cols = true
    @cols = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        cats
    SQL

    @cols.first.map { |col| col.to_sym }
    @cols = @cols.first

  end

  def attributes
    @attributes ||= {}
  end

  def self.finalize!
    # columns.each do |col|
    #   attr_accessor "#{col}".to_sym
    # end
    #
    # columns.each do |col, value|
    #   self.attributes["#{col}".to_sym] = value
    # end
    columns.each do |col|
      define_method("#{col}=".to_sym) do |value|
        self.attributes["#{col}".to_sym] = value
      end

      send(:define_method, "#{col}".to_sym) do
        instance_variable_get(@attributes["#{col}"])
      end
    end
  end

  def self.table_name=(name)
    # debugger
    @table_name = name
  end

  def self.table_name
    if self.to_s == "Human"
      return 'humans'
    else
      self.to_s.tableize
    end
    # ...
  end

  def self.all
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    # debugger
    self.class.finalize!
    params.each do |key, value|

      if self.class.columns.include?(key.to_s)
        self.send("#{key}=", value)
      else
        raise "unknown attribute '#{key}'"
      end
    end
    # ...
  end


  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
