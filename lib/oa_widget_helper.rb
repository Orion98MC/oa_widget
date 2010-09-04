module OAWidgetHelper
  def oa_widget_stylesheets
    ['oa_widget'].collect{|style| 'oa_widget/' + style}
  end
  
  def oa_widget_javascripts
    ['oa_ajax_pagination', 'oa_heartbeat', 'oa_height-selector', 'oa_widget-tools'].collect{|js| 'oa_widget/' + js}
  end
end