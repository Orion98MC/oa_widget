# Orion's Apotomo Widget
module OAWidget
  
  class Base < Apotomo::Widget 

    include OAWidget::Preserver

    def invoke(state=nil, &block)
      preserved_attrs
      super(state, &block)
    end

  end # class OAWidget::Base
  
end

module Apotomo
  module Rails
    module ViewHelper
      
      def params_for_event(event)
        {
          :action => 'render_event_response', 
          :source => @cell.name, 
          :type => event.to_s
        }.merge! @cell.preserved_params
      end
      
      def preserved_params(options={})
        preserved = @cell.preserved_params
        if options[:except]
          except = [options[:except]].flatten
          except.each {|e| preserved.delete(e)}
          options.delete(:except)
        end
        preserved.merge(options)
      end
            
    end
  end
end