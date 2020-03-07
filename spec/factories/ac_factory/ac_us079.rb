module AcFactory
  class AcUs079 < AcBase
    def ac_us079
      # 创建栏目4个栏目 其中栏目1下面有2条资讯，一条被置顶

      # 类别1 新闻 下面有3条资讯，其中一条是置顶的
      type_one = FactoryGirl.create(:info_type_with_info, { name: '新闻', level: 0 })
      type_one.infos.first.update(top: true, title: '德州TPT赛事', description: '德州TPT赛事', source_type: 'source', source: '阿峰')
      type_one.infos.second.update(title: '天天德州赛事', source_type: 'author', source: 'lorne', description: '天天德州赛事')
      FactoryGirl.create(:info_type_with_info, { name: '扑克', level: 1 })
      FactoryGirl.create(:info_type_with_info, { name: '行业', level: 2 })
      FactoryGirl.create(:info_type_with_info, { name: '名人', level: 3 })
    end
  end
end
