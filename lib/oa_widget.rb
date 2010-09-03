require 'apotomo'

module OAWidget
end

require 'oa_widget/preserver'
require 'oa_widget/base'

require 'oa_widget_helper'
ActionView::Base.send :include, OAWidgetHelper

