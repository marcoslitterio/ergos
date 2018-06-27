class Concesionarium < ApplicationRecord
	belongs_to :user
	has_many :persona_concesionaria, :foreign_key => 'concesionaria_id', :class_name => 'PersonaConcesionarium'
	has_many :personas, :through => :persona_concesionaria 

	has_many :puntos_venta, :foreign_key => 'concesionaria_id', :class_name => 'PuntoVentum'

	has_attached_file :logo, styles: { medium: "300x325>", thumb: "100x100>" }, default_url: "/assets/:style/missing_concesionaria.png"
	validates_attachment_content_type :logo, content_type: /\Aimage/
	validates_attachment :logo, content_type: { content_type: ['image/jpeg', 'image/png', 'image/jpg'] } 
	validates_attachment_size :logo, less_than_or_equal_to: 4.megabytes

	validates :nombre, :presence => { :message => "Debe completar el campo Nombre" }

	validates :cantPv , :presence => { :message => "Debe completar la cantidad de Puntos de Venta" }
	validates :cantVend , :presence => { :message => "Debe completar la cantidad de PVendedores" }

    validates :cantPv, numericality: { only_integer: true, :message => "El campo Cantidad de Puntos de venta debe ser un valor entero"}

    validates :cantVend, numericality: { only_integer: true, :message => "El campo Cantidad de Vendedores debe ser un valor entero"}

	accepts_nested_attributes_for :persona_concesionaria, allow_destroy: true

	validate :control_punto_venta
	validate :control_vendedores
	validate :nombre_conce

	def to_s
		"#{self.nombre}"
	end

	def control_punto_venta
		if (self.cantPv.to_i < self.puntos_venta.where(baja: false).count.to_i)
          errors.add(:base, "Debe eliminar puntos de venta para poder editar")
        end
	end

	def nombre_conce
		conCant = Concesionarium.where(:nombre => self.nombre).where.not(id: self.id).first
		if (conCant  != nil)
		  if (fecha_baja == nil)
           errors.add(:base, "Ya existe una concesionaria con ese nombre")
          end
        end
	end

	def control_vendedores
		cant_vendedores = 0
		self.puntos_venta.where(baja: false).each do |pv|
			cant_vendedores = cant_vendedores + pv.vendedors.where('baja is null or baja = false').count
		end
		if (self.cantVend.to_i < cant_vendedores)
          errors.add(:base, "Debe eliminar vendedores para poder editar")
        end
	end
end
