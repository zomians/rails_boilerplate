require 'rails_helper'

RSpec.describe "signatures/new", type: :view do
  before(:each) do
    assign(:signature, Signature.new(
      name: "MyString",
      address: "MyString",
      message: "MyText"
    ))
  end

  it "renders new signature form" do
    render

    assert_select "form[action=?][method=?]", signatures_path, "post" do

      assert_select "input[name=?]", "signature[name]"

      assert_select "input[name=?]", "signature[address]"

      assert_select "textarea[name=?]", "signature[message]"
    end
  end
end
