require 'spec_helper'

  describe OpenShip::Carton do

    it "should be able to return its space in square units" do
      cart = OpenShip::Carton.new
      cart.width = 80
      cart.length = 100
      cart.height = 30
      space = cart.get_space
      space.length.should == (cart.width * cart.height * cart.length)
    end

     it "should be able to return its free space in square units if a box is packed in it" do
      cart = OpenShip::Carton.new
      cart.width = 80
      cart.length = 100
      cart.height = 30
      box = OpenShip::Box.new
      box.width = 12
      box.length = 14
      box.height = 10
      bp = OpenShip::BoxPosition.new
      pos = OpenShip::Position.new

      pos.x = 0
      pos.y = 0
      pos.z = 0
      bp.box = box
      bp.position = pos
      cart.box_positions = []
      cart.box_positions << bp
      space = cart.get_space
      space.length.should == (cart.volume - box.volume)
    end

  end
