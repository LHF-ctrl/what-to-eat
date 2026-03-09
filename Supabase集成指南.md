# Supabase 集成使用指南

## 一、数据库表结构

### 1.1 dishes（菜品表）
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGSERIAL | 主键，自增 |
| name | VARCHAR(100) | 菜品名称，唯一 |
| category | VARCHAR(20) | 分类：荤菜/素菜/汤类/主食/甜点 |
| breakfast | BOOLEAN | 是否为早餐专属菜品 |
| created_at | TIMESTAMP | 创建时间 |

### 1.2 dish_likes（点赞表）
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGSERIAL | 主键，自增 |
| dish_name | VARCHAR(100) | 菜品名称，外键关联 dishes 表 |
| like_count | INTEGER | 点赞数 |
| created_at | TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | 更新时间 |

### 1.3 dish_dislikes（不喜欢表）
| 字段 | 类型 | 说明 |
|------|------|------|
| id | BIGSERIAL | 主键，自增 |
| dish_name | VARCHAR(100) | 菜品名称，外键关联 dishes 表 |
| dislike_count | INTEGER | 不喜欢数 |
| created_at | TIMESTAMP | 创建时间 |
| updated_at | TIMESTAMP | 更新时间 |

---

## 二、部署步骤

### 步骤 1：在 Supabase 创建项目
1. 登录 [Supabase Dashboard](https://supabase.com/dashboard)
2. 点击"New Project"创建新项目
3. 输入项目名称（如：今天吃什么）
4. 等待项目创建完成（约 1-2 分钟）

### 步骤 2：执行 SQL 建表
1. 进入项目 Dashboard
2. 点击左侧菜单"SQL Editor"
3. 复制 `supabase-schema.sql` 文件中的所有 SQL 代码
4. 粘贴到 SQL Editor 中
5. 点击"Run"执行 SQL
6. 确认所有表创建成功

### 步骤 3：获取连接信息
1. 点击左侧菜单"Settings"
2. 找到"API"部分
3. 复制以下信息：
   - Project URL
   - anon public key

### 步骤 4：更新前端代码
1. 打开 `今天吃什么-supabase.html` 文件
2. 找到以下两行代码（约第 780-781 行）：
   ```javascript
   const SUPABASE_URL = 'https://hzghqxigvjrhuxgboyir.supabase.co';
   const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
   ```
3. 将 `SUPABASE_URL` 替换为你的 Project URL
4. 将 `SUPABASE_KEY` 替换为你的 anon public key
5. 保存文件

### 步骤 5：测试部署
1. 在浏览器中打开 `今天吃什么-supabase.html`
2. 打开浏览器控制台（F12）
3. 检查是否有错误信息
4. 测试以下功能：
   - 随机推荐
   - 点赞功能
   - 不喜欢功能
   - 添加菜品
   - 删除菜品
   - 数据统计面板

---

## 三、功能说明

### 3.1 数据缓存机制
- 菜品列表：首次加载后缓存到内存
- 点赞数据：首次加载后缓存到内存
- 不喜欢数据：首次加载后缓存到内存
- 数据更新后自动清除缓存，重新加载

### 3.2 异步操作
所有数据库操作都使用 `async/await` 异步处理：
- `getDishes()` - 获取菜品列表
- `saveDish(dish)` - 保存新菜品
- `deleteDishFromDB(dishName)` - 删除菜品
- `getLikes()` - 获取点赞数据
- `saveLike(dishName)` - 保存/更新点赞
- `getDislikes()` - 获取不喜欢数据
- `saveDislike(dishName)` - 保存/更新不喜欢
- `deleteLikeAndDislike(dishName)` - 删除点赞和不喜欢记录

### 3.3 错误处理
所有数据库操作都包含错误处理：
```javascript
const { data, error } = await supabase.from('dishes').select('*');
if (error) {
    console.error('操作失败:', error);
    return [];
}
```

---

## 四、安全配置

### 4.1 Row Level Security (RLS)
已启用 RLS 策略，允许所有用户：
- 读取（SELECT）：所有用户可读
- 插入（INSERT）：所有用户可插入
- 更新（UPDATE）：所有用户可更新
- 删除（DELETE）：所有用户可删除

### 4.2 外键约束
- `dish_likes.dish_name` 关联 `dishes.name`，级联删除
- `dish_dislikes.dish_name` 关联 `dishes.name`，级联删除

删除菜品时自动删除相关的点赞和不喜欢记录。

---

## 五、性能优化

### 5.1 索引优化
已创建以下索引以提高查询性能：
- `idx_dishes_category` - 按分类查询
- `idx_dishes_breakfast` - 按早餐标识查询
- `idx_dish_likes_name` - 按菜品名查询点赞
- `idx_dish_dislikes_name` - 按菜品名查询不喜欢

### 5.2 数据缓存
- 首次加载后缓存到内存变量
- 避免重复查询数据库
- 数据更新后清除缓存

---

## 六、常见问题

### Q1：连接 Supabase 失败
**原因**：URL 或 Key 错误
**解决**：
1. 检查 Project URL 是否正确（以 .supabase.co 结尾）
2. 检查 anon key 是否完整
3. 打开浏览器控制台查看错误信息

### Q2：数据不显示
**原因**：表未创建或 RLS 策略未配置
**解决**：
1. 检查 SQL Editor 中表是否创建成功
2. 检查 RLS 策略是否启用
3. 在 Supabase Dashboard 中查看表数据

### Q3：点赞后数据不更新
**原因**：缓存未清除
**解决**：
1. 刷新页面重新加载数据
2. 检查浏览器控制台是否有错误

### Q4：跨域问题
**说明**：Supabase 默认允许所有域名访问
**解决**：无需额外配置，直接使用即可

---

## 七、后续扩展

### 7.1 用户系统
- 添加用户注册/登录功能
- 每个用户独立的点赞/不喜欢数据
- 支持多用户使用同一应用

### 7.2 历史记录
- 记录每次推荐结果
- 查看今日推荐历史
- 避免短期重复推荐

### 7.3 数据导出
- 导出用户偏好数据为 JSON
- 支持跨设备迁移
- 备份重要数据

---

## 八、技术栈

| 技术 | 版本 | 用途 |
|------|------|------|
| Supabase Client | v2 | 数据库连接和操作 |
| PostgreSQL | - | 关系型数据库 |
| Row Level Security | - | 数据安全策略 |
| JavaScript | ES6+ | 前端逻辑 |

---

## 九、文件说明

| 文件名 | 说明 |
|--------|------|
| supabase-schema.sql | 数据库表结构和初始数据 |
| 今天吃什么-supabase.html | 连接 Supabase 的前端代码 |
| PRD-今天吃什么.md | 产品需求文档 |

---

## 十、联系支持

如遇到问题，请：
1. 查看浏览器控制台错误信息
2. 检查 Supabase Dashboard 日志
3. 参考 Supabase 官方文档：https://supabase.com/docs
