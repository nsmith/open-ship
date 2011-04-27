require 'spec_helper'

describe OpenShip::Sscc do 

  it "Should persist a company prefix on the model" do
    OpenShip::Sscc.company_prefix = "801234"
    OpenShip::Sscc.company_prefix.should == "801234"
  end

  it "should generate a valid check digit for a given sscc id" do
    # See http://www.gs1us.org/solutions_services/tools/check_digit_calculator
    # for the example from which this is derived.
    sscc = "10614141192837465"
    expected_digit = "7"
    OpenShip::Sscc.generate_check_digit(sscc).should == expected_digit
  end

  it "Should return a valid sscc for a sequence number"
    
end
