-- 创建菜品表
CREATE TABLE IF NOT EXISTS dishes (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    category VARCHAR(20) NOT NULL CHECK (category IN ('荤菜', '素菜', '汤类', '主食', '甜点')),
    breakfast BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 创建点赞表
CREATE TABLE IF NOT EXISTS dish_likes (
    id BIGSERIAL PRIMARY KEY,
    dish_name VARCHAR(100) NOT NULL REFERENCES dishes(name) ON DELETE CASCADE,
    like_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 创建不喜欢表
CREATE TABLE IF NOT EXISTS dish_dislikes (
    id BIGSERIAL PRIMARY KEY,
    dish_name VARCHAR(100) NOT NULL REFERENCES dishes(name) ON DELETE CASCADE,
    dislike_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc'::text, NOW()) NOT NULL
);

-- 创建索引以提高查询性能
CREATE INDEX IF NOT EXISTS idx_dishes_category ON dishes(category);
CREATE INDEX IF NOT EXISTS idx_dishes_breakfast ON dishes(breakfast);
CREATE INDEX IF NOT EXISTS idx_dish_likes_name ON dish_likes(dish_name);
CREATE INDEX IF NOT EXISTS idx_dish_dislikes_name ON dish_dislikes(dish_name);

-- 插入默认菜品数据
INSERT INTO dishes (name, category, breakfast) VALUES
    ('红烧肉', '荤菜', FALSE),
    ('糖醋排骨', '荤菜', FALSE),
    ('宫保鸡丁', '荤菜', FALSE),
    ('鱼香肉丝', '荤菜', FALSE),
    ('清蒸鲈鱼', '荤菜', FALSE),
    ('麻婆豆腐', '素菜', FALSE),
    ('地三鲜', '素菜', FALSE),
    ('干煸四季豆', '素菜', FALSE),
    ('蒜蓉西兰花', '素菜', FALSE),
    ('番茄炒蛋', '素菜', FALSE),
    ('紫菜蛋花汤', '汤类', FALSE),
    ('冬瓜排骨汤', '汤类', FALSE),
    ('番茄牛腩汤', '汤类', FALSE),
    ('蛋炒饭', '主食', FALSE),
    ('炸酱面', '主食', FALSE),
    ('饺子', '主食', FALSE),
    ('红烧茄子', '素菜', FALSE),
    ('可乐鸡翅', '荤菜', FALSE),
    ('酸辣土豆丝', '素菜', FALSE),
    ('水煮鱼', '荤菜', FALSE),
    ('豆浆油条', '主食', TRUE),
    ('小笼包', '主食', TRUE),
    ('皮蛋瘦肉粥', '主食', TRUE),
    ('煎饼果子', '主食', TRUE),
    ('小米粥', '汤类', TRUE)
ON CONFLICT (name) DO NOTHING;

-- 启用 Row Level Security (RLS)
ALTER TABLE dishes ENABLE ROW LEVEL SECURITY;
ALTER TABLE dish_likes ENABLE ROW LEVEL SECURITY;
ALTER TABLE dish_dislikes ENABLE ROW LEVEL SECURITY;

-- 允许所有用户读取数据
CREATE POLICY "Public read access for dishes" ON dishes FOR SELECT USING (true);
CREATE POLICY "Public read access for dish_likes" ON dish_likes FOR SELECT USING (true);
CREATE POLICY "Public read access for dish_dislikes" ON dish_dislikes FOR SELECT USING (true);

-- 允许所有用户插入数据
CREATE POLICY "Public insert access for dishes" ON dishes FOR INSERT WITH CHECK (true);
CREATE POLICY "Public insert access for dish_likes" ON dish_likes FOR INSERT WITH CHECK (true);
CREATE POLICY "Public insert access for dish_dislikes" ON dish_dislikes FOR INSERT WITH CHECK (true);

-- 允许所有用户更新数据
CREATE POLICY "Public update access for dishes" ON dishes FOR UPDATE USING (true);
CREATE POLICY "Public update access for dish_likes" ON dish_likes FOR UPDATE USING (true);
CREATE POLICY "Public update access for dish_dislikes" ON dish_dislikes FOR UPDATE USING (true);

-- 允许所有用户删除数据
CREATE POLICY "Public delete access for dishes" ON dishes FOR DELETE USING (true);
CREATE POLICY "Public delete access for dish_likes" ON dish_likes FOR DELETE USING (true);
CREATE POLICY "Public delete access for dish_dislikes" ON dish_dislikes FOR DELETE USING (true);
