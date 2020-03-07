module V10
  module Pay
    class WxNotifyController < ApplicationController
      def create
        res_xml = Hash.from_xml(request.body.read)
        result = res_xml['xml']
        Rails.logger.info "wx notify: #{result}"
        res = Services::Notify::WxNotifyService.call(result)
        render xml: res.to_xml(root: 'xml', dasherize: false)
      end
    end
  end
end

