require_relative "config_group"
require_relative "config_string"
require_relative "config_integer"
require_relative "config_list"

module StrongYAML
  class ConfigSchema
    attr_reader :elements

    class SchemaError < StandardError
    end

    def initialize
      @elements = []
    end

    def group(name, &block)
      group = StrongYAML::ConfigGroup.new(name)
      @elements << group
      group.instance_eval(&block)
    end

    def string(name, **args)
      @elements << StrongYAML::ConfigString.new(name, **args)
    end

    def integer(name, **args)
      @elements << StrongYAML::ConfigInteger.new(name, **args)
    end

    def list(name, **args)
      @elements << StrongYAML::ConfigList.new(name, **args)
    end
  end
end
