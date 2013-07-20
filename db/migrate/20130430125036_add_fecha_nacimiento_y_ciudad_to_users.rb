class AddFechaNacimientoYCiudadToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ciudad_residencia, :string
  end
end
