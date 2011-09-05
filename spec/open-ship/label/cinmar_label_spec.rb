require 'spec_helper'

describe OpenShip::Label::CinmarLabel do

  it "should generate a valid pdf" do
    cl = OpenShip::Label::CinmarLabel.new
    cl.from1 = "Some Company"
    cl.from2 = "234 Warehouse St"
    cl.from3 = "Somewhere, NY 11201"
    cl.to1 = "Big Retailer #11243"
    cl.to2 = "123 Retail Road"
    cl.to3 = "New York, NY 10012"
    cl.scac = "Use Routing Guide"
    cl.zip = "95650"
    cl.po_number = "GL32454"
    cl.vendor_number = "236622"
    cl.product = "cordlets"
    cl.style = "charcoal"
    cl.vendor_item_number = "CDL-1-4CH"
    cl.item_number = "47509 BLA"
    cl.quantity = 6
    cl.carton = 1
    cl.total_cartons = 56
    OpenShip::Sscc.company_prefix = "8144301"
    cl.sscc = OpenShip::Sscc.generate_sscc_id("1234", :include_prefix => false)
    doc = OpenShip::Label::CinmarLabel.to_pdf(cl, "tmp/test_cinmar_label.pdf")
    doc.class.should == File
  end

end
