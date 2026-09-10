# Hexo Blog

## 开新博客

```powershell
cd C:\Users\19542\Desktop\wf\WuFaye.github.io
npm ci
npx hexo new "文章标题"
```

编辑：

```text
source/_posts/文章标题.md
```

## 本地渲染

```powershell
npm run clean
npm run build
npm run preview
```

## 发布

```powershell
git add .
git commit -m "add new blog post"
git push origin main
```
