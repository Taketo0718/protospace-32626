require 'rails_helper'

RSpec.describe Prototype, type: :model do
  before do
    @prototype = FactoryBot.build(:prototype)
  end

  describe 'プロトタイプの保存' do

    context "プロトタイプが保存できる場合" do
      it "タイトル、キャッチコピー、コンセプト、画像があればプロトタイプは保存される" do##
        expect(@prototype).to be_valid
      end
    end

    context "プロトタイプが保存できない場合" do
      it "タイトルがないとプロトタイプは保存できない" do##
        @prototype.title = nil
        @prototype.valid?
        expect(@prototype.errors.full_messages).to include("Title can't be blank")
      end     
      it "キャッチコピーがないとプロトタイプは保存できない" do##
        @prototype.catch_copy = nil
        @prototype.valid?
        expect(@prototype.errors.full_messages).to include("Catch copy can't be blank")
      end     
      it "コンセプトがないとプロトタイプは保存できない" do##
        @prototype.concept = nil
        @prototype.valid?
        expect(@prototype.errors.full_messages).to include("Concept can't be blank")
      end
      it "画像がないとプロトタイプは保存できない" do##
        @prototype.image = nil
        @prototype.valid?
        expect(@prototype.errors.full_messages).to include("Image can't be blank")
      end
      it "ユーザーが紐付いていないとプロトタイプは保存できない" do
        @prototype.user = nil
        @prototype.valid?
        expect(@prototype.errors.full_messages).to include("User must exist")
      end
    end
  end
end
