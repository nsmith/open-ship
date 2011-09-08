module OpenShip
  module Label

    class BnProductLabel < CartonLabel

      attr_accessor :vendor, :weight, :price

      def self.to_pdf(cl, filename)
        Prawn::Document.generate(filename, :page_size => [6.in, 4.in],
          :right_margin => 0.0.in,
          :left_margin => 0.0.in,
          :top_margin => 0.0.in,
          :bottom_margin => 0.0.in,
          :page_layout => :portrait) do

            bounding_box [0.01,3.98.in], :width => 5.98.in, :height => 0.75.in do
              indent(10) do
                move_down 5
                self.font_size = 14
                text "TITLE: " + cl.product
                text "VENDOR: " + cl.vendor
                text cl.origin
              end
              stroke_bounds
            end

            bounding_box [0.01,3.23.in], :width => 5.98.in, :height => 0.75.in do

              stroke_bounds
            end

            bounding_box [0.01,2.48.in], :width => 5.98.in, :height => 2.5.in do
              # Left Side
              text_box ("CTN QTY: " + cl.quantity.to_s), :size => 12, :at => [0.2.in, 2.31.in], :width => 2.in, :height => 0.16.in
              quantity_string = cl.quantity.to_s
              if quantity_string.length == 1
                quantity_string = "0" + quantity_string
              end
              upc_barcode = Barby::GS1128.new(quantity_string, "C", "30")
              upc_barcode.annotate_pdf(self, {:x => 0.2.in, :y => 1.4.in, :xdim => 0.015.in, :height => 0.75.in})
              text_box ("(30) " + quantity_string), :size => 12, :at => [0.2.in, 1.35.in], :width => 2.in, :height => 0.16.in

              text_box ("UPC: " + cl.upc.to_s), :size => 12, :at => [0.2.in, 1.11.in], :width => 2.in, :height => 0.16.in
              upc_barcode = Barby::GS1128.new(cl.encoded_upc, "C", "01")
              upc_barcode.annotate_pdf(self, {:x => 0.2.in, :y => 0.2.in, :xdim => 0.015.in, :height => 0.75.in})
              text_box ("(01) " + cl.encoded_upc), :size => 12, :at => [0.2.in, 0.18.in], :width => 2.in, :height => 0.16.in

              # Right Side
              text_box ("CTN WGT: " + cl.weight.round(1).to_s + " lbs"), :size => 12, :at => [3.0.in, 2.31.in], :width => 2.in, :height => 0.16.in
              weight_string = cl.weight.round(1).to_s.gsub(".", "").rjust(6, "0")
              upc_barcode = Barby::GS1128.new(weight_string, "C", "3401")
              upc_barcode.annotate_pdf(self, {:x => 3.0.in, :y => 1.4.in, :xdim => 0.015.in, :height => 0.75.in})
              text_box ("(3401) " + weight_string), :size => 12, :at => [3.0.in, 1.35.in], :width => 2.in, :height => 0.16.in

              text_box ("UNIT PRICE: " + cl.price.round(2).to_s + " USD"), :size => 12, :at => [3.0.in, 1.11.in], :width => 2.in, :height => 0.16.in
              price_string = (cl.price.to_f.round(2).to_s.gsub(".", "") + "USD")
              price_string = "1299USD"
              puts price_string
              upc_barcode = Barby::GS1128.new(price_string, "A", "9012Q")
              upc_barcode.annotate_pdf(self, {:x => 3.0.in, :y => 0.2.in, :xdim => 0.015.in, :height => 0.75.in})
              text_box ("(9012Q) " + price_string), :size => 12, :at => [3.0.in, 0.18.in], :width => 2.in, :height => 0.16.in

              stroke_bounds
            end


          end

      end

      def encoded_upc
        self.class.encode_upc(self.upc.to_s)
      end

      def self.encode_upc(upc12)
        # It's gotta be a string because of the leading zero possibility
        # in the extension digit.
        unless upc12.class <= String
          raise "Can only check string sequences."
        end
        unless upc12.length == 12
          raise "UPC 12 must be 12 characters long"
        end

        sequence = []
        upc12.each_char { |chr|
          sequence << chr.to_i
        }

        # Add '1' (carton indicator) and '0' (EAN prefix)
        sequence = [1, 0] + sequence

        # Drop the original check digit.
        sequence.pop

        # Add a new check digit
        sequence.push(self.generate_upc_check_digit(sequence))

        sequence.join
      end

      def self.generate_upc_check_digit(sequence)

        unless sequence.length == 13
          raise "Sequence must be 13 characters long."
        end

        array1 = [sequence[0], sequence[2], sequence[4], sequence[6],
          sequence[8], sequence[10], sequence[12]]
        number1 = (array1.inject(:+) * 3)
        array2 = [sequence[1], sequence[3], sequence[5], sequence[7], sequence[9],
          sequence[11]]
        number2 = array2.inject(:+)
        number3 = number1 + number2
        check_digit = (10 - (number3 % 10))
        if check_digit == 10
          check_digit = 0
        end
        check_digit.to_s
      end

    end

  end
end
