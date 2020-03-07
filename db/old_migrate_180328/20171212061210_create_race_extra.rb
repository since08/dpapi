class CreateRaceExtra < ActiveRecord::Migration[5.0]
  def change
    create_table :race_extras do |t|
      t.references :race
      t.text :blind_memo, comment: '盲注结构的备注'
      t.text :schedule_memo, comment: '赛程的备注'
    end

    create_table :race_extra_ens do |t|
      t.references :race
      t.text :blind_memo, comment: '盲注结构的备注'
      t.text :schedule_memo, comment: '赛程的备注'
    end
  end
end
