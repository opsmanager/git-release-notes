require 'spec_helper'

describe Git::Release::Notes do
  it 'has a version number' do
    expect(Git::Release::Notes::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
