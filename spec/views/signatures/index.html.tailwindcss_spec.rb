require 'rails_helper'

RSpec.describe "signatures/index", type: :view do
  before(:each) do
    assign(:signatures, [
      Signature.create!(
        name: "Name",
        address: "Address",
        message: "MyText"
      ),
      Signature.create!(
        name: "Name",
        address: "Address",
        message: "MyText"
      )
    ])
  end

  it "renders a list of signatures" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Name".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Address".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
