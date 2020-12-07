require 'rails_helper'
describe User do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '新規登録がうまくいかないとき' do
      it "emailが空では登録できない" do##
        @user.email = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Email can't be blank")
      end
      it "重複したemailが存在する場合登録できない" do##
        @user.save
        another_user = FactoryBot.build(:user)
        another_user.email = @user.email
        another_user.valid?
        expect(another_user.errors.full_messages).to include("Email has already been taken")
      end
      it "emailが@なしでは登録できない" do##
        @user.email = @user.email.gsub("@","")
        @user.valid?
        expect(@user.errors.full_messages).to include("Email is invalid")
      end
      it "passwordが空では登録できない" do##
        @user.password = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Password can't be blank")      
      end
      it "passwordが5文字以下であれば登録できない" do##
        @user.password = "00000"
        @user.password_confirmation = "00000"
        @user.valid?
        expect(@user.errors.full_messages).to include("Password is too short (minimum is 6 characters)")
      end
      it "passwordが存在してもpassword_confirmationが空では登録できない" do##
        @user.password_confirmation = ""
        @user.valid?
        expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")      
      end
      it "nameが空だと登録できない" do##
        @user.name = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Name can't be blank")
      end
      it "profileが空だと登録できない" do##
        @user.profile = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Profile can't be blank")
      end
      it "occupationが空だと登録できない" do##
        @user.occupation = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Occupation can't be blank")
      end
      it "positionが空だと登録できない" do##
        @user.position = nil
        @user.valid?
        expect(@user.errors.full_messages).to include("Position can't be blank")
      end
    end
    context '新規登録がうまくいくとき' do
      it "nameとemail、passwordとpassword_confirmation、
          profileとoccupationとpositionが存在すれば登録できる" do##
        expect(@user).to be_valid
      end
    end
  end
end