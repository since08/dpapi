require 'rails_helper'

RSpec.describe CurrentRequestCredential, type: :model do
  context "初始化信息到线程中" do
    it "可以全局获取变量内容" do
      CurrentRequestCredential.initialize('localhost', '123', '456', 'uuid', 'def', 'efg')
      expect(CurrentRequestCredential.client_ip).to eq('localhost')
      expect(CurrentRequestCredential.app_key).to eq('123')
      expect(CurrentRequestCredential.access_token).to eq('456')
      expect(CurrentRequestCredential.current_user_id).to eq('uuid')
      expect(CurrentRequestCredential.app_access_token).to eq('def')
      expect(CurrentRequestCredential.user_agent).to eq('efg')
    end
  end
end