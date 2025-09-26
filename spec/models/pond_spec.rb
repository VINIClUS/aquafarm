require 'rails_helper'

RSpec.describe Pond, type: :model do
  it 'is valid with valid attributes' do
    farm = Farm.create!(name: 'Test', subdomain: 'test')
    ActsAsTenant.current_tenant = farm
    pond = Pond.new(name: 'A', volume: 100, farm: farm)
    expect(pond).to be_valid
  end
end
