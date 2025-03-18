# GifTreat

![GifTreatのロゴ](app/assets/images/logo-horizontal.png)

## 概要

GifTreat は自分にご褒美をあげたい人向けの、ご褒美設定サービスです。

## 特徴

- ご褒美の設定、目標の設定、進捗率の入力ができます。
- 個人利用だけでなく、招待機能で友人・家族と共通のご褒美を設定できます。
- 進捗状況を共有し、お互いに応援する機能（いいね！や頑張れ！ボタン）があります。

## URL

- https://giftreat.jp/

## 使い方

1. アカウント登録をする。
<img width="40%" alt="アカウント登録" src="https://github.com/user-attachments/assets/1d69d37d-7a04-4a5c-b9bc-0befc3b7d50f">

2. ご褒美と目標を登録する。
<img width="40%" alt="ご褒美と目標の新規登録" src="https://github.com/user-attachments/assets/26cfaabd-660d-473c-a36f-8d6952610d9f">

3. 進捗率の更新をする。
   - 必要に応じてご褒美や目標の設定を変更することが可能です。
<img width="40%" alt="ご褒美と目標の詳細画面" src="https://github.com/user-attachments/assets/42859c91-76a8-457e-9ca2-6ff7784a8188">

4. 期日になったら忘れずに自分にご褒美をあげる。
   - 目標の達成・未達成に関わらず自分を褒めてあげましょう！
<img width="40%" alt="ご褒美と目標の詳細画面-完了" src="https://github.com/user-attachments/assets/f1b3a9da-82b7-4c4d-814f-bc706847dbac">

5. 友人や家族を招待してご褒美を共有する。
   - 招待URLを共有することで友人や家族を共通のご褒美に招待することができます。
   - 各々の目標を設定し、共通のご褒美に向けて頑張りましょう！
<img width="40%" alt="ご褒美と目標の詳細画面-招待後" src="https://github.com/user-attachments/assets/46bdbb8e-bcf6-48f7-8ea2-712fc3d73b10">
<img width="40%" alt="ご褒美と目標の詳細画面-招待用画面" src="https://github.com/user-attachments/assets/9b6bd828-3c42-41ad-80a5-3e2458374b16">

## 開発環境

- Ruby 3.4.1
- Ruby on Rails 7.2.2.1
- Hotwire
- Bootstrap

## 環境構築

- セットアップ

```
$ git clone https://github.com/SuzukiShuntarou/GifTreat.git
$ cd GifTreat
$ bin/setup
```

- 起動

```
$ bin/dev
```

## Lint / Test

- Lint

```
$ bin/lint
```

- Test

```
$ bundle exec rails test test/
```
