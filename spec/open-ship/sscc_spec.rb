require 'spec_helper'

describe OpenShip::Sscc do 

  it "Should persist a company prefix on the model" do
    OpenShip::Sscc.company_prefix = "8012345"
    OpenShip::Sscc.company_prefix.should == "8012345"
  end

  it "should generate a valid check digit for a given sscc id" do
    # See http://www.gs1us.org/solutions_services/tools/check_digit_calculator
    # for the example from which this is derived.
    sscc = "10614141192837465"
    sscc2 = "10614141192837700"
    expected_digit = "7"
    expected_digit2 = "9"
    OpenShip::Sscc.generate_check_digit(sscc).should == expected_digit
    OpenShip::Sscc.generate_check_digit(sscc2).should == expected_digit2
  end

  it "should return a valid sscc for a sequence number" do
    company_prefix = "0614141"
    serial_reference = "192837465"
    OpenShip::Sscc.company_prefix = company_prefix
    sscc = OpenShip::Sscc.generate_sscc_id(serial_reference)
    sscc.should == "006141411928374650"
  end

  it "should fill in leading zeros in serial_reference if serial_reference + company_prefix + extension_digit adds up to less than 17" do
    company_prefix = "0614141"
    serial_reference = "1"
    OpenShip::Sscc.company_prefix = company_prefix
    sscc = OpenShip::Sscc.generate_sscc_id(serial_reference)
    sscc.length.should == 18
    sscc.should match /0{8}/
  end

end
