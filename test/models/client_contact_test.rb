require 'test_helper'

class ClientContactTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test 'client_contact validation' do
    client_company = ClientCompany.create(id: 1, name: "GEDEON RICHTER", address: "103 Boulevard Haussmann, 75008 Paris", client_company_type: "Company", description: "", logo: "https://media.licdn.com/dms/image/C560BAQFH832BPjD...", zipcode: nil, city: nil, reference: "09000657", opco_id: nil, unit_price: nil, auth_token: nil)
    contact = ClientContact.new(name: "Raphaël Hasson", email: "r.hasson@gedeonrichter.fr", title: "DAF", role_description: "", client_company_id: 1, billing_contact: nil, billing_email: nil, billing_address: nil, billing_zipcode: nil, billing_city: nil)
    contact2 = ClientContact.new(name: "Jojo le Rigolo", email: "j.rigolo@gedeonrichter.fr", title: "DAF", role_description: "", client_company_id: 1, billing_contact: nil, billing_email: nil, billing_address: nil, billing_zipcode: nil, billing_city: nil)
    contact.save
    assert contact2.save, 'Validation test failed'
  end
end
