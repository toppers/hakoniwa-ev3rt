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
- [アプリ新規追加手順](#アプリ新規追加手順)
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

必要なソフトのインストール：

```
bash install.bash prepare
```

箱庭のインストール：

```
bash install.bash hakoniwa
```

箱庭コンダクタのインストール：

```
bash install.bash conductor
```

Athrillのインストール：

```
bash install.bash athrill
```


Athrill Device のインストール：

```
bash install.bash athrill_device
```


成功するとこうなります。

```sh
 ls -l /usr/local/lib/hakoniwa/
total 4532
drwxr-xr-x 3 root  root     4096 Jan 27 11:19 hako_binary
-rwxr-xr-x 1 root  root   726176 Jan 27 11:19 hakoc.so
-rwxr-xr-x 1 root  root  1716536 Jan 27 11:19 libhakoarun.a
-rwxr-xr-x 1 root  root   729800 Jan 27 11:41 libhakopdu.so
-rwxr-xr-x 1 root  root   717208 Jan 27 11:41 libhakotime.so
-rwxr-xr-x 1 root  root   726176 Jan 27 11:19 libshakoc.so
drwxrwxrwx 3 tmori tmori    4096 Jan 27 10:27 py
```

```sh
 ls -l /usr/local/bin/hakoniwa/
total 134084
-rwxr-xr-x 1 root root   7464776 Jan 27 11:35 athrill2
-rwxr-xr-x 1 root root       194 Jan 27 11:30 hako-cleanup
-rwxr-xr-x 1 root root    427016 Jan 27 11:19 hako-cmd
-rwxr-xr-x 1 root root       297 Jan 27 11:30 hako-master
-rwxr-xr-x 1 root root 128329896 Jan 27 11:30 hako-master-rust
-rwxr-xr-x 1 root root   1062680 Jan 27 11:19 hako-proxy
```

# アプリ新規追加手順

以下の手順でEV3RT用のアプリケーションを追加します。

1. `workspace/dev/src`配下に、アプリケーションフォルダを作成する
2.  アプリケーションフォルダ内に自分のプログラムとMakefile類を配置する（EV3RTの流儀に従ってください）
3. `workspace/dev/template` 配下のAthrillのパラメータファイルを自分のアプリケーションフォルダにコピー配置して、一部修正する
4.  `workspace/run/asset_def.txt`を自分のアプリケーション名に変更する

以下、アプリケーション名を `HakoniwaApp`、制御対象ロボット名を `HakoniwaRobo` として説明します。

## `workspace/dev/src`配下に、アプリケーションフォルダを作成する

```
mkdir workspace/dev/src/HakoniwaApp
```

## アプリケーションフォルダ内に自分のプログラムとMakefile類を配置する

自分のアプリを配置して、EV3RTの流儀に従って、Makefileなどをそろえてください。

## `workspace/dev/template` 配下のAthrillのパラメータファイルを自分のアプリケーションフォルダにコピー配置して、一部修正する

```
cp workspace/dev/template/* workspace/dev/src/HakoniwaApp/
```

以下のファイルを修正してください。


### proxy_config.json

修正前：asset_nameとrobo_nameを自分の名前に変更します。
```
    "asset_name": "athrill-appname-1",
    "robo_name": "Roboname",
```

修正後：
```
    "asset_name": "athrill-HakoniwaApp-1",
    "robo_name": "HakoniwaRobo",
```

### device_config.txt


修正前：asset_nameとrobo_nameを自分の名前に変更します。
```
DEBUG_FUNC_HAKO_ASSET_NAME      athrill-appname-1
DEBUG_FUNC_HAKO_ROBO_NAME       Roboname
```

修正後：
```
DEBUG_FUNC_HAKO_ASSET_NAME      athrill-HakoniwaApp-1
DEBUG_FUNC_HAKO_ROBO_NAME       HakoniwaRobo
```

# ビルド手順

# シミュレーション手順
