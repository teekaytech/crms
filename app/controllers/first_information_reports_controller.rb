class FirstInformationReportsController < ApplicationController
  before_action :authenticate_user
  before_action :set_first_information_report, only: %i[show edit update destroy approve reject]

  def index
    @firs = FirstInformationReport
      .where(active: TRUE)
      .includes(%i[user complainant])
      .paginate(page: params[:page], per_page: 10)
      .order('created_at DESC')
  end

  def show
  end

  def new
    @first_information_report = FirstInformationReport.new
  end

  def edit
    @users = User.where(active: TRUE).all
    @complainants = Complainant.where(active: TRUE).all
  end

  def create
    @first_information_report = FirstInformationReport.new(first_information_report_params)

    respond_to do |format|
      if @first_information_report.save
        format.html { redirect_to @first_information_report, notice: "First information report was successfully created." }
        format.json { render :show, status: :created, location: @first_information_report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @first_information_report.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      p first_information_report_params
      if @first_information_report.update(first_information_report_params)
        format.html { redirect_to @first_information_report, notice: "First information report was successfully updated." }
        format.json { render :show, status: :ok, location: @first_information_report }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @first_information_report.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @first_information_report.active = false
    @first_information_report.save
    respond_to do |format|
      format.html { redirect_to first_information_reports_url, notice: "FIR with ID: #{@first_information_report.id} was successfully deleted." }
      format.json { head :no_content }
    end
  end

  def approve
    @first_information_report.approved!
    if @first_information_report.save
      redirect_to first_information_reports_path, notice: "FIR with ID: #{@first_information_report.id} approved successfully!"
    else
      redirect_to first_information_report_path, notice: "FIR with ID: #{@first_information_report.id} approval failed. Please, try again."
    end
  end

  def reject
    @first_information_report.rejected!
    if @first_information_report.save
      redirect_to first_information_reports_path, notice: "FIR with ID: #{@first_information_report.id} rejected successfully!"
    else
      redirect_to first_information_report_path, notice: "FIR with ID: #{@first_information_report.id} rejection failed. Please, try again."
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_first_information_report
    @first_information_report = FirstInformationReport.find(params[:id])
  end

  def first_information_report_params
    params.require(:first_information_report).permit(:user_id, :complainant_id, :offense, :date, :location,
                                                     :suspect_details, :status, :active)
  end
end
