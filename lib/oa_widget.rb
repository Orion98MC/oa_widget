require 'apotomo'

module OAWidget
end

require 'oa_widget/stateful_actions'
require 'oa_widget/base'
require 'oa_widget/heartbeat'

require 'oa_widget_helper'
ActionView::Base.send :include, OAWidgetHelper

