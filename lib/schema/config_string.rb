module StrongYAML
  class ConfigString
    attr_reader :name, :default

    def initialize(name, default: nil)
      @name = name
      @default = default
    end
  end
end
