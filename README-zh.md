# TailwindCSS Emacs 集成

[English](EMACS-LISP-README.md) | 简体中文

## 简介

这是一个为 Emacs 编辑器提供 TailwindCSS 支持的扩展包。它提供了一系列工具和功能，使在 Emacs 中使用 TailwindCSS 更加便捷和高效。

## 功能特性

- ✨ **语法高亮**：为 TailwindCSS 配置文件提供语法高亮支持
- 🔍 **类名验证**：验证 HTML/JSX 文件中的 TailwindCSS 类名
- 📝 **自动补全**：提供 TailwindCSS 工具类的自动补全功能
- 🔨 **CLI 集成**：直接在 Emacs 中调用 TailwindCSS CLI 工具
- 📦 **类名排序**：按照 TailwindCSS 推荐的顺序对类名进行排序
- 🎯 **快速导航**：快速打开和编辑 TailwindCSS 配置文件

## 安装

### 方法一：手动安装

1. 下载 `tailwindcss.el` 文件
2. 将文件放置在你的 Emacs 加载路径中
3. 在你的 Emacs 配置文件（`~/.emacs` 或 `~/.emacs.d/init.el`）中添加：

```emacs-lisp
(add-to-list 'load-path "/path/to/tailwindcss")
(require 'tailwindcss)
```

### 方法二：使用 use-package

如果你使用 `use-package`，可以这样配置：

```emacs-lisp
(use-package tailwindcss
  :load-path "/path/to/tailwindcss"
  :hook ((html-mode . tailwindcss-mode)
         (web-mode . tailwindcss-mode)
         (js-mode . tailwindcss-mode)
         (typescript-mode . tailwindcss-mode))
  :config
  (setq tailwindcss-enable-class-completion t))
```

### 方法三：使用 straight.el

```emacs-lisp
(straight-use-package
 '(tailwindcss :type git :host github :repo "Kinneyzhang/tailwindcss"
               :files ("tailwindcss.el")))
```

## 基本使用

### 启用 TailwindCSS 模式

在支持的文件类型（HTML、JSX、Vue 等）中启用 `tailwindcss-mode`：

```emacs-lisp
M-x tailwindcss-mode
```

或者在配置文件中自动启用：

```emacs-lisp
(add-hook 'html-mode-hook #'tailwindcss-mode)
(add-hook 'web-mode-hook #'tailwindcss-mode)
```

### 主要命令

#### 1. 初始化 TailwindCSS 项目

```
M-x tailwindcss-init
```

在当前项目中初始化 TailwindCSS 配置。

#### 2. 构建 TailwindCSS

```
M-x tailwindcss-build
```

使用 TailwindCSS CLI 构建 CSS 文件。

#### 3. 列出当前缓冲区的类名

```
M-x tailwindcss-list-classes
```

显示当前文件中所有使用的 TailwindCSS 类名。

#### 4. 验证类名

```
M-x tailwindcss-validate-buffer
```

检查当前缓冲区中的所有 TailwindCSS 类名是否有效。

#### 5. 排序类名

选中一段包含 TailwindCSS 类名的区域，然后：

```
M-x tailwindcss-sort-classes-in-region
```

类名将按照 TailwindCSS 推荐的顺序重新排序。

#### 6. 打开配置文件

```
M-x tailwindcss-open-config
```

快速打开项目中的 TailwindCSS 配置文件。

#### 7. 插入工具类

```
M-x tailwindcss-insert-utility-class
```

从预定义的工具类列表中选择并插入一个类名。

## 配置选项

### 自定义变量

你可以通过设置以下变量来自定义 TailwindCSS 集成的行为：

```emacs-lisp
;; 配置文件名称（默认：tailwind.config.js）
(setq tailwindcss-config-file "tailwind.config.js")

;; TailwindCSS CLI 路径（默认：npx tailwindcss）
(setq tailwindcss-cli-path "npx tailwindcss")

;; 启用类名自动补全（默认：t）
(setq tailwindcss-enable-class-completion t)

;; Preflight CSS 文件路径
(setq tailwindcss-preflight-css-path "preflight.css")
```

### 键绑定建议

你可以为常用命令设置快捷键：

```emacs-lisp
(define-key tailwindcss-mode-map (kbd "C-c t b") 'tailwindcss-build)
(define-key tailwindcss-mode-map (kbd "C-c t l") 'tailwindcss-list-classes)
(define-key tailwindcss-mode-map (kbd "C-c t v") 'tailwindcss-validate-buffer)
(define-key tailwindcss-mode-map (kbd "C-c t s") 'tailwindcss-sort-classes-in-region)
(define-key tailwindcss-mode-map (kbd "C-c t o") 'tailwindcss-open-config)
(define-key tailwindcss-mode-map (kbd "C-c t i") 'tailwindcss-insert-utility-class)
```

## 高级功能

### 类名解析

`tailwindcss.el` 提供了强大的类名解析功能：

```emacs-lisp
;; 解析类名
(tailwindcss-parse-class-name "hover:bg-blue-500")
;; => (:variants ("hover") :utility "bg-blue-500")

;; 验证类名
(tailwindcss-validate-class-name "hover:bg-blue-500")
;; => t

;; 提取缓冲区中的所有类名
(tailwindcss-extract-classes-from-buffer)
;; => ("flex" "items-center" "justify-between" "bg-white" ...)
```

### 类名排序

类名排序功能会按照以下顺序组织类名：

1. 布局（Layout）
2. Flexbox
3. Grid
4. 间距（Spacing）
5. 尺寸（Sizing）
6. 排版（Typography）
7. 背景（Backgrounds）
8. 边框（Borders）
9. 效果（Effects）
10. 滤镜（Filters）
11. 表格（Tables）
12. 过渡（Transitions）
13. 变换（Transforms）
14. 交互（Interactivity）
15. SVG
16. 可访问性（Accessibility）

### 配置文件模式

`tailwindcss.el` 为 TailwindCSS 配置文件提供了专门的主模式：

- 自动语法高亮
- 关键字识别
- 智能注释

配置文件会自动使用 `tailwindcss-config-mode`：
- `tailwind.config.js`
- `tailwind.config.ts`

## 与其他包集成

### Company 模式

如果你使用 `company-mode` 进行代码补全：

```emacs-lisp
(use-package company
  :ensure t
  :hook (tailwindcss-mode . company-mode))
```

### LSP 模式

与 `lsp-mode` 和 `lsp-tailwindcss` 配合使用：

```emacs-lisp
(use-package lsp-mode
  :ensure t
  :hook ((html-mode . lsp)
         (web-mode . lsp)
         (js-mode . lsp))
  :config
  (setq lsp-tailwindcss-add-on-mode t))
```

### Web 模式

在 `web-mode` 中使用：

```emacs-lisp
(use-package web-mode
  :ensure t
  :mode "\\.html\\'"
  :hook (web-mode . tailwindcss-mode))
```

## 开发指南

### 项目结构

```
tailwindcss/
├── tailwindcss.el          # 主要实现文件
├── README-zh.md            # 中文文档
├── EMACS-LISP-README.md    # 英文文档
└── tests/
    └── tailwindcss-test.el # 测试文件
```

### 扩展功能

你可以通过以下方式扩展 `tailwindcss.el`：

#### 添加自定义工具类

```emacs-lisp
(setq tailwindcss-utilities-list
      (append tailwindcss-utilities-list
              '("my-custom-class" "another-custom-class")))
```

#### 添加自定义颜色

```emacs-lisp
(setq tailwindcss-colors-list
      (append tailwindcss-colors-list
              '("brand-primary" "brand-secondary")))
```

#### 自定义验证规则

你可以覆盖 `tailwindcss-validate-class-name` 函数来实现自定义验证逻辑：

```emacs-lisp
(defun my-tailwindcss-validate (class-name)
  "自定义 TailwindCSS 类名验证。"
  (or (tailwindcss-validate-class-name class-name)
      ;; 添加你的自定义验证逻辑
      (string-match-p "^custom-" class-name)))
```

### 编写测试

使用 ERT（Emacs Lisp Regression Testing）编写测试：

```emacs-lisp
(require 'ert)
(require 'tailwindcss)

(ert-deftest test-tailwindcss-parse-class-name ()
  "测试类名解析功能。"
  (let ((result (tailwindcss-parse-class-name "hover:bg-blue-500")))
    (should (equal (plist-get result :variants) '("hover")))
    (should (equal (plist-get result :utility) "bg-blue-500"))))
```

运行测试：

```
M-x ert RET t RET
```

### 贡献指南

欢迎贡献代码！请遵循以下步骤：

1. Fork 本仓库
2. 创建你的特性分支（`git checkout -b feature/amazing-feature`）
3. 提交你的更改（`git commit -m 'Add some amazing feature'`）
4. 推送到分支（`git push origin feature/amazing-feature`）
5. 开启一个 Pull Request

#### 代码规范

- 使用 `lexical-binding: t`
- 遵循 Emacs Lisp 编码约定
- 为公共函数添加文档字符串
- 使用 `;;;###autoload` 标记自动加载的函数
- 保持代码简洁和可读性

## 故障排除

### 自动补全不工作

确保 `tailwindcss-enable-class-completion` 设置为 `t`：

```emacs-lisp
(setq tailwindcss-enable-class-completion t)
```

并且已启用 `tailwindcss-mode`：

```
M-x tailwindcss-mode
```

### 找不到配置文件

确保你的项目根目录包含 `tailwind.config.js` 或 `tailwind.config.ts` 文件。

你也可以自定义配置文件名：

```emacs-lisp
(setq tailwindcss-config-file "my-tailwind.config.js")
```

### CLI 命令失败

检查 `tailwindcss-cli-path` 设置是否正确：

```emacs-lisp
(setq tailwindcss-cli-path "npx tailwindcss")
```

或者使用完整路径：

```emacs-lisp
(setq tailwindcss-cli-path "/usr/local/bin/tailwindcss")
```

## 示例配置

以下是一个完整的 Emacs 配置示例：

```emacs-lisp
;; 加载 TailwindCSS 支持
(use-package tailwindcss
  :load-path "~/.emacs.d/lisp/tailwindcss"
  :hook ((html-mode . tailwindcss-mode)
         (web-mode . tailwindcss-mode)
         (js-mode . tailwindcss-mode)
         (typescript-mode . tailwindcss-mode)
         (vue-mode . tailwindcss-mode))
  :config
  ;; 配置选项
  (setq tailwindcss-enable-class-completion t)
  (setq tailwindcss-cli-path "npx tailwindcss")
  
  ;; 键绑定
  (define-key tailwindcss-mode-map (kbd "C-c t b") 'tailwindcss-build)
  (define-key tailwindcss-mode-map (kbd "C-c t l") 'tailwindcss-list-classes)
  (define-key tailwindcss-mode-map (kbd "C-c t v") 'tailwindcss-validate-buffer)
  (define-key tailwindcss-mode-map (kbd "C-c t s") 'tailwindcss-sort-classes-in-region)
  (define-key tailwindcss-mode-map (kbd "C-c t o") 'tailwindcss-open-config)
  (define-key tailwindcss-mode-map (kbd "C-c t i") 'tailwindcss-insert-utility-class))

;; 与 Company 集成
(use-package company
  :ensure t
  :hook (tailwindcss-mode . company-mode)
  :config
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.1))

;; 与 LSP 集成（可选）
(use-package lsp-mode
  :ensure t
  :hook ((html-mode . lsp)
         (web-mode . lsp))
  :commands lsp)
```

## 性能优化

对于大型项目，你可能需要调整一些设置以提高性能：

```emacs-lisp
;; 禁用某些缓冲区的实时验证
(setq tailwindcss-auto-validate nil)

;; 增加补全延迟
(setq company-idle-delay 0.3)

;; 限制补全候选数量
(setq company-minimum-prefix-length 3)
```

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](LICENSE) 文件。

## 致谢

- TailwindCSS 团队提供了优秀的 CSS 框架
- Emacs 社区的持续支持和贡献

## 相关链接

- [TailwindCSS 官方网站](https://tailwindcss.com)
- [TailwindCSS GitHub](https://github.com/tailwindlabs/tailwindcss)
- [Emacs Wiki](https://www.emacswiki.org)
- [GNU Emacs](https://www.gnu.org/software/emacs/)

## 版本历史

### v4.1.16（当前版本）

- 初始版本发布
- 支持 TailwindCSS v4.x
- 提供基本的类名补全和验证功能
- 集成 TailwindCSS CLI 工具
- 支持配置文件语法高亮

## 反馈与支持

如果你遇到任何问题或有任何建议，请：

- 在 GitHub 上提交 [Issue](https://github.com/Kinneyzhang/tailwindcss/issues)
- 发送邮件至项目维护者
- 参与 [GitHub Discussions](https://github.com/Kinneyzhang/tailwindcss/discussions)

感谢使用 TailwindCSS Emacs 集成！
