# 文件範本

寫 API 文件、README 或涉及金額的文件時才需要讀這份。

### API 文件中英對照格式

#### 端點文件範本

```markdown
### 建立訂單 / Create Order

#### 基本資訊

- **請求方式 (Method):** POST
- **請求路徑 (Path):** `/api/v1/orders`
- **驗證方式 (Auth):** Bearer Token
- **Content-Type:** application/json

#### 請求參數 (Request Parameters)

| 參數名 (Field) | 類型 (Type) | 必填 (Required) | 說明 (Description) |
|----------------|-------------|-----------------|-------------------|
| product_id | string | 是 | 商品 ID (Product ID) |
| quantity | integer | 是 | 購買數量 (Quantity)，最小值為 1 |
| address_id | string | 是 | 收件地址 ID (Shipping address ID) |
| coupon_code | string | 否 | 折扣碼 (Coupon code) |

#### 請求範例 (Request Example)

\```json
{
  "product_id": "prod_abc123",
  "quantity": 2,
  "address_id": "addr_xyz789",
  "coupon_code": "SUMMER2024"
}
\```

#### 回應參數 (Response Parameters)

| 參數名 (Field) | 類型 (Type) | 說明 (Description) |
|----------------|-------------|-------------------|
| order_id | string | 訂單 ID (Order ID) |
| status | string | 訂單狀態 (Order status): pending / paid / shipped |
| total_amount | integer | 訂單總金額，單位：元（新台幣）(Total amount in NTD) |
| created_at | string | 建立時間 (Created at)，ISO 8601 格式 |

#### 回應範例 (Response Example)

\```json
{
  "code": 0,
  "message": "success",
  "data": {
    "order_id": "ord_20240315001",
    "status": "pending",
    "total_amount": 990,
    "created_at": "2024-03-15T10:30:00+08:00"
  }
}
\```

#### 錯誤碼 (Error Codes)

| 錯誤碼 (Code) | 說明 (Description) | 處理建議 (Suggestion) |
|---------------|--------------------|--------------------|
| 40001 | 商品不存在 (Product not found) | 確認 product_id 是否正確 |
| 40002 | 庫存不足 (Insufficient stock) | 減少購買數量或稍後再試 |
| 40003 | 折扣碼已過期 (Coupon expired) | 移除 coupon_code 或更換折扣碼 |
```

#### 金額表示慣例

台灣常見以「元」為最小單位（不像人民幣有「分」的習慣），請明確標註幣別：

```
# 好：明確說明單位與幣別
total_amount: 990  // 單位：元（新台幣，NT$990）

# 壞：不說明單位，造成歧義
total_amount: 990  // 是台幣還是美金？
```

### README.md 繁中範本

台灣開源專案常用的 README 結構：

```markdown
# 專案名稱

[![License](https://img.shields.io/badge/license-MIT-blue.svg)]()
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)]()

一句話說明這個專案是什麼、解決什麼問題。

### 功能特色

- 特色一：簡要描述
- 特色二：簡要描述
- 特色三：簡要描述

### 快速開始

#### 環境需求

- Node.js >= 20
- MySQL >= 8.0

#### 安裝

\```bash
npm install your-package
\```

#### 基本用法

\```typescript
import { YourPackage } from 'your-package';

const client = new YourPackage({ apiKey: 'your-key' });
const result = await client.doSomething();
\```

### 文件

- [使用指南](./docs/guide.md)
- [API 參考](./docs/api.md)
- [常見問題](./docs/faq.md)
- [更新記錄](./CHANGELOG.md)

### 範例

更多範例請參考 [examples](./examples) 目錄。

### 貢獻指南

歡迎提交 Issue 和 Pull Request。請先閱讀 [貢獻指南](./CONTRIBUTING.md)。

#### 本地開發

\```bash
# Clone 專案
git clone https://github.com/your-org/your-project.git

# 安裝相依套件
npm install

# 啟動開發伺服器
npm run dev

# 執行測試
npm test
\```

### 致謝

- [相依專案一](https://example.com) — 簡要說明
- [相依專案二](https://example.com) — 簡要說明

### 授權

[MIT](./LICENSE)
```
