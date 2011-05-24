require "activesupport"

module OpenShip
  


  class BoxPosition
    attr_accessor :position, :box

    def get_relative_space
      self.box.get_space(:relative_position => self.position)
    end

  end

  class Position

    attr_accessor :x, :y, :z

  end

  class Box
    attr_accessor :length, :width, :height, :label, :product_quantity

    def volume
      (length * width * height)
    end



  end

  class Carton < Box
    attr_accessor :margin, :box_positions, :width_margin, :length_margin

    def initialize()
      self.box_positions = []
    end

    @last_box = nil
    
    def space_packed(pos)
      packed = false
      self.box_positions.each { |bp|
        unless packed
          if ((pos.x >= bp.position.x) && (pos.x < (bp.box.width + bp.position.x)))
            if ((pos.y >= bp.position.y) && (pos.y < (bp.box.length + bp.position.y)))
              if ((pos.z >= bp.position.z) && (pos.z < (bp.box.height + bp.position.z)))
                packed = true
              end
            end
          end
        end
      }
      packed
    end

    def get_space(opts={})
      space = []
      z_pos = 0
      while (z_pos < self.height)
        y_pos = 0
        while(y_pos < self.length)
          x_pos = 0
          while(x_pos < self.width)
            pos = Position.new
            pos.x = x_pos
            pos.y = y_pos
            pos.z = z_pos
            unless self.space_packed(pos)
              space << pos
            end
            x_pos += 1
          end
          y_pos += 1
        end
        z_pos += 1
      end
      space
    end

    def free_space
      self.volume - (self.box_positions.collect { |bp| bp.box }.sum { |bx| bx.volume })
    end

    def position_for_box(box)
      spot = nil
      free_space = self.get_space
      free_space.each { |sp|
        if ((self.width - sp.x) >= box.width)
          if ((self.length - sp.y) >= box.length)
            if ((self.height - sp.z) >= box.height)
              spot = sp
              break
            end
          end
        end
      }
      spot
    end

    def add_box(box)
      pos = self.position_for_box(box)
      if pos
        bp = OpenShip::BoxPosition.new
        bp.box = box
        bp.position = pos
        self.box_positions << bp
      end
      pos
    end



  end

  class OpenShip::Shipment


    attr_accessor :boxes_to_stores, :cartons_to_stores

    def initialize()
      @cartons_to_stores = nil
      @boxes_to_stores = {}
    end

    def fitness

      if @cartons_to_stores.nil?
        @cartons_to_stores = {}
        self.boxes_to_stores.each { |k, v|
          @cartons_to_stores[k] ||= []
          cart = OpenShip::Carton.new
          puts "New Box"
          cart.width = 20
          cart.height = 20
          cart.length = 10
          @cartons_to_stores[k] << cart
          v.each { |box|
            pos = cart.add_box(box)
            if pos.nil?
              cart = OpenShip::Carton.new
              puts "New Box"
              cart.width = 20
              cart.height = 20
              cart.length = 10
              @cartons_to_stores[k] << cart
              pos = cart.add_box(box)
              if pos.nil?
                raise "Box is too big for carton."
              end
            end
          }
        }
      end

      #total_volume = 0
      #self.cartons_to_stores.collect { |k, v| v }.flatten.each { |cart| total_volume += cart.volume }

      #total_free = 0
      #self.cartons_to_stores.collect { |k, v| v }.flatten.each { |cart| total_free += cart.free_space }
      #puts "Fitness: " + (total_volume / (total_free + 0.001)).to_s
      #(total_volume / (total_free + 0.001))
      free_space = self.cartons_to_stores.sum { |k, v| v.sum { |c| c.free_space } }
      box_count = self.boxes_to_stores.sum { |k, v| v.count }
      carton_count = self.cartons_to_stores.sum { |k, v| v.count }
      puts "Box Count: " + box_count.to_s
      puts "Carton Free Space: " + free_space.to_s
      puts "Carton Count: " + carton_count.to_s
      fitness = (box_count.to_f / carton_count.to_f) / free_space.to_f
      puts "Fitness " + fitness.to_s
      fitness
    end

    def stats
      ["Total Volume :" + self.boxes_to_stores.sum { |k, v| v.sum { |b| b.volume } }.to_s]
    end


    def recombine(c2)
      return1 = self.clone
      return2 = c2.clone
      self.boxes_to_stores.each { |k, v|
        bxs = c2.boxes_to_stores[k]

        cross_point = (rand * bxs.size).to_i
        c1_a, c1_b = v.separate(cross_point)
        c2_a, c2_b = bxs.separate(cross_point)
        return1.boxes_to_stores[k] = c1_a + c2_b
        return2.boxes_to_stores[k] = c2_a + c1_b
      }
      return1.cartons_to_stores = nil
      return2.cartons_to_stores = nil
      return1
    end

    def mutate
      self
    end

  end

end
