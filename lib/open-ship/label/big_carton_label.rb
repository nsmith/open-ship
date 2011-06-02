require 'prawn'
require 'prawn/measurement_extensions'
require 'barby'
require 'barby/outputter/prawn_outputter'

module OpenShip
  module Label

    class BigCartonLabel < CartonLabel

      attr_accessor :from1, :from2, :from3, :to1, :to2, :to3, :bol, :scac,
        :tracking, :zip, :po_number, :vendor_number, :facility_code, :store_number, :sscc

      def self.to_pdf(cl, filename)

        Prawn::Document.generate(filename, :page_size   => [4.in, 6.6.in],
          :right_margin => 0.0.cm,
          :left_margin => 0.0.cm,
          :top_margin => 0.0.cm,
          :bottom_margin => 0.0.cm,
          :page_layout => :portrait) do


          # Field A
          bounding_box [0,6.6.in], :width => 1.75.in, :height => 1.in do
            indent(5) do
              move_down 5
              self.font_size = 12
              text "FROM:"
            end
            indent(10) do
              move_down 5
              self.font_size = 8
              text cl.from1
              text cl.from2
              text cl.from3
            end
            stroke_bounds
          end
          
          # Field B
          bounding_box [1.75.in,6.6.in], :width => 2.25.in, :height => 1.in do
            indent(5) do
              move_down 5
              self.font_size = 12
              text "TO:"
            end
            indent(10) do
              move_down 5
              self.font_size = 8
              text cl.to1
              text cl.to2
              text cl.to3
            end

            stroke_bounds
          end

          # Field C
          bounding_box [0.in,5.6.in], :width => 1.5.in, :height => 1.in do
            indent(5) do
              move_down 5
              self.font_size = 12
              text "CARRIER INFO:"
            end

            indent(10) do
              move_down 5
              self.font_size = 10
              if cl.bol
                text "B/L: #{cl.bol}"
              end
              if cl.scac
                text "SCAC: #{cl.scac}"
              end
              if cl.tracking
                text "PRO: #{cl.tracking}"
              end
            end


            stroke_bounds
          end

          # Field D
          bounding_box [1.5.in,5.6.in], :width => 2.5.in, :height => 1.in do
            if cl.zip.nil?
              raise "Zip must not be nil!"
            end
            the_zip = ("420" + cl.zip.to_s)
            indent(5) do
              move_down 5
              self.font_size = 12
              text "POSTAL ZIP:"
            end

            indent(10) do
              self.font_size = 12
              text the_zip
            end

            barcode = Barby::Code128A.new(the_zip)

            barcode.annotate_pdf(self, {:x => 10, :y => 5, :xdim => 0.010.in, :height => 0.5.in})



            stroke_bounds
          end

          # Field E
          bounding_box [0.in,4.6.in], :width => 4.in, :height => 1.in do
            indent(100) do
              move_down 20
              self.font_size = 12
              text "PO Number: #{cl.po_number}"
              if cl.vendor_number
                text  ("Vendor Number: " + cl.vendor_number.to_s)
              end
            end

            barcode = Barby::Code128A.new(cl.po_number)

            barcode.annotate_pdf(self, {:x => 10, :y => 20, :xdim => 0.010.in, :height => 0.5.in})

            stroke_bounds
          end

          # Field F
          bounding_box [0.in,3.6.in], :width => 4.in, :height => 1.in do

            indent(10) do
              move_down 10
              self.font_size = 12
              if cl.quantity
                text "QTY: #{cl.quantity}"
              end
              if cl.upc
                text "UPC: #{cl.upc}"
                barcode = Barby::Code128A.new(cl.upc)

                barcode.annotate_pdf(self, {:x => 130, :y => 20, :xdim => 0.010.in, :height => 0.5.in})

              end
              if cl.style
                text "Description: #{cl.style}"
              end
            end

            stroke_bounds
          end

          # Field G
          bounding_box [0.in,2.6.in], :width => 2.5.in, :height => 1.in do
            stroke_bounds
          end

          # Field H
          bounding_box [2.5.in,2.6.in], :width => 1.5.in, :height => 1.in do

            indent(5) do
              move_down 5
              self.font_size = 12
              text "STORE:"
            end
            indent(10) do
              move_down 10
              self.font_size = 16
              text(("<b>" + cl.store_number.to_s + "</b>"), :inline_format => true)
            end


            stroke_bounds
          end

          # Field I
          bounding_box [0.in,1.6.in], :width => 4.in, :height => 1.6.in do

            indent(5) do
              move_down(5)
              self.font_size = 10
              text "SSCC-18"
            end
            
            indent(60) do
              move_down 5
              self.font_size = 12
              text ("(00) " + cl.sscc)
            end

            barcode = Barby::GS1128.new(cl.sscc, "A", "00")

            barcode.annotate_pdf(self, {:x => 40, :y => 5, :xdim => 0.010.in, :height => 1.in})

            stroke_bounds
          end



        end

      end


    end

  end
end

