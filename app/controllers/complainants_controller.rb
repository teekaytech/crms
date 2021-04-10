class ComplainantsController < ApplicationController
  before_action :set_complainant, only: %i[show edit update destroy]

  def index
    @complainants = Complainant.includes(:user).paginate(page: params[:page], per_page: 10).order('created_at DESC')
  end

  def show; end

  def new
    @complainant = Complainant.new
  end

  def edit; end

  def create
    @complainant = current_user.complainants.new(complainant_params)

    respond_to do |format|
      if @complainant.save
        format.html { redirect_to @complainant, notice: 'Complainant was successfully created.' }
        format.json { render :show, status: :created, location: @complainant }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @complainant.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @complainant.update(complainant_params)
        format.html { redirect_to @complainant, notice: 'Complainant was successfully updated.' }
        format.json { render :show, status: :ok, location: @complainant }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @complainant.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @complainant.active = @complainant.active ? false : true
    @complainant.save
    redirect_to complainants_url, notice: "Complainant with ID: #{@complainant.id} was successfully updated."
  end

  private

  def set_complainant
    @complainant = Complainant.includes(:user).find(params[:id])
  end

  def complainant_params
    params.require(:complainant).permit(:user_id, :surname, :firstname, :dob, :nationality, :address,
                                        :occupation, :phone, :gender, :email)
  end
end
