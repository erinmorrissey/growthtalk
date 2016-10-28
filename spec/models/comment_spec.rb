require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'is valid with valid attributes' do
    expect(Comment.new(comment_text: 'test comment')).to be_valid
  end

  it 'is not valid without comment text' do
    comment = Comment.new(comment_text: nil)
    expect(comment).to_not be_valid
  end
end
