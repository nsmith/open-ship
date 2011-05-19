require 'prawn'
require 'prawn/measurement_extensions'
require 'barby'
require 'barby/outputter/prawn_outputter'

module OpenShip
  module Label

    class TextLabel

      attr_accessor :address1, :address2, :address3, :address4,
        :sku, :po, :line, :quantity, :total_cartons

      def to_pdf
        document = Prawn::Document.new(:page_size   => [20.cm, 15.cm],
          :page_layout => :portrait)


        document.text_box(self.address1, :size => 16, :align => :left, :at => [0.2.cm, 11.cm], :width => 12.cm, :height => 0.75.cm)
        document.text_box(self.address2, :size => 16, :align => :left, :at => [0.2.cm, 10.25.cm], :width => 12.cm, :height => 0.75.cm)
        document.text_box(self.address3, :size => 16, :align => :left, :at => [0.2.cm, 9.5.cm], :width => 12.cm, :height => 0.75.cm)
        document.text_box(self.address4, :size => 16, :align => :left, :at => [0.2.cm, 8.75.cm], :width => 12.cm, :height => 0.75.cm)


        po_line = "PO#: #{self.po}"
        document.text_box(po_line, :size => 16, :align => :left, :at => [0.2.cm, 7.25.cm], :width => 12.cm, :height => 0.75.cm)

        line_no = "Line #: #{self.line}"
        document.text_box(line_no, :size => 16, :align => :left, :at => [0.2.cm, 6.5.cm], :width => 12.cm, :height => 0.75.cm)

        style_line = "Mfg Style #: #{self.sku}"
        document.text_box(style_line, :size => 16, :align => :left, :at => [0.2.cm, 5.75.cm], :width => 12.cm, :height => 0.75.cm)

        quantity_line = "Inner Pk Qty: #{self.quantity}"
        document.text_box(quantity_line, :size => 16, :align => :left, :at => [0.2.cm, 5.cm], :width => 12.cm, :height => 0.75.cm)

        total_cartons_line = "Total Master Pk. Cartons per Line Item: #{self.total_cartons}"
        document.text_box(total_cartons_line, :size => 16, :align => :left, :at => [0.2.cm, 4.25.cm], :width => 15.cm, :height => 0.75.cm)


        document.text_box("Pre-Priced: NO", :size => 20, :align => :left, :at => [0.2.cm, 3.cm], :width => 12.cm, :height => 1.cm)
        document.text_box("FRAGILE: NO", :size => 20, :align => :left, :at => [0.2.cm, 2.cm], :width => 12.cm, :height => 1.cm)


        document
      end

    end

  end
end
