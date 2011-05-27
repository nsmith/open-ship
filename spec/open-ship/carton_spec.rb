require 'spec_helper'

  describe OpenShip::Carton do


    describe "When packing a carton" do

      before(:each) do
        @cart = OpenShip::Carton.new
        @cart.width = 80
        @cart.length = 100
        @cart.height = 30
        @box = OpenShip::Box.new
        @box.width = 12
        @box.length = 14
        @box.height = 10
        @bp = OpenShip::BoxPosition.new
        @pos = OpenShip::Position.new

        @pos.x = 0
        @pos.y = 0
        @pos.z = 0
        @bp.box = @box
        @bp.position = @pos

        @box2 = OpenShip::Box.new
        @box2.width = 8
        @box2.length = 7
        @box2.height = 5

        @bp2 = OpenShip::BoxPosition.new
        @pos2 = OpenShip::Position.new

        @pos2.x = 12
        @pos2.y = 0
        @pos2.z = 0
        @bp2.box = @box2
        @bp2.position = @pos2


        @wide_box = OpenShip::Box.new
        @wide_box.width = 80
        @wide_box.length = 7
        @wide_box.height = 5

        @wide_flat_box = OpenShip::Box.new
        @wide_flat_box.width = 80
        @wide_flat_box.length = 100
        @wide_flat_box.height = 5


        @big_box = OpenShip::Box.new
        @big_box.width = 80
        @big_box.length = 100
        @big_box.height = 30

        @lamp = OpenShip::Box.new
        @lamp.width = 10
        @lamp.length = 8
        @lamp.height = 6

      end

      it "should be able to return its space in square units" do
        space = @cart.get_space
        space.length.should == @cart.volume
      end

       it "should be able to return its free space in square units if a box is packed in it" do
        @cart.box_positions = []
        @cart.box_positions << @bp
        @cart.box_positions << @bp2
        space = @cart.get_space
        space.length.should == (@cart.volume - @box.volume - @box2.volume)
        
      end

      it "should be able to add boxes" do
        @cart.box_positions = []
        @cart.add_box(@box)
        @cart.add_box(@box2)
        space = @cart.get_space
        space.length.should == (@cart.volume - @box.volume - @box2.volume)
        
      end


      it "should be able to return a valid position for a box that can fit in it." do
        @cart.box_positions = []
        @cart.box_positions << @bp
        new_position = @cart.position_for_box(@box2)
        new_position.class.should == OpenShip::Position
        # Check that a really long box is moved down the length of the container."
        new_position = @cart.position_for_box(@wide_box)
        new_position.y.should be > 0
        # Check that a really wide, flat box will be loaded on top of existing boxes."
        new_position = @cart.position_for_box(@wide_flat_box)
        new_position.z.should be > 0
      end

      it "should return a nil position for a box that cannot fit." do
        @cart.box_positions = []
        @cart.box_positions << @bp
        new_position = @cart.position_for_box(@big_box)
        new_position.should == nil
      end

      it "should be able to calculate a shipment" do
        log = Logger.new(STDOUT)
        log.level = Logger::DEBUG
        
        population = []
        boxes_to_stores = {}
        i = 0
        2.times {
          boxes_to_stores[i.to_s] = []
          10.times {
            box = OpenShip::Box.new
            box.length = ((rand * 9) + 1).to_i
            box.width = ((rand * 19) + 1).to_i
            box.height = ((rand * 19) + 1).to_i
            boxes_to_stores[i.to_s] << box
          }
          i += 1
        }
        ship = OpenShip::Shipment.new(:logger => log)
        ship.boxes_to_stores = boxes_to_stores
        best_fit = ship.run_ga(3, 3)

        best_fit.cartons_to_stores.each { |k, v|
          puts "Test"
          v.each { |carton|
            carton.volume.should be > carton.box_positions.sum { |bp| bp.box.volume }
            carton.get_space.length.should == carton.free_space
          }
        }
      end


    end

  end
