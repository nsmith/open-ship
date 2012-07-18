require 'spec_helper'

describe OpenShip::Label::BnProductLabel do

  it "should generate a valid pdf" do
    cl = OpenShip::Label::BnProductLabel.new
    cl.vendor = "Acme Co"
    cl.origin = "China"
    cl.product = "cordlets"
    cl.upc = "614141005437"
    cl.weight = 14.0
    cl.quantity = 30
    cl.price = 15.95
    doc = OpenShip::Label::BnProductLabel.to_pdf(cl, "tmp/test_bn_product_label.pdf")
    doc.class.should == File
  end

end
