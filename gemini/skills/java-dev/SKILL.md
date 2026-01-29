---
name: java-dev
description: Java開発に関するガイドライン。Javaのコードを書く際やテストを実行する際に使用する。
---

# Java開発ガイドライン

## Test

### テストフレームワーク

JUnit5を使用する。

### テスト作成方針

- ケースが多い場合などはParameterized Testを使用する

### テスト実行して検証する場合

以下のように最小限のテストケースを実行するようにする。

```bash
# sut-mvn-moduleモジュールのXXXTestクラスのyyyTestMethodメソッドを実行する
mvn test -pl sut-mvn-module -Dtest=XXXTest#yyyTestMethod
```

全単体テストを実行したい場合は以下で良い

```bash
mvn clean install
```

