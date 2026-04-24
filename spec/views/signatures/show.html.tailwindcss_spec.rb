require 'rails_helper'

RSpec.describe "signatures/show", type: :view do
  before(:each) do
    assign(:signature, Signature.create!(
      name: "Name",
      address: "Address",
      message: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/MyText/)
  end
end
