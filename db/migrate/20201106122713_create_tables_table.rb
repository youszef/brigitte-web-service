class CreateTablesTable < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :tables, id: :uuid do |t|
      t.jsonb :players
    end
  end
end
