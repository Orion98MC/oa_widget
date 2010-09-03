module OAWidget

  module Preserver
    
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods

      # Preserve ivars between widgets, rendering and ajax calls
      # example: 
      #  class MyWidget < OAWidget
      #    preserves_attr :page, :from => '../content'
      #    preserves_attr :display
      #    ...
      #  end
      #
      # Usage:
      #  preserves_attr :attribute_name [, OPTIONS]
      #
      #  By default it will preserve the attribute_name from the parent. 
      #  That is, the parent is responsible for having the right getter/setter for the attribute
      #
      #  OPTIONS:
      #  :from => String, a relative path to the widget from which we must sync the param
      #    example: preserves_attr :page, :from => '../pager'
      #
  
      def preserves_attr(*attrs)
        @preserved_vars ||= []
        @preserved_vars << attrs
      end

      def preserved_vars
        @preserved_vars
      end
      
    end # ClassMethods
  
    def preserves_attrs(attrs=nil)
      return if attrs.blank?
      attrs.each do |attribute|
        self.class.preserves_attr attribute
      end
    end
  
    def preserved_params(*except)
      return {} if self.class.preserved_vars.nil?
      params_hash = {}
      self.class.preserved_vars.each do |ivar, options|
        value = self.instance_variable_get("@#{ivar}")
        # RAILS_DEFAULT_LOGGER.debug("(#{self.name}) export to params: #{ivar} = #{value}")
        params_hash.merge!(ivar => self.instance_variable_get("@#{ivar}"))
      end
      except.each {|e| params_hash.delete(e)}
      params_hash
    end
  
    def preserved_attrs
      return if self.class.preserved_vars.nil?
      self.class.preserved_vars.each do |ivar, options|
        options ||= {}
      
        managing_widget = options.include?(:from) ? self.widget_from_path(options[:from]) : self.parent
        next if managing_widget.nil?
      
        if param(ivar)
          # RAILS_DEFAULT_LOGGER.debug("(#{self.name}) [PARAMS]:   setting #{ivar} = #{param(ivar)} on widget: #{managing_widget.name}")
          # push the value to the widget managing it  
          managing_widget.instance_variable_set("@#{ivar}", param(ivar))
        end
      
        # get the value of a preserved attr from the widget managing it  
        value = managing_widget.instance_variable_get("@#{ivar}")
      
        if value.blank?
          if (options[:default])
            value = options[:default]  
            managing_widget.instance_variable_set("@#{ivar}", value)
          end
        end
      
        # RAILS_DEFAULT_LOGGER.debug("(#{self.name}) [NOPARAMS]: setting #{ivar} = #{value} on widget: #{self.name}") unless (param(ivar))
        self.instance_variable_set("@#{ivar}", value)

      end
    end
  
    # Search for the widget identified by its id in the specified relative path
    # example:
    #   self.widget_from_path('../content') will look for the child widget named 'content' of the parent widget of self
    def widget_from_path(relative_path)
      raise 'relative_path must be a string' unless relative_path.class == String
      raise 'relative_path should not start with / (hence "relative")' if relative_path =~ /^\//
    
      path_components = relative_path.split(/\//)
      path_components.shift if path_components[0] == '.'
      # RAILS_DEFAULT_LOGGER.debug("starting search at self: #{self.name}, self.parent: #{self.parent.name}, self.root: #{self.root.name}")
    
      start = self
      while path_components[0] == '..'
        # RAILS_DEFAULT_LOGGER.debug("path components: #{path_components.to_json}")
        start = self.parent
        path_components.shift
      end
    
      path_components.each do |w|
        # RAILS_DEFAULT_LOGGER.debug("start: #{start.name}")
        break if start.nil?
        start = start.find_widget(w)
      end
      start
    end
  
  end # module OAPreserver

end