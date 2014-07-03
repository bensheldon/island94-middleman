require 'spec_helper'

describe 'index', :type => :feature do
  before do
    visit '/'
  end

  it 'has newest articles' do
    expect(page).to have_content 'Newest articles'
  end
end
