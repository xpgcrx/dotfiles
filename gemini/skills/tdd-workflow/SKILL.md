---
name: tdd-workflow
description: 新機能の開発、バグ修正、またはリファクタリング時に使用します。ユニット、インテグレーション、E2Eテストを含め、80%以上のカバレッジを維持するテスト駆動開発を強制します。
---

# テスト駆動開発 (TDD) ワークフロー

このガイドラインは、TDD原則に基づいた包括的なテストカバレッジを確保するためのものです。
Javaを例に説明していますが他の言語でも考え方は同じです。

## アクティベーション・タイミング

- 新機能やロジックの実装時
- バグ修正や不具合の改修時
- 既存コードのリファクタリング時
- APIエンドポイントの新規作成時
- サービスやコンポーネントの新規作成時

## コア・プリンシパル（主要原則）

### 1. 実装の前にテストを書く (Tests BEFORE Code)

**常に**テストを先に書き、そのテストをパスさせるために最小限のコードを実装してください。

### 2. カバレッジ要件

- 最低 **80%以上** のカバレッジ（Unit + Integration + E2E）
- すべてのエッジケースを網羅
- 異常系・エラーシナリオのテスト
- 境界値の検証

### 3. テストの種類

#### ユニットテスト (Unit Tests)

- 個別のメソッドやユーティリティの検証
- DB接続のような外部依存を排除したテスト

#### 統合テスト (Integration Tests)

- TBD

#### E2Eテスト (E2E Tests)

- TBD

---

## TDD ワークフローステップ

### ステップ 1: ユーザージャーニーの記述

```text
[役割] として、[アクション] したい。それによって [利益] を得られる。

例:
ユーザーとして、セマンティックな市場検索を行いたい。
それによって、正確なキーワードが分からなくても関連する市場を見つけたい。

```

### ステップ 2: テストケースの生成

JUnit 5 を使用してテストケースを作成します。

- 以下のユニットテストパターンの項目をよく読んで参考にすること

```java
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import static org.junit.jupiter.api.Assertions.*;

class SemanticSearchTest {

    @Test
    @DisplayName("検索クエリに対して関連する市場を返すこと")
    void shouldReturnRelevantMarketsForQuery() {
        // テスト実装
    }

    @Test
    @DisplayName("空のクエリを適切に処理すること")
    void shouldHandleEmptyQueryGracefully() {
        // エッジケースのテスト
    }
}

```

### ステップ 3: 当該テストだけ実行 (失敗することを確認)

特定のテストクラス、または特定のメソッドのみを実行して、実装前に正しく失敗することを確認します。

```bash
# 特定のテストクラスのみ実行する場合
mvn test -Dtest=SemanticSearchTest

# 特定のメソッドのみ実行する場合
mvn test -Dtest=SemanticSearchTest#shouldReturnRelevantMarketsForQuery

```

### ステップ 4: コードの実装

テストをパスさせるための最小限のコードを書きます。

### ステップ 5: 再度テストを実行

```bash
mvn test -Dtest=SemanticSearchTest
# すべてのテストがパス（Green）することを確認

```

### ステップ 6: リファクタリング

テストがパスした状態を維持しながら、コードの品質を向上させます。

### ステップ 7: カバレッジの確認

IntelliJ IDEA を使用している場合、ツールバーからカバレッジを確認できます。

- **IntelliJ GUI**: テストクラスまたはメソッドを右クリックし、**「Run '...' with Coverage」** を選択します。
- **コマンドライン (JaCoCo)**:

```bash
mvn jacoco:report
# target/site/jacoco/index.html にレポートが生成されます

```

---

## テストパターン

### ユニットテスト・パターン(JUnit)

#### ParameterizedTestの使用

複数の入力値に対して同じロジックを効率的にテストする場合に使用します。

```java
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ValueSource;
import static org.junit.jupiter.api.Assertions.*;

class ValidationUtilsTest {

    @ParameterizedTest
    @ValueSource(strings = {"", "  ", "\t"})
    void isBlank_ShouldReturnTrueForEmptyOrWhitespace(String input) {
        assertTrue(ValidationUtils.isBlank(input));
    }

    @ParameterizedTest
    @CsvSource({
        "1, 2, 3",
        "10, 5, 15",
        "-1, 1, 0"
    })
    void add_ShouldReturnCorrectSum(int first, int second, int expected) {
        CalculatorService service = new CalculatorService();
        assertEquals(expected, service.add(first, second));
    }
}

```

#### 共通のセットアップ（BeforeEach）

テストクラス内で共通して必要なオブジェクトの初期化や状態の設定には `@BeforeEach` を使用します。
これにより、各テストメソッドの独立性を保ちつつ、重複したセットアップコードを排除できます。

```java
import org.junit.jupiter.api.BeforeEach;

class OrderServiceTest {
    private OrderService service;
    private OrderRepository repository;

    @BeforeEach
    void setUp() {
        // 各テストメソッドの実行前に呼ばれる
        repository = new InMemoryOrderRepository();
        service = new OrderService(repository);
    }

    @Test
    void shouldCreateOrder() {
        // serviceを使ったテスト
    }
}
```

#### 振る舞いの検証（実装の詳細をテストしない）

テストは「何をするか（振る舞い）」を検証すべきであり、
「どのように実現しているか（実装の詳細）」に依存すべきではありません。
基本的には public メソッド（公開 API）を介してテストを行い、
内部の private メソッドやフィールドを直接操作したり検証したりすることは避けます。
これにより、内部実装をリファクタリングしてもテストが壊れにくくなります。

```java
// ✅ 正解: 公開された振る舞いを検証する
@Test
void calculateTotal_ShouldApplyDiscount() {
    Order order = new Order(100);
    double total = service.calculateTotal(order);
    assertEquals(90, total); // 10%割引が適用された「結果」を検証
}

// ❌ 避けるべき: 内部実装（privateフィールドや特定のアルゴリズム）を検証する
// assertEquals(0.1, service.discountRate);
```

#### テストのグループ化 (@Nested)

関連するテストケース（例えば、同じメソッドに対するテストや、特定の状態におけるテスト群）を
`@Nested` を使用して内部クラスとしてグループ化します。
これにより、テストの構造が階層化され、可読性が向上します。

```java
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;

@DisplayName("CustomerService のテスト")
class CustomerServiceTest {

    @Nested
    @DisplayName("register メソッド")
    class Register {

        @Test
        @DisplayName("有効な入力の場合、顧客が登録されること")
        void shouldRegisterCustomerWithValidInput() {
             // ...
        }

        @Test
        @DisplayName("メールアドレスが重複している場合、例外をスローすること")
        void shouldThrowExceptionWhenEmailDuplicate() {
             // ...
        }
    }
}
```

#### 自然言語によるテスト説明 (@DisplayName)

テストメソッド名だけで意図を伝えるのが難しい場合や、
レポートを見やすくするために `@DisplayName` を使用して自然言語（日本語など）でテストケースを説明します。
メソッド名は `shouldReturn...` や `given...When...Then...` のような英語の規約に従いつつ、 `@DisplayName` で詳細を補足します。

```java
@Test
@DisplayName("在庫が不足している場合、OrderException をスローすること")
void throwExceptionWhenOutOfStock() {
    // ...
}
```

### 統合テスト・パターン (Integration Tests)

- TBD

### E2E テスト・パターン (E2E Tests)

- TBD

---

## モック化の方針 (Mocking Policy)

プロジェクト方針が異なる場合を除き、古典派（Classical School） のアプローチを重視します。
モック（Mockito等）の使用は以下のケースに限定し、
内部のドメインロジック同士の結合には実オブジェクトを使用してください。
（実オブジェクトの組み合わせだとあまりに煩雑になるケースや、
モックを使用している既存コードに合わせたほうが良いと考えられるケースについては都度検討はOK）

### モック化するケース（システム境界）

1. 外部依存: データベース（Repository）、外部APIクライアント、ファイルシステム。
2. アダプター: 外部システムと接続するためのインターフェース実装。
3. 不安定な要素: 現在時刻（java.time.Clock）、乱数など。

### モック例（Repository と時刻のモック）

```java
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MarketServiceTest {
    @Mock
    private MarketRepository repository; // DB境界はモック

    @Mock
    private Clock clock; // 時刻は制御のためにモック

    @Test
    void saveMarket_ShouldSetCreationDate() {
        // 時刻の固定
        Instant fixedInstant = Instant.parse("2026-01-29T10:00:00Z");
        when(clock.instant()).thenReturn(fixedInstant);
        when(clock.getZone()).thenReturn(ZoneId.of("UTC"));

        // 実行と検証...
    }
}
```

---

## 避けるべき一般的なミス

### ❌ 誤り: 内部ロジックをすべてモックにする

ロンドン学派的な「すべての依存関係をモックにする」手法は、
リファクタリング時にテストが壊れやすくなる（brittle tests）ため、
プロジェクトの方針で定められている場合を除き、基本的には避けてください。

### ❌ 誤り: 実装の詳細をテストする

```java
// 内部のプライベート変数の状態を検証（非推奨）
assertEquals(5, service.internalCounter);

```

### ✅ 正解: ユーザーから見える振る舞いをテストする

```java
// 公開されたメソッドの戻り値を検証
assertEquals(5, service.getCount());

```

### ❌ 誤り: テストの隔離ができていない

```java
// テスト間でデータが共有され、実行順序に依存する
@Test void test1_createUser() { ... }
@Test void test2_updateUser() { ... } // test1の結果に依存している

```

### ✅ 正解: 独立したテスト

```java
// 各テストで必要なデータを個別にセットアップする
@BeforeEach
void setUp() {
    repository.deleteAll();
}

```

## 継続的テスト (Continuous Testing)

- TBD

## 成功のメトリクス

- 80%+ コードカバレッジ達成
- すべてのテストが成功（Green）
- スキップされたテストがないこと
- ユニットテストが高速に実行されること（1テストあたり 50ms 未満）
- クリティカルなユーザーフローがテストで保護されていること

---

**忘れないでください**: テストはオプションではありません。自信を持ったリファクタリング、迅速な開発、そして本番環境の信頼性を支えるための「命綱」です。

---

**次へのステップ**:
ユーザ様が TBD とした「統合テスト（例：Spring Boot Test）」や「継続的テスト（例：GitHub Actions / Jenkins）」を具体化したい場合は、いつでも具体的な要件をお伝えください。最適な設定方法を提示いたします。
