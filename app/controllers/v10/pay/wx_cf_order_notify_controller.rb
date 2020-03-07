module V10
  module Pay
    class WxCfOrderNotifyController < ApplicationController
      def create
        params_xml = Hash.from_xml(request.body.read)
        api_result = Services::Notify::WxCfNotifyNotifyService.call(params_xml['xml'])
        render xml: xml_result(api_result)
      end

      def result_to_xml(code, msg)
        {
          return_code: code,
          return_msg: msg
        }.to_xml(root: 'xml', dasherize: false)
      end

      def xml_result(api_result)
        return result_to_xml('FAIL', api_result.msg) if api_result.failure?

        result_to_xml('SUCCESS', 'OK')
      end
    end
  end
end

