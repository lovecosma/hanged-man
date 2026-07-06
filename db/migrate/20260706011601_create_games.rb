class CreateGames < ActiveRecord::Migration[8.0]
  def change
    create_table :games do |t|
      t.string :state
      t.string :answer, null: false
      t.string :board, array: true, default: [], null: false
      t.jsonb :guesses, default: {}, null: false
      t.integer :number_of_tries, default: 0, null: false
      t.timestamps
    end
  end
end
