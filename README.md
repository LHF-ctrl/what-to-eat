# 今天吃什么？

一个基于 Supabase 的随机菜品推荐应用，帮助你解决"今天吃什么"的选择困难症。

## 功能特性

- 随机推荐菜品，支持忌口过滤
- 时段智能推荐（早餐/午餐/下午茶/晚餐/夜宵）
- 点赞/不喜欢反馈机制
- 数据统计面板
- 深色主题界面

## 技术栈

- 前端：原生 HTML/CSS/JavaScript
- 数据库：Supabase (PostgreSQL)
- 部署：EdgeOne

## 本地运行

直接在浏览器中打开 `index.html` 文件即可。

## 配置说明

如需连接自己的 Supabase 数据库，请修改 `index.html` 中的以下配置：

```javascript
const SUPABASE_URL = '你的 Supabase 项目 URL';
const SUPABASE_KEY = '你的 Supabase anon key';
```

## 数据库表结构

详见 `supabase-schema.sql` 文件。

## License

MIT
