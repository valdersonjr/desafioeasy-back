class ChangeBallastToIntegerInProducts < ActiveRecord::Migration[7.0]
  def up
    change_column :products, :ballast, 'integer USING CAST(ballast AS integer)'
  end

  def down
    change_column :products, :ballast, :string
  end
end