if defined?(ActiveRecord) && defined?(ActiveRecord::VERSION)
  if ActiveRecord::VERSION::MAJOR <= 3
    require 'has_hstore/activerecord/compatibility'
  end
end

require 'has_hstore/hstore'

module HasHstore
  autoload :VERSION, 'has_hstore/version'

  class << self

    # build a custom module where has_hstore getter/writer/callback methods are defined
    # then include that on the model
    def build(model, &block)
      self.setup(model)
      self.instance_eval(&block)
      self.teardown
    end

    def hstore(attribute, options = {})
      attribute = attribute.to_s.to_sym
      # define getter
      @module.send(:define_method, attribute) do
        self.instance_variable_get("@#{attribute}") || begin
          hstore = HasHstore::Hstore.new(self[attribute] || options[:default])
          self.instance_variable_set("@#{attribute}", hstore)
        end
      end
      # define writer
      @module.send(:define_method, "#{attribute}=") do |value|
        hstore = HasHstore::Hstore.new(self[attribute] || options[:default])
        self.instance_variable_set("@#{attribute}", hstore)
        self[attribute] = hstore.to_s
        hstore
      end
      # before_validation for ensuring hstore is persisted
      callback_name = "ensure_hstore_#{attribute}_is_persisted"
      @module.send(:define_method, callback_name) do
        self[attribute] = self.send(attribute).to_s
      end
      @model.send(:before_validation, callback_name)
    end

    protected

    def setup(model)
      @model = model
      @module = Module.new
    end

    def teardown
      @model.send(:include, @module)
      @model = nil
      @module = nil
    end

  end
end
