module OAWidget

  class Heartbeat < OAWidget::Base
      
    def initialize(name, options={})
      @hb_preserved_attrs = options[:preserve]
      preserves_attrs(options.delete(:preserve))
      super(name, :heartbeat, options)
    end
  
    def heartbeat
      setup_preserved_attrs_hash
      RAILS_DEFAULT_LOGGER.debug("OAHeartBeat namespace: #{parent.name} params: #{@preserved_attrs}")
      render
    end
  
    def update_heartbeat
      setup_preserved_attrs_hash
      replace :view => 'heartbeat'
    end
  
    private
    
    def setup_preserved_attrs_hash
      return if @hb_preserved_attrs.blank?
      hash = {}
      @hb_preserved_attrs.each do |attribute|
        hash[attribute] = self.instance_variable_get("@#{attribute.to_s}")
      end
      @preserved_attrs = hash.to_json
    end
    
  end

end