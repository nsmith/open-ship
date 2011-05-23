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
    attr_accessor :length, :width, :height, :label

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
      self.volume - (self.box_positions.collect { |bp| bp.box }.sum { |bx| bx.volume } + self.margin)
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



  end

end
