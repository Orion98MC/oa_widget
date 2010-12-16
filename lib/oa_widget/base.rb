# Orion's Apotomo Widget
# An Aptomo stateless widget with params persitency care taking
#
# Example:
# class MyWidget < OAWidget::Base
#   stateful_attr :sort, "asc" # Please store the :sort params value or default to "asc" in a @sort ivar
#   ...
# end
#
module OAWidget
  
  class Base < Apotomo::Widget 
    include OAWidget::StatefulActions

    def invoke(state=nil, &block)
      rendered = super(state, &block)
      self.invoke_heartbeat(state)
      rendered
    end
    
    def invoke_heartbeat(state)
      return if self.heartbeat? || !self.stateful?
      return if state.nil?
      ::Rails.logger.debug("#{self.name} invoked '#{state}'")
      OAWidget::Heartbeat.sharedHeartbeat(self).refresh_namespace(self.name)
    end
    
    def heartbeat?
      false
    end
    
  end  
end
