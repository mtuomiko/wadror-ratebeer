class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update, :destroy]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    all_beer_clubs = BeerClub.all
    @beer_clubs = all_beer_clubs.reject { |c| current_user.beer_clubs.include? c }
  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @membership.user = current_user

    respond_to do |format|
      if @membership.save
        format.html { redirect_to @membership.beer_club, notice: "Welcome to the club, #{@membership.user.username}!" }
        format.json { render :show, status: :created, location: @membership }
      else
        @beer_clubs = BeerClub.all
        format.html { render :new }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { render :show, status: :ok, location: @membership }
      else
        format.html { render :edit }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @membership.destroy
    respond_to do |format|
      format.html { redirect_to @membership.user, notice: "Membership in #{@membership.beer_club.name} ended." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_membership
    @membership = Membership.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def membership_params
    params.require(:membership).permit(:beer_club_id)
  end
end
