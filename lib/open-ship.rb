$LOAD_PATH << File.dirname(__FILE__) unless $LOAD_PATH.include?(File.dirname(__FILE__))

module OpenShip
  
end

require 'open-ship/sscc'
require 'open-ship/sortr'
require 'open-ship/label'
require 'open-ship/label/carton_label'
require 'open-ship/label/text_label'
require 'open-ship/label/big_carton_label'
require 'open-ship/label/cinmar_label'
require 'open-ship/label/bn_product_label'
require 'open-ship/gga4r'

