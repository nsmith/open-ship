require 'prawn'
require 'prawn/measurement_extensions'
require 'barby'
require 'barby/outputter/prawn_outputter'

module OpenShip
  module Label

    class CartonLabel

      attr_accessor :product, :style, :sku, :upc, :quantity, :origin

      def gtin
        self.upc.to_s.rjust(14, "0")
      end

      def to_pdf
        document = Prawn::Document.new(:page_size   => [11.cm, 6.7.cm],
          :right_margin => 0.0.cm,
          :left_margin => 0.0.cm,
          :top_margin => 0.0.cm,
          :bottom_margin => 0.0.cm,
          :page_layout => :portrait)

        barcode = Barby::Code25Interleaved.new(self.gtin)

        barcode.annotate_pdf(document, {:x => 0.5.cm, :y => 1.7.cm, :xdim => 0.073.cm, :height => 2.5.cm})

        document.stroke do
          document.rectangle [0.5.cm,6.4.cm], 1.5.cm, 1.5.cm
        end


        document.text_box("QTY", :size => 16, :align => :center, :at => [0.5.cm, 6.3.cm], :width => 1.5.cm, :height => 1.cm)
        document.text_box(self.quantity.to_s, :size => 20, :align => :center, :at => [0.5.cm, 5.7.cm], :width => 1.5.cm, :height => 1.5.cm)


        document.text_box(self.gtin[0..7], :size => 16, :align => :left, :at => [2.2.cm, 6.3.cm], :width => 2.cm, :height => 1.cm)
        document.text_box(self.gtin[8..12], :size => 20, :align => :left, :at => [2.2.cm, 5.7.cm], :width => 2.5.cm, :height => 1.5.cm)

        document.text_box(self.product, :size => 12, :align => :right, :at => [7.5.cm, 6.4.cm], :width => 3.cm, :height => 0.5.cm)
        document.text_box(self.style, :size => 12, :align => :right, :at => [7.5.cm, 5.9.cm], :width => 3.cm, :height => 0.5.cm)
        document.text_box(self.sku, :size => 12, :align => :right, :at => [7.5.cm, 5.4.cm], :width => 3.cm, :height => 0.5.cm)

        document.text_box(self.origin, :size => 10, :align => :center, :at => [0.cm, 0.75.cm], :width => 11.cm, :height => 0.5.cm)

        document.font("Courier")

        document.text_box(self.gtin[0..0], :size => 16, :align => :left, :at => [1.25.cm, 1.5.cm], :width => 0.8.cm, :height => 1.cm)
        document.text_box(self.gtin[1..2], :size => 16, :align => :left, :at => [2.3.cm, 1.5.cm], :width => 1.cm, :height => 1.cm)
        document.text_box(self.gtin[3..7], :size => 16, :align => :left, :at => [3.7.cm, 1.5.cm], :width => 2.cm, :height => 1.cm)
        document.text_box(self.gtin[8..12], :size => 16, :align => :left, :at => [6.45.cm, 1.5.cm], :width => 2.cm, :height => 1.cm)
        document.text_box(self.gtin[13..13], :size => 16, :align => :left, :at => [9.15.cm, 1.5.cm], :width => 1.cm, :height => 1.cm)

        document
      end

    end

  end
end
