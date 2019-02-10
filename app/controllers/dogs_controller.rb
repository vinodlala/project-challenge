class DogsController < ApplicationController
  before_action :set_dog, only: %i[show edit update destroy like unlike]
  before_action :redirect_non_owner, only: %i[edit update destroy]

  include DogsHelper

  # GET /dogs
  # GET /dogs.json
  def index
    @dogs = Dog.all.paginate(page: params[:page], per_page: 5)
  end

  # GET /dogs/1
  # GET /dogs/1.json
  def show
  end

  # GET /dogs/new
  def new
    @dog = Dog.new
  end

  # GET /dogs/1/edit
  def edit
  end

  # POST /dogs
  # POST /dogs.json
  def create
    @dog = Dog.new(dog_params)

    @dog.user = current_user

    respond_to do |format|
      if @dog.save
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully created.' }
        format.json { render :show, status: :created, location: @dog }
      else
        format.html { render :new }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /dogs/1
  # PATCH/PUT /dogs/1.json
  def update
    respond_to do |format|
      if @dog.update(dog_params)
        @dog.images.attach(params[:dog][:image]) if params[:dog][:image].present?

        format.html { redirect_to @dog, notice: 'Dog was successfully updated.' }
        format.json { render :show, status: :ok, location: @dog }
      else
        format.html { render :edit }
        format.json { render json: @dog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /dogs/1
  # DELETE /dogs/1.json
  def destroy
    @dog.destroy
    respond_to do |format|
      format.html { redirect_to dogs_url, notice: 'Dog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /dogs/:dog_id/like
  def like
    Like.find_or_create_by(dog_id: @dog.id, user_id: current_user.id)

    redirect_to @dog
  end

  # DELETE /dogs/:dog_id/like
  def unlike
    like = Like.find_by(dog_id: @dog.id, user_id: current_user.id)

    like.delete if like

    redirect_to @dog
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_dog
    @dog = Dog.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def dog_params
    params.require(:dog).permit(:name, :description, :images)
  end

  def redirect_non_owner
    unless current_user_owns_dog?
      redirect_back fallback_location: root_path,
                    notice: 'Sorry, you can only edit your own dog.'
    end
  end
end
