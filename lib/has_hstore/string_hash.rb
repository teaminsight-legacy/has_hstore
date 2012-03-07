module HasHstore

  class StringHash < Hash

    def initialize(constructor = {})
      if constructor.kind_of?(Hash)
        super()
        update(constructor)
      else
        super(constructor)
      end
    end
    
    def [](key)
      super(key.to_s)
    end
    
    def []=(key, value)
      super(key.to_s, value)
    end

  end

end