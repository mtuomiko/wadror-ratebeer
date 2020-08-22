class StylesController < ApplicationController
  before_action :ensure_that_signed_in, except: [:index, :show]
  before_action :set_style, only: [:show, :edit, :update, :destroy]

  def index
    @styles = Style.all
  end

  def show; end

  def new
    @style = Style.new
  end

  def edit
  end

  def create
    @style = Style.new style_params

    if @style.save
      redirect_to styles_path, notice: "#{@style.name} style was successfully created."
    else
      render :new
    end
  end

  def update
    if @style.update(style_params)
      redirect_to @style, notice: 'Style was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @style.destroy
    redirect_to styles_path, notice: "#{@style.name} style was successfully destroyed."
  end

  def set_style
    @style = Style.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def style_params
    params.require(:style).permit(:name, :description)
  end
end
