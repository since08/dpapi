module Services
  module FilterHelp
    EXACT_ILLEGAL_KEYWORDS_REGEX = /
      东方闪电|轮子功|藏字石|法O功|法0功|李大轮子|高智晟|FL大法|法仑功|大法弟子|车仑大法|
      活体取肾|三唑仑|罂粟籽|氯胺酮|老虎机|代开发票|乙醚|做炸弹|仿真手枪|仿真枪|电狗|气狗|
      电鸡|K粉|冰毒|海洛因|摇头丸|买真枪|蒙汗药|百家乐|liuhecai|3D轮盘|6合|六HE彩|一肖|
      六合彩|国统会|中正纪念歌|中国复兴党|jiangzemin
    /x

    EXACT_SEXY_KEYWORDS_REGEX = /(小姐|红灯|一条街|小妹|少妇|服务|学生妹|出台|特殊联系|全套|包夜|处女)/

    # 以下色情敏感词的敏感程度可以由产品自由规定
    FUZZY_SEXY_KEYWORDS_REGEX = /
      小.{0,1}姐|
      红.{0,2}灯|
      一条街|
      小.{0,2}妹|
      服.{0,2}务|
      学.{0,2}生.{0,2}妹|
      出.{0,2}台|
      特.{0,1}殊.{0,2}联.{0,1}系|
      全.{0,2}套|
      包.{0,2}夜|
      处.{0,2}女
    /x # x模式代表:忽略空格，允许在整个表达式中放入空白符和注释。

    def self.illegal_keyword?(content)
      return true if content.to_json.match(EXACT_ILLEGAL_KEYWORDS_REGEX)
      false
    end

    def self.pornography?(content)
      entity_content = CGI.unescapeHTML(content).delete(' ')

      return true if entity_content.match(EXACT_SEXY_KEYWORDS_REGEX)

      scan_result = entity_content.scan(FUZZY_SEXY_KEYWORDS_REGEX)
      # 只要模糊匹配到两个及以上,则认定为色情内容
      return true if scan_result.size > 1
      false
    end

    def self.illegal?(content)
      illegal_keyword?(content) || pornography?(content)
    end
  end
end
