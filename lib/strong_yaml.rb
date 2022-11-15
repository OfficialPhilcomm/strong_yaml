require "yaml"
require "json"
require "ostruct"
require "fileutils"
require_relative "schema/schema"

module StrongYAML
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def file(config_location)
      @config_location = config_location
    end

    def schema(&block)
      @schema = StrongYAML::ConfigSchema.new
      @schema.instance_eval(&block)
    end

    def load
      @config = YAML.load_file(@config_location)

      if @schema
        @schema.elements.each do |schema_entry|
          obj = build_schema_entry schema_entry, @config, []

          define_singleton_method(schema_entry.name) do
            obj
          end
        end
      else
        @config.each do |key, value|
          define_singleton_method(key) do
            if value.is_a? Hash
              JSON.parse value.to_json, object_class: OpenStruct
            else
              value
            end
          end
        end
      end
    end

    def create_or_load
      if File.exist? @config_location
        load
      elsif @schema
        File.write(@config_location, hash_from_schema.to_yaml)

        load
      else
        FileUtils.touch(@config_location)
      end
    end

    private

    def build_schema_entry(schema_entry, config, path)
      if schema_entry.is_a? StrongYAML::ConfigGroup
        obj = OpenStruct.new
        schema_entry.elements.each do |se|
          obj[se.name] = build_schema_entry(se, config, path + [schema_entry.name])
        end
        obj
      else
        path << schema_entry.name
        value = config.dig(*path.map(&:to_s))

        case schema_entry
        when StrongYAML::ConfigString
          if value.nil? || value.is_a?(String)
            value
          else
            raise StrongYAML::ConfigSchema::SchemaError, "#{path.map(&:to_s).join(".")} is of type #{value.class}, but should be String"
          end
        when StrongYAML::ConfigInteger
          if value.nil? || value.is_a?(Integer)
            value
          else
            raise StrongYAML::ConfigSchema::SchemaError, "#{path.map(&:to_s).join(".")} is of type #{value.class}, but should be Integer"
          end
        when StrongYAML::ConfigList
          if value.nil? || value.is_a?(Array)
            value
          else
            raise StrongYAML::ConfigSchema::SchemaError, "#{path.map(&:to_s).join(".")} is of type #{value.class}, but should be Array"
          end
        end
      end
    end

    def hash_from_schema
      hash = {}

      @schema.elements.each do |schema_entry|
        hash[schema_entry.name.to_s] = value_from_schema_entry(schema_entry)
      end

      hash
    end

    def value_from_schema_entry(schema_entry)
      if schema_entry.is_a? StrongYAML::ConfigGroup
        hash = {}
        schema_entry.elements.each do |se|
          hash[se.name.to_s] = value_from_schema_entry(se)
        end
        hash
      else
        schema_entry.default
      end
    end
  end
end
