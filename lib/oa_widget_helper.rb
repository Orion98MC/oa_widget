module OAWidgetHelper
  def oa_widget_stylesheets
    ['oa_widget'].collect{|style| 'oa_widget/' + style}
  end
  
  def oa_widget_javascripts
    ['oa_ajax', 'oa_heartbeat', 'oa_height-selector', 'oa_widget-tools'].collect{|js| 'oa_widget/' + js}
  end
  
  def render_heartbeat
    if controller.respond_to?(:apotomo_root) && controller.apotomo_root.find_widget(OAWidget::Heartbeat.name)
      RAILS_DEFAULT_LOGGER.debug("Rendering heartbeat: #{OAWidget::Heartbeat.name}")
      render_widget(OAWidget::Heartbeat.name)
    else
      ::Rails.logger.debug("Skipping heartbeat")
      ""
    end
  end
    
  def each_widget(&block)
    controller.apotomo_root.each do |widget|
      next if widget.root? || (widget.name == OAWidget::Heartbeat.name)
      yield widget
    end
  end
  
  def render_widgets
    contents = []
    each_widget do |widget|
      contents << render_widget(widget)
    end
    contents << render_heartbeat
    contents.join.html_safe
  end
  
end