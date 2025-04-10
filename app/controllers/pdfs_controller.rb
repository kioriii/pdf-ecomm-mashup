class PdfsController < ApplicationController
  before_action :set_pdf, only: %i[ show edit update destroy ]

require "prawn"
require "prawn/measurement_extensions"


# function to generate an empty pdf and download it
def new_empty_pdf
  # This method was taught by youtube
  # new_pdf = Prawn::Document.new
  # new_pdf.text "new pdf"
  # send_data(new_pdf.render, filename: "test.pdf", type: "application/pdf")

  # generate("hello.pdf") do
  # text "Hello World!"
  # end

  # This method is from the Prawn PDF Manual
  # Generate method without block arguments is preferred but you are not able to reference variables i think

  new_pdf =Prawn::Document.generate("test.pdf") do
    text "new pdf rendered with implicit block - no variables allowed"
  end

  # This downloads the pdf object
  send_data(new_pdf, filename: "test_implict_block.pdf", type: "application/pdf")
end

def new_test_pdf
  number = 10
  number_of_pages = [ *1..number ]
  puts number
  puts number_of_pages

  new_test_pdf = Prawn::Document.generate("test.pdf", margin: 35.mm) do
    # text "new test pdf"
    # text "35mm margin on all 4 sides of each page"
    stroke_bounds
    number_of_pages.each do |i|
      start_new_page
      stroke_bounds
    end
  end

  # This downloads the pdf object
  send_data(new_test_pdf, filename: "new_test_pdf.pdf", type: "application/pdf")
end

# Function that is new_test_pdf but uses userinput in order to determine number of pdf pages to be generated
def new_test_pdfnumber_pdf
  number = params[:number].to_i # note that we use local variable, not instance variable so that Prawn doc instance below can still access
  number_of_pages = [ *1..number ]

  puts number # this should be equal to what was keyed in on the website
  puts number_of_pages

  new_test_pdf = Prawn::Document.new(margin: 35.mm) do |doc|
    # text "new test pdf"
    # text "35mm margin on all 4 sides of each page"
    number_of_pages.each do |i|
      doc.start_new_page
      doc.stroke_bounds
    end
  end

  rendered_pdf = new_test_pdf.render

  send_data(
    rendered_pdf,
    filename: "newdocument.pdf",
    type: "application/pdf",
    disposition: "attachment" # "attachment" forces download, "inline" displays in browser
  )

  # respond_to do |format|
  #   format.turbo_stream do
  # redirect_to download_pdf
  #     return
  #   end
  # end
end

# Same as new_test_pdfnumber, but adding numbering to every page
def new_test_pdfnumber_numbered_pdf
  number = params[:number].to_i # note that we use local variable, not instance variable so that Prawn doc instance below can still access
  number_of_pages = [ *1..number ]

  puts number # this should be equal to what was keyed in on the website
  puts number_of_pages

  new_test_pdf = Prawn::Document.new(margin: 35.mm) do |doc|
    # text "new test pdf"
    # text "35mm margin on all 4 sides of each page"
    number_of_pages.each do |i|
      doc.start_new_page
      doc.stroke_bounds
    end

    # This part is the numbering; note that it can take every parameter that a text box can take
    doc.number_pages "<page>", {
      start_count_at: 2,
      # at: [ bounds.right - 150, 0 ],
      align: :right,
      size: 14,
      page_filter: lambda { |pg| pg !=1 }
    }
  end

  rendered_pdf = new_test_pdf.render

  send_data(
    rendered_pdf,
    filename: "newdocument.pdf",
    type: "application/pdf",
    disposition: "attachment" # "attachment" forces download, "inline" displays in browser
  )
end


  # GET /pdfs or /pdfs.json
  def index
    @pdfs = Pdf.all
  end

  # GET /pdfs/1 or /pdfs/1.json
  def show
  end

  # GET /pdfs/new
  def new
    @pdf = Pdf.new
  end

  # GET /pdfs/1/edit
  def edit
  end

  # POST /pdfs or /pdfs.json
  def create
    @pdf = Pdf.new(pdf_params)

    respond_to do |format|
      if @pdf.save
        format.html { redirect_to @pdf, notice: "Pdf was successfully created." }
        format.json { render :show, status: :created, location: @pdf }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @pdf.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pdfs/1 or /pdfs/1.json
  def update
    respond_to do |format|
      if @pdf.update(pdf_params)
        format.html { redirect_to @pdf, notice: "Pdf was successfully updated." }
        format.json { render :show, status: :ok, location: @pdf }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @pdf.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pdfs/1 or /pdfs/1.json
  def destroy
    @pdf.destroy!

    respond_to do |format|
      format.html { redirect_to pdfs_path, status: :see_other, notice: "Pdf was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pdf
      @pdf = Pdf.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def pdf_params
      params.fetch(:pdf, {})
    end
end
