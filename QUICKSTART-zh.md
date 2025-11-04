# TailwindCSS Emacs 集成 - 快速入门指南

[English](QUICKSTART.md) | 简体中文

## 5分钟快速设置

### 步骤 1: 安装包

将 `tailwindcss.el` 复制到您的 Emacs 配置目录：

```bash
cd ~/.emacs.d/lisp
git clone https://github.com/Kinneyzhang/tailwindcss.git
```

### 步骤 2: 配置 Emacs

添加到您的 `~/.emacs` 或 `~/.emacs.d/init.el`：

```emacs-lisp
;; 添加到加载路径
(add-to-list 'load-path "~/.emacs.d/lisp/tailwindcss")

;; 加载 TailwindCSS 支持
(require 'tailwindcss)

;; 在 HTML 和 JavaScript 文件中启用
(add-hook 'html-mode-hook 'tailwindcss-mode)
(add-hook 'js-mode-hook 'tailwindcss-mode)
(add-hook 'typescript-mode-hook 'tailwindcss-mode)
```

### 步骤 3: 重启 Emacs 或重新加载配置

```
M-x eval-buffer
```

### 步骤 4: 测试！

打开一个 HTML 文件并尝试：

```
M-x tailwindcss-mode
```

您应该在模式行看到 " TW"。

## 常见使用场景

### 场景 1: 自动补全类名

1. 打开一个 HTML 文件
2. 开始输入类名：`<div class="fl`
3. 按 `M-TAB` 或您的补全键
4. 从可用补全中选择

### 场景 2: 排序类名

1. 选择包含类名的区域：
   ```html
   <div class="text-lg bg-white p-4 flex items-center">
   ```

2. 运行：`M-x tailwindcss-sort-classes-in-region`

3. 类名将被重新排序：
   ```html
   <div class="flex items-center p-4 text-lg bg-white">
   ```

### 场景 3: 验证类名

1. 打开包含 TailwindCSS 类的文件
2. 运行：`M-x tailwindcss-validate-buffer`
3. 查看无效类名列表

### 场景 4: 构建 TailwindCSS

1. 确保项目中已安装 TailwindCSS
2. 运行：`M-x tailwindcss-build`
3. 构建输出将出现在编译缓冲区中

### 场景 5: 快速导航到配置文件

1. 从项目中的任何文件
2. 运行：`M-x tailwindcss-open-config`
3. `tailwind.config.js` 文件将打开

## 键盘快捷键

添加这些到您的配置中以快速访问：

```emacs-lisp
;; 为 TailwindCSS 命令定义前缀键
(global-set-key (kbd "C-c t") nil)  ; 清除任何现有绑定

;; TailwindCSS 命令
(define-key global-map (kbd "C-c t b") 'tailwindcss-build)
(define-key global-map (kbd "C-c t i") 'tailwindcss-init)
(define-key global-map (kbd "C-c t l") 'tailwindcss-list-classes)
(define-key global-map (kbd "C-c t v") 'tailwindcss-validate-buffer)
(define-key global-map (kbd "C-c t s") 'tailwindcss-sort-classes-in-region)
(define-key global-map (kbd "C-c t o") 'tailwindcss-open-config)
(define-key global-map (kbd "C-c t m") 'tailwindcss-mode)
```

现在您可以使用：
- `C-c t b` - 构建 TailwindCSS
- `C-c t i` - 初始化 TailwindCSS
- `C-c t l` - 列出缓冲区中的类
- `C-c t v` - 验证类名
- `C-c t s` - 排序选中的类
- `C-c t o` - 打开配置文件
- `C-c t m` - 切换 TailwindCSS 模式

## 与流行包集成

### 与 Company 模式

```emacs-lisp
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.1)
  (setq company-minimum-prefix-length 1))

;; TailwindCSS 将自动与 company 集成
```

### 与 use-package

```emacs-lisp
(use-package tailwindcss
  :load-path "~/.emacs.d/lisp/tailwindcss"
  :hook ((html-mode . tailwindcss-mode)
         (web-mode . tailwindcss-mode)
         (js-jsx-mode . tailwindcss-mode)
         (typescript-mode . tailwindcss-mode)
         (tsx-ts-mode . tailwindcss-mode))
  :bind (:map tailwindcss-mode-map
              ("C-c C-t b" . tailwindcss-build)
              ("C-c C-t v" . tailwindcss-validate-buffer)
              ("C-c C-t s" . tailwindcss-sort-classes-in-region)))
```

### 与 web-mode

```emacs-lisp
(use-package web-mode
  :ensure t
  :mode ("\\.html\\'" "\\.jsx\\'" "\\.tsx\\'")
  :hook (web-mode . tailwindcss-mode)
  :config
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))
```

### 与 LSP 模式

```emacs-lisp
(use-package lsp-mode
  :ensure t
  :hook ((html-mode . lsp)
         (web-mode . lsp)
         (typescript-mode . lsp))
  :config
  (setq lsp-tailwindcss-add-on-mode t))

;; 同时使用 LSP 和 tailwindcss-mode
(add-hook 'html-mode-hook 'tailwindcss-mode)
```

## 示例工作流程

### 开始新项目

```bash
# 创建新项目
mkdir my-project && cd my-project

# 初始化 npm 和 TailwindCSS
npm init -y
npm install -D tailwindcss

# 在 Emacs 中打开项目
emacs .
```

在 Emacs 中：

```
M-x tailwindcss-init
```

这将创建一个 `tailwind.config.js` 文件。

### 在现有项目上工作

```bash
# 打开您的项目
cd my-existing-project
emacs .
```

在 Emacs 中：

```
# 打开 HTML 文件
C-x C-f index.html

# 启用 TailwindCSS 模式
M-x tailwindcss-mode

# 开始使用补全进行编辑！
```

### 构建生产版本

```
# 构建 TailwindCSS
M-x tailwindcss-build

# 或使用自定义构建命令
M-x compile RET npm run build:css
```

## 自定义示例

### 自定义 CLI 路径

如果 TailwindCSS 是全局安装或在特定位置：

```emacs-lisp
(setq tailwindcss-cli-path "/usr/local/bin/tailwindcss")
```

或如果使用自定义 npm 脚本：

```emacs-lisp
(setq tailwindcss-cli-path "npm run tailwind")
```

### 自定义配置文件名

如果您的配置文件有不同的名称：

```emacs-lisp
(setq tailwindcss-config-file "tailwind.config.ts")
```

### 禁用自动补全

如果您更喜欢手动补全：

```emacs-lisp
(setq tailwindcss-enable-class-completion nil)
```

### 添加自定义类

添加项目特定的类：

```emacs-lisp
(setq tailwindcss-utilities-list
      (append tailwindcss-utilities-list
              '("hero-section" "card-container" "custom-button")))
```

## 故障排除

### 问题：模式未激活

**解决方案：** 确保包已加载：

```emacs-lisp
M-x load-file RET ~/.emacs.d/lisp/tailwindcss/tailwindcss.el RET
M-x tailwindcss-mode RET
```

### 问题：补全不工作

**解决方案：** 检查这些设置：

```emacs-lisp
;; 确保补全已启用
(setq tailwindcss-enable-class-completion t)

;; 验证模式已激活
M-x describe-mode

;; 检查补全函数
M-x describe-variable RET completion-at-point-functions RET
```

### 问题：找不到配置文件

**解决方案：** 验证文件存在且名称匹配：

```emacs-lisp
;; 检查当前目录
M-x pwd

;; 列出文件
M-x dired

;; 尝试手动查找
M-x tailwindcss-find-config-file
```

### 问题：构建命令失败

**解决方案：** 检查 TailwindCSS 安装：

```bash
# 在终端中
npm list tailwindcss

# 或尝试全局安装
npm install -g tailwindcss
```

## 下一步

- 阅读[完整文档](README-zh.md)
- 查看[开发指南](DEVELOPMENT.md)
- 浏览[示例和技巧](examples/README.md)
- 查看 [API 参考](EMACS-LISP-README.md#api-reference)

## 获取帮助

- 查看[故障排除](README-zh.md#故障排除)部分
- 搜索[现有问题](https://github.com/Kinneyzhang/tailwindcss/issues)
- 在[讨论区](https://github.com/Kinneyzhang/tailwindcss/discussions)提问
- 阅读 [TailwindCSS 文档](https://tailwindcss.com/docs)

## 技巧和窍门

### 技巧 1: 与代码片段一起使用

为常见模式创建代码片段：

```emacs-lisp
;; 使用 yasnippet
;; ~/.emacs.d/snippets/html-mode/tw-flex
# name: Flex 容器
# key: twflex
# --
<div class="flex items-center justify-$1">
  $0
</div>
```

### 技巧 2: 项目特定设置

在项目根目录使用 `.dir-locals.el`：

```emacs-lisp
((html-mode . ((tailwindcss-cli-path . "npm run build:css")))
 (js-mode . ((tailwindcss-mode . t))))
```

### 技巧 3: 与多个模式结合

```emacs-lisp
(add-hook 'html-mode-hook
          (lambda ()
            (tailwindcss-mode 1)
            (electric-pair-mode 1)
            (auto-fill-mode 0)))
```

### 技巧 4: 快速类插入

创建一个 hydra 以快速访问：

```emacs-lisp
(defhydra hydra-tailwindcss (:color blue)
  "TailwindCSS"
  ("b" tailwindcss-build "构建")
  ("v" tailwindcss-validate-buffer "验证")
  ("s" tailwindcss-sort-classes-in-region "排序")
  ("l" tailwindcss-list-classes "列表")
  ("o" tailwindcss-open-config "打开配置")
  ("i" tailwindcss-insert-utility-class "插入")
  ("q" nil "退出"))

(global-set-key (kbd "C-c t") 'hydra-tailwindcss/body)
```

## 视频教程

（即将推出 - 关注此空间以获取视频教程！）

## 社区

加入社区：
- 在 [GitHub](https://github.com/Kinneyzhang/tailwindcss) 上给仓库加星
- 分享您的配置和技巧
- 贡献改进
- 在讨论中帮助他人

使用 TailwindCSS 和 Emacs 愉快编码！ 🎨✨
