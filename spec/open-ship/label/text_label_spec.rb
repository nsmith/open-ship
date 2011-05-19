require 'spec_helper'

describe OpenShip::Label::TextLabel do

  it "should generate a valid pdf" do
    cl = OpenShip::Label::TextLabel.new
    cl.address1 = "Friday Afternoon (Distribution Center)"
    cl.address2 = "34234234 Whale Face Rd."
    cl.address3 = "Hamlet, Somewhere 234555"
    cl.address4 = "1-800-BLAHBLAHBLAH"
    cl.sku = "CDL-1-4CH"
    cl.line = 1
    cl.quantity = 6
    cl.total_cartons = "1 of 6"
    cl.po = "D234534"
    doc = cl.to_pdf
    doc.render_file("tmp/test_text_label.pdf")
    doc.class.should == Prawn::Document
  end

end
