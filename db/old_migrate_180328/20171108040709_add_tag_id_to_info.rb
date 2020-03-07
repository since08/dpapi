class AddTagIdToInfo < ActiveRecord::Migration[5.0]
  def change
    add_reference :infos, :race_tag
    add_reference :info_ens, :race_tag
  end
end
