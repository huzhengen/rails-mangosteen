require "rails_helper"
require "rspec_api_documentation/dsl"

resource "账目" do
  get "/api/v1/items" do
    parameter :pager, '分页参数', required: false
    parameter :created_after, '创建时间起始', required: false
    parameter :created_before, '创建时间结束', required: false
    with_options :scope => :resource do
      response_field :id, 'ID'
      response_field :amount, '金额(分)'
    end

    let(:created_after) { "2010-01-01" }
    let(:created_before) { "2011-01-01" }

    example "获取账目" do
      11.times do
        Item.create amount: 100, created_at: '2010-01-09'
      end
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json['resources'].size).to eq 10
    end
  end
end
