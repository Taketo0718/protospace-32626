require 'rails_helper'

RSpec.describe 'プロトタイプ投稿', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @prototype = FactoryBot.create(:prototype)

  end
  context 'プロトタイプ投稿ができるとき'do
    it 'ログインしたユーザーは新規投稿できる' do
      # ログインする
      sign_in(@user)
      # 新規投稿ページへのリンクがあることを確認する
      expect(page).to have_content('New Proto')
      # 投稿ページに移動する
      visit new_prototype_path
      # フォームに情報を入力する
      fill_in 'prototype[title]', with: @prototype.title
      fill_in 'prototype[catch_copy]', with: @prototype.catch_copy
      fill_in 'prototype[concept]', with: @prototype.concept
      # fill_in 'prototype[image]', with: @prototype.image

      # 添付する画像を定義する
      image_path = Rails.root.join('public/images/test_image.png')
      # 画像選択フォームに画像を添付する
      attach_file('prototype[image]', image_path, make_visible: true)
      #送信した値がDBに保存されていることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change { Prototype.count }.by(1)
      # トップページに遷移することを確認する
      expect(current_path).to eq root_path
      # トップページには先ほど投稿した内容のタイトルが存在することを確認する
      expect(page).to have_content(@prototype.title)
      # トップページには先ほど投稿した内容のキャッチコピーが存在することを確認する
      expect(page).to have_content(@prototype.catch_copy)
      # トップページには先ほど投稿した内容のユーザー名が存在することを確認する
      expect(page).to have_content("by #{@prototype.user.name}")
      # 送信した画像がブラウザに表示されていることを確認する
      expect(page).to have_selector("img")
    end
  end
  context 'プロトタイプ投稿ができないとき'do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 新規投稿ページへのリンクがないことを確認する
      expect(page).to have_no_content('New Proto')
    end
  end
end

RSpec.describe 'プロトタイプ詳細の閲覧', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @prototype = FactoryBot.create(:prototype)
  end
  context 'プロトタイプ詳細の閲覧ができるとき' do
    it 'ログインしたユーザーはプロトタイプ詳細の閲覧ができる' do
      # ログインする
      sign_in(@user)
      # 詳細ページへ遷移する
      visit prototype_path(@prototype)
      # ログアウトボタンが表示されることを確認する
      expect(page).to have_content('ログアウト')  
      # NewProtoボタンが表示されることを確認する
      expect(page).to have_content('New Proto') 
      # 編集ボタンが表示されない
      expect(page).to have_no_link '編集', href: edit_prototype_path(@prototype)           
      # 削除ボタンが表示されない
      expect(page).to have_no_link '削除', href: prototype_path(@prototype)
      # 閲覧した内容のタイトルが存在することを確認する
      expect(page).to have_content(@prototype.title)
      # 閲覧した内容のキャッチコピーが存在することを確認する
      expect(page).to have_content(@prototype.catch_copy)
      # 閲覧した内容のユーザー名が存在することを確認する
      expect(page).to have_content("by #{@prototype.user.name}")
      # 閲覧した内容の画像がブラウザに表示されていることを確認する
      expect(page).to have_selector("img")
    end
    it 'ログインしていないユーザーでもプロトタイプ詳細の閲覧ができる' do
      # トップページへ遷移する
      visit root_path
      # 詳細ページへ遷移する
      visit prototype_path(@prototype)
      # ログアウトボタンが表示されないことを確認する
      expect(page).to have_no_content('ログアウト')  
      # NewProtoボタンが表示されないことを確認する
      expect(page).to have_no_content('New Proto') 
      # 編集ボタンが表示される
      expect(page).to have_no_link '編集', href: edit_prototype_path(@prototype)           
      # 削除ボタンが表示される
      expect(page).to have_no_link '削除', href: prototype_path(@prototype)
      # 閲覧した内容のタイトルが存在することを確認する
      expect(page).to have_content(@prototype.title)
      # 閲覧した内容のキャッチコピーが存在することを確認する
      expect(page).to have_content(@prototype.catch_copy)
      # 閲覧した内容のユーザー名が存在することを確認する
      expect(page).to have_content("by #{@prototype.user.name}")
      # 閲覧した内容の画像がブラウザに表示されていることを確認する
      expect(page).to have_selector("img")
    end
  end
end
RSpec.describe 'ユーザー詳細の閲覧', type: :system do
  before do
    @user = FactoryBot.create(:user)
    @prototype = FactoryBot.create(:prototype)
  end
  context 'ユーザー詳細の閲覧ができるとき' do
    it 'ログインしていないユーザーもユーザー詳細の閲覧ができる' do
      # トップページへ遷移する
      visit root_path
      # 詳細ページへ遷移する
      visit prototype_path(@prototype)
      # ユーザーページへ遷移する
      click_on(@prototype.user.name)
      # ユーザー詳細の名前が存在することを確認する
      expect(page).to have_content(@prototype.user.name)
      # ユーザー詳細のプロフィールが存在することを確認する
      expect(page).to have_content(@prototype.user.profile)
      # ユーザー詳細の所属が存在することを確認する
      expect(page).to have_content(@prototype.user.occupation)
      # ユーザー詳細の役職が存在することを確認する
      expect(page).to have_content(@prototype.user.position)
    end
    it 'ログインしたユーザーもユーザー詳細の閲覧ができる' do
      # トップページへ遷移する
      visit root_path
      # ログインする
      sign_in(@user)
      # 詳細ページへ遷移する
      visit prototype_path(@prototype)
      # ユーザーページへ遷移する
      click_on(@prototype.user.name)
      # ユーザー詳細の名前が存在することを確認する
      expect(page).to have_content(@prototype.user.name)
      # ユーザー詳細のプロフィールが存在することを確認する
      expect(page).to have_content(@prototype.user.profile)
      # ユーザー詳細の所属が存在することを確認する
      expect(page).to have_content(@prototype.user.occupation)
      # ユーザー詳細の役職が存在することを確認する
      expect(page).to have_content(@prototype.user.position)
    end
  end
RSpec.describe 'プロトタイプ編集', type: :system do
  before do
    @prototype1 = FactoryBot.create(:prototype)
    @prototype2 = FactoryBot.create(:prototype)
  end
  context 'プロトタイプ編集ができるとき' do
    it 'ログインしたユーザーは自分が投稿したプロトタイプの編集ができる' do
    end
  end
end
