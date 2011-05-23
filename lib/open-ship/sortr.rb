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
          if ((pos.x >= bp.position.x) && (pos.x < bp.box.width))
            if ((pos.y >= bp.position.y) && (pos.y < bp.box.length))
              if ((pos.z >= bp.position.z) && (pos.z < bp.box.height))
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
      x_pos = 0
      while (x_pos < self.width)
        y_pos = 0
        while(y_pos < self.length)
          z_pos = 0
          while(z_pos < self.height)
            pos = Position.new
            pos.x = x_pos
            pos.y = y_pos
            pos.z = z_pos
            unless self.space_packed(pos)
              space << pos
            end
            z_pos += 1
          end
          y_pos += 1
        end
        x_pos += 1
      end
      space
    end

    def free_space
      self.volume - (self.box_positions.collect { |bp| bp.box }.sum { |bx| bx.volume } + self.margin)
    end


    def get_free_space
      cube_space = self.get_space
      self.box_positions.each { |bp|
        cube_space.each { |cs|
          puts "Position x: #{cs.x} y: #{cs.y} z: #{cs.z}"
          if (cs.x < (bp.position.x + bp.box.width))
            if (cs.y < (bp.position.y + bp.box.length))
              if (cs.x < (bp.position.z + bp.box.height))
                cube_space.delete cs
              end
            end
          end
        }
      }
      cube_space
    end

  end

end
