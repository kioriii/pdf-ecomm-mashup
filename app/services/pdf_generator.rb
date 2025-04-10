class PdfGenerator
  def self.generate_empty_pages(n)
    # validate input
    n = n.to_i
    return if n<=0

    pdf = Prawn::Document.new

    # Generate n empty pages
    (1..n).each do |page_number|
      # Add a new page (except for the first one which is created automatically
      pdf.start_new_page unless page_number ==1

      # add page number as footer
      pdf.text "#{page_number}", align: :center, size: 10
    end

    pdf.render
  end
end
