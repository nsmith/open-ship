require 'spec_helper'

describe OpenShip::Label::CartonLabel do

  it "should generate a valid pdf" do
    cl = OpenShip::Label::BigCartonLabel.new
    cl.from1 = "Some Company"
    cl.from2 = "234 Warehouse St"
    cl.from3 = "Somewhere, NY 11201"
    cl.to1 = "Big Retailer #11243"
    cl.to2 = "123 Retail Road"
    cl.to3 = "New York, NY 10012"
    cl.tracking = "TBD"
    cl.scac = "FDE"
    cl.zip = "956502222"
    cl.upc = "814434010944"
    cl.product = "cordlets"
    cl.style = "charcoal"
    cl.sku = "CDL-1-4CH"
    cl.quantity = 6
    doc = OpenShip::Label::BigCartonLabel.to_pdf(cl, "tmp/test_big_carton_label.pdf")
    doc.class.should == File
  end

end
