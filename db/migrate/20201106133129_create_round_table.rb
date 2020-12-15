class CreateRoundTable < ActiveRecord::Migration[6.0]
  def change
    create_table :rounds do |t|
      t.belongs_to :table, type: :uuid
      t.jsonb :game
    end
  end
end
