require 'rails_helper'

RSpec.describe "signatures/edit", type: :view do
  let(:signature) {
    Signature.create!(
      name: "MyString",
      address: "MyString",
      message: "MyText"
    )
  }

  before(:each) do
    assign(:signature, signature)
  end

  it "renders the edit signature form" do
    render

    assert_select "form[action=?][method=?]", signature_path(signature), "post" do

      assert_select "input[name=?]", "signature[name]"

      assert_select "input[name=?]", "signature[address]"

      assert_select "textarea[name=?]", "signature[message]"
    end
  end
end
