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
   <img width="40%" alt="アカウント登録" src="https://github.com/user-attachments/assets/f6dfe84a-4bdc-43f1-9b6c-4a8a3282d0f1">

2. ご褒美と目標を登録する。
   <img width="40%" alt="ご褒美と目標の新規登録" src="https://github.com/user-attachments/assets/cbdbc388-d441-41f1-a78e-c2dff7114af0">

3. 進捗率の更新をする。

   - 必要に応じてご褒美や目標の設定を変更することが可能です。
     <img width="40%" alt="ご褒美と目標の詳細画面" src="https://github.com/user-attachments/assets/97dadd39-b744-4032-bc7d-fbd203a875b0">

4. 期日になったら忘れずに自分にご褒美をあげる。

   - 目標の達成・未達成に関わらず自分を褒めてあげましょう！
     <img width="40%" alt="ご褒美と目標の詳細画面-完了" src="https://github.com/user-attachments/assets/a4004bfc-c04e-48cc-bec5-2c0dd35ec934">

5. 友人や家族を招待してご褒美を共有する。
   - 招待URLを共有することで友人や家族を共通のご褒美に招待することができます。
   - 各々の目標を設定し、共通のご褒美に向けて頑張りましょう！
     <img width="40%" alt="ご褒美と目標の詳細画面-招待後" src="https://github.com/user-attachments/assets/050eb7a8-e9fa-4596-814c-ba6aadce6330">
     <img width="40%" alt="ご褒美と目標の詳細画面-招待用画面" src="https://github.com/user-attachments/assets/50bbef80-8b46-440d-95a8-15ad4d2dd46d">

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
