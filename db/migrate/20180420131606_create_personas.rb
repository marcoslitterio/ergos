class CreatePersonas < ActiveRecord::Migration[5.0]
  def change
    create_table :personas do |t|
      t.integer :tipo_documento_id
      t.integer :numero_documento
      t.bigint :cuit
      t.string :apellido
      t.string :nombre
      t.string :domicilio
      t.string :telefono
      t.string :email
      t.date :fecha_nacimiento

      t.timestamps
    end
  end
end
