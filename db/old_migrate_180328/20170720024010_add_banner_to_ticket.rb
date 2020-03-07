class AddBannerToTicket < ActiveRecord::Migration[5.0]
  def change
    add_column :tickets, :banner, :string, comment: '横图 750x440'
    add_column :ticket_ens, :banner, :string, comment: '横图 750x440'
  end
end
