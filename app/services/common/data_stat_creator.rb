module Services
  module Common
    class DataStatCreator
      def self.create_account_change_stats(user, type)
        user.account_change_stats.create(change_time: Time.current,
                                         account_type: type,
                                         mender: user.nick_name)
      end
    end
  end
end