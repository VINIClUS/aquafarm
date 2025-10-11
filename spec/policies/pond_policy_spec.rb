# spec/policies/pond_policy_spec.rb
require "rails_helper"

RSpec.describe PondPolicy do
  let(:owner) { create(:user) }
  let(:other) { create(:user) }
  let(:farm)  { create(:farm, user: owner) }
  let(:pond)  { create(:pond, farm:) }

  it "permite o dono ver/editar" do
    policy = described_class.new(owner, pond)
    expect(policy.show?).to be true
    expect(policy.update?).to be true
  end

  it "nega para não-dono" do
    policy = described_class.new(other, pond)
    expect(policy.show?).to be false
    expect(policy.update?).to be false
  end

  it "escopo limita aos ponds do usuário" do
    other_farm = create(:farm, user: other)
    other_pond = create(:pond, farm: other_farm)
    scope = Pundit.policy_scope!(owner, Pond)
    expect(scope).to include(pond)
    expect(scope).not_to include(other_pond)
  end
end
