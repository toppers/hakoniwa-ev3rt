# hakoniwa-ev3rt

本リポジトリは、箱庭用のEV3RT上で以下を実現します。

* EV3RT用のアプリをビルドする
* ビルドしたバイナリをマイコンシミュレータAthrillで実行する
  * Athrill内のデバイスとUnity上のロボットとの通信します
  * [hakoniwa-unity-ev3model](https://github.com/toppers/hakoniwa-unity-ev3model)のインストールが別途必要です。

# 目次

- [動作環境](#動作環境)
- [アーキテクチャ](#アーキテクチャ)
- [プロジェクト構成](#プロジェクト構成)
- [インストール手順](#プロジェクト構成)
- [ビルド手順](#ビルド手順)
- [シミュレーション手順](#ビルド手順)

# 動作環境

現時点では、以下の環境のみサポートしています。

* Windows11/10 WSL2 Ubuntu 22.04.2 LTS

# アーキテクチャ

## Windows 向け

アーキテクチャは下図のとおり、WSL2上に箱庭直接インストールして実行する構成です。

![image](https://github.com/toppers/hakoniwa-ev3rt/assets/164193/e5786dc6-58b9-4390-87f2-51093c074965)


背景：当初は、Dockerコンテナ内で実行する構成にしていましたが、箱庭の改修がやりづらいケースが多く、直接インストール構成としました。

# プロジェクト構成

プロジェクト構成は下図の通りです。

```
.
├── install.bash
├── docker
└── workspace
    ├── dev
    |   └── src
    |       ├── base_practice_1
    |       ├── block_signal
    |       └── train_slow_stop
    └── run
```

箱庭のインストールは、`install.bash`で行います。

EV3RT用のアプリケーションのビルドは、`docker` 環境で行います。

アプリケーションは、workspace/dev/src 配下に配置します。

デフォルトで、`base_practice_1`, `block_signal`, `train_slow_stop` が配置されていますが、自分のアプリケーションをこの並びで追加できます。

# インストール手順

## Windows 向け

* docker engine のインストール
* 箱庭のインストール


### docker engine のインストール

```
sudo apt  install docker.io
```
```
sudo apt install net-tools
```

インストールが終わったら、docker を起動します。

```
sudo service docker start
```

### 箱庭のインストール

以下の順番でインストールします。



# ビルド手順

# シミュレーション手順
