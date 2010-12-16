module OAWidget
  module StatefulActions
    module ClassMethods
      
      def stateful_attr(attribute_symbol, default_value=nil)  
        @stateful_attrs ||= []
        first_run = @stateful_attrs.blank?
        @stateful_attrs << [attribute_symbol, default_value]
        self.after_add :make_stateful if first_run
      end
      
      attr_accessor :stateful_attrs

    end
    
    module InstanceMethods
      
      def make_stateful(*)
        ::Rails.logger.debug("[#{self.name}] propagating stateful params...");
        
        # propagate stateful_attrs
        self.each do |child|
          ::Rails.logger.debug("[#{self.name}] propagating to widget: #{child.name}");
          child.set_stateful_attr(@params, self.class.stateful_attrs)
        end
        OAWidget::Heartbeat.sharedHeartbeat(self)
      end
      
      def stateful?
        !self.class.stateful_attrs.blank?
      end
      
      def stateful_params
        hash = {}
        self.class.stateful_attrs.each do |attribute, default|
          hash[attribute.to_sym] = self.instance_variable_get("@#{attribute.to_s}")
        end
        hash
      end
      
      def set_stateful_attr(from_params, interests=self.class.stateful_attrs)
        return if interests.blank?
        interests.each do |param, value|
          if from_params.has_key?(param.to_sym)
            ::Rails.logger.debug("[#{self.name}] params[#{param}] is provided")
            stored_value = from_params[param]
          else
            ::Rails.logger.debug("[#{self.name}] params[#{param}] is assumed default")
            stored_value = value;
          end
          ::Rails.logger.debug("[#{self.name}] setting @#{param} = #{stored_value}")
          self.instance_variable_set("@#{param.to_s}", stored_value)
        end
      end
      
    end
    
    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end
end