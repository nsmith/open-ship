require 'spec_helper'

describe OpenShip::Label::CartonLabel do

  it "should generate a valid pdf" do
    cl = OpenShip::Label::CartonLabel.new
    cl.upc = "814434010944"
    cl.product = "cordlets"
    cl.style = "charcoal"
    cl.sku = "CDL-1-4CH"
    cl.quantity = 6
    cl.origin = "made in china"
    doc = cl.to_pdf
    doc.render_file("tmp/test_carton_label.pdf")
    doc.class.should == Prawn::Document
  end

end
