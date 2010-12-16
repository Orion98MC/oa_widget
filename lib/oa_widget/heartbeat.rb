module OAWidget
  
  HEARTBEAT_NAME = 'Heartbeat'
  
  class Heartbeat < OAWidget::Base
    
    attr_accessor :namespaces
    
    def self.name
      HEARTBEAT_NAME
    end
    
    def heartbeat?
      true
    end
    
    def self.sharedHeartbeat(for_widget)
      heartbeat = for_widget.root.find_widget(HEARTBEAT_NAME)
      if heartbeat.blank?
        root = for_widget.root
        RAILS_DEFAULT_LOGGER.debug("Creating a shared heartbeat")
        heartbeat = Heartbeat.new(for_widget.parent_controller, HEARTBEAT_NAME, :heartbeat)
        heartbeat.namespaces = []
        root << heartbeat
      else
        RAILS_DEFAULT_LOGGER.debug("Using shared heartbeat")
      end
      heartbeat
    end
                
    responds_to_event :refresh, :with => :refresh

    def refresh_namespace(a_namespace)
      RAILS_DEFAULT_LOGGER.debug("Heartbeat should refresh namespace: '#{a_namespace}'")
      self.namespaces << a_namespace unless self.namespaces.include?(a_namespace)
      fire(:refresh)
    end
    
    def refresh
      return render :nothing => true if self.namespaces.blank?

      RAILS_DEFAULT_LOGGER.debug("refreshing heartbeat namespaces: [#{self.namespaces.join(', ')}]")
      heartbeat_js = []
      self.namespaces.each do |namespace|
        heartbeat_js << "#{HEARTBEAT_NAME.downcase}['#{namespace}'] = #{heartbeat_params[namespace].to_json};"
      end
      self.namespaces = []
      render :text => heartbeat_js.join("\n")
    end

    def heartbeat
      self.namespaces = []
      RAILS_DEFAULT_LOGGER.debug("var #{HEARTBEAT_NAME.downcase} = #{heartbeat_params.to_json};")
      render :text => "
<script type='text/javascript'>
  //<![CDATA[
  var #{HEARTBEAT_NAME.downcase} = #{heartbeat_params.to_json};
  //]]>
</script>"
    end
      
    def heartbeat_params
      heartbeat_hash = {}
      self.root.each do |child|
        if child.respond_to?(:stateful?) && child.stateful?
          heartbeat_hash[child.name] = child.stateful_params
        end
      end
      heartbeat_hash
    end
    
  end
end