class CreateBrigitteGameTable < ActiveRecord::Migration[6.0]
  def change
    create_table :brigitte_games do |t|
      t.belongs_to :table, type: :uuid
      t.jsonb :game
    end
  end
end
