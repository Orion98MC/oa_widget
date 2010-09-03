module OAWidget

  class Anchors < OAWidget::Base
    responds_to_event :save, :with => :save
    responds_to_event :anchors, :with => :update_anchors
  
    def initialize(widget_id, options={})
      preserves_attrs(options.delete(:preserve))
      super(widget_id, :anchors, options)
    end
  
    def anchors
      setup_anchors
      render
    end
  
    def update_anchors
      setup_anchors
      replace :view => 'anchors'
    end
  
    def save
      parent.save
      replace :view => 'saved'
    end
  
    private
    def setup_anchors
      @anchors = []
      @anchors << :save if parent.saveable?      
    end
  
  end

end