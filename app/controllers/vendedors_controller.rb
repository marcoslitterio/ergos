class VendedorsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :set_vendedor, only: [:show, :edit, :update, :destroy]

  # GET /vendedors
  # GET /vendedors.json
  def index
    @vendedors = Vendedor.all
  end

  # GET /vendedors/1
  # GET /vendedors/1.json
  def show
    
  end

  # GET /vendedors/new
  def new
    @vendedor = Vendedor.new
  end

  # GET /vendedors/1/edit
  def edit
    
  end

  # POST /vendedors
  # POST /vendedors.json
  def create
    
    @vendedor = Vendedor.new(vendedor_params)
    debugger
    if  Persona.where(:numero_documento => params[:numero_documento]).first == nil
      @persona = Persona.new()
      @persona.numero_documento=params[:numero_documento]
      @persona.tipo_documento=params[:tipo_documento_id]
      @persona.cuit=params[:cuit]
      @persona.apellido=params[:apellido]
      @persona.nombre=params[:nombre]
      @persona.domicilio=params[:domicilio]
      @persona.telefono=params[:telefono]
      @persona.fecha_nacimiento=params[:fecha_nacimiento]
    else
      @persona= Persona.where(:numero_documento => params[:numero_documento]).first
      @persona.tipo_documento=params[:tipo_documento_id]
      @persona.cuit=params[:cuit]
      @persona.apellido=params[:apellido]
      @persona.nombre=params[:nombre]
      @persona.domicilio=params[:domicilio]
      @persona.telefono=params[:telefono]
      @persona.fecha_nacimiento=params[:fecha_nacimiento]
    end
    debugger
    respond_to do |format|
      if @vendedor.save and @persona.save
        format.html { redirect_to @vendedor, notice: 'Vendedor was successfully created.' }
        format.json { render :show, status: :created, location: @vendedor }
      else
        format.html { render :new }
        format.json { render json: @vendedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vendedors/1
  # PATCH/PUT /vendedors/1.json
  def update
    respond_to do |format|
      if @vendedor.update(vendedor_params)
        format.html { redirect_to @vendedor, notice: 'Vendedor was successfully updated.' }
        format.json { render :show, status: :ok, location: @vendedor }
      else
        format.html { render :edit }
        format.json { render json: @vendedor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendedors/1
  # DELETE /vendedors/1.json
  def destroy
    @vendedor.destroy
    respond_to do |format|
      format.html { redirect_to vendedors_url, notice: 'Vendedor was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vendedor
      @vendedor = Vendedor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vendedor_params
      params.require(:vendedor).permit(:foto, :numero, :fecha_alta, :fecha_baja, :persona_id)
    end
end
