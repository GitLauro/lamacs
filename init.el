(add-to-list 'load-path "~/Internet/Git/Emacs/xelb")
(add-to-list 'load-path "~/Internet/Git/Emacs/exwm")
(add-to-list 'load-path "~/Internet/Git/Emacs/compat/")
(add-to-list 'load-path "~/Internet/Git/Emacs/emacs-eat/")
(add-to-list 'load-path "~/Internet/Git/Emacs/modaled/")
(add-to-list 'load-path "~/Internet/Git/Emacs/hotfuzz/")

(require 'eat)
(require 'exwm)
(require 'exwm-randr)
(require 'modaled)
(require 'hotfuzz)
(require 'hotfuzz-module)
(require 'emms)
(require 'emms-history)
(require 'emms-playlist-mode)
(require 'emms-player-mpd)
(require 'emms-setup)
(require 'recentf)

(setq exwm-input-global-keys
      `(
	([kp-end] . save-buffers-kill-emacs)
	([f1] . wymux/darken)
	([f2] . wymux/brighten)
	([kp-begin] . other-window)
	([kp-up] . split-window-vertically)
	([kp-home] . split-window-horizontally)
	([kp-left] . delete-window)
	([kp-down] . kill-this-buffer)
	([kp-delete] . wymux/mpv)
	([kp-prior] . mh-rmail)
	([kp-subtract] . gnus)
	([kp-right] . eshell)
	([kp-next] . balance-windows)
	([kp-add] . project-eshell)
	([?\s-e] . emms)
	([?\s-s] . mh-smail)
	([?\s-d] . delete-frame)
	([?\s-m] . wymux/mpv)
	([?\s-u] . ffap)
	([?\s-o] . other-frame)
	([f9] . wymux/yt-dlp)
	([f10] . switch-to-buffer)
	([f11] . wymux/scrot-all)
	([f12] . lauro/firefox)
	([print] . wymux/scrot)
	([kp-multiply] . previous-buffer)
	([kp-divide] . next-buffer)))

(defun lauro/firefox ()
  "Launch Firefox"
  (interactive)
  (start-process "Firefox" "firefox" "firefox"))

(exwm-enable)
(add-hook 'exwm-randr-screen-change-hook
          (lambda ()
            (start-process-shell-command
             "xrandr" nil "xrandr --output DP-3 --rate 165 --mode 3440x1440 --primary --output DP-0 --off")))
(exwm-randr-enable)

(add-hook 'eshell-load-hook 'eat-eshell-mode)
(fringe-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(global-font-lock-mode -1)
(electric-pair-mode 1)

(set-face-attribute 'default nil :family "Berkeley Mono" :height '80)
(set-face-attribute 'variable-pitch nil :family "Berkeley Mono Variable" :height '80)

(defun lauro/light-theme ()
  "Set white background with black text."
  (interactive)
  (set-background-color "white")
  (set-foreground-color "black"))

(defun lauro/dark-theme ()
  "Set black background with white text."
  (interactive)
  (set-background-color "black")
  (set-foreground-color "white"))

(modaled-define-state "normal"
  :lighter "[NOR]"
  :cursor-type 'box)

(defun lauro/delete (&optional arg)
  "kill-region or delete-whole-line"
  (interactive "p")
  (if (use-region-p)
      (kill-region (region-beginning) (region-end))
    (kill-whole-line arg)))

(modaled-define-keys
  :states '("normal")
  :bind
  `(("h" . backward-char)
    ("s" . forward-char)
    ("d" . previous-line)
    ("t" . next-line)
    ("w" . forward-word)
    ("l" . backward-word)
    ("u" . kill-word)
    ("o" . backward-kill-word)
    ("k" . set-mark-command)
    ("_" . move-beginning-of-line)
    (":" . move-end-of-line)
    ("[" . backward-paragraph)
    ("]" . forward-paragraph)
    (" [" . beginning-of-buffer)
    (" ]" . end-of-buffer)
    ("\\" . yank)
    ("\"" . undo)
    ("x" . lauro/delete)
    ("z" . execute-extended-command)
    (";" . isearch-forward)
    (" n" . save-buffer)
    (" x" . find-file)
    (" dh" . recentf-open-files)
    (" hr" . dired-jump)
    (" mo" . eval-buffer)
    (" ma" . eval-defun)
    (" t." . mark-defun)
    (" z" . mark-whole-buffer)
    (" i" . exchange-mark-and-point)
    ("e" . wymux/modaled-to-insert)))

(modaled-define-state "insert"
  :sparse t
  :no-suppress t
  :cursor-type 'bar
  :lighter "[INS]")

(modaled-define-keys
  :states '("insert" "normal")
  :bind
  '(([ESCAPE] . modaled-set-default-state)
    ([escape] . modaled-set-default-state)))

(modaled-define-default-state
  '("insert" wdired-mode eshell-mode eat-eshell-mode compilation-mode
    debugger-mode mh-folder-mode calendar-mode emms-playlist-mode
    git-commit-mode backtrace-mode info-mode help-mode magit-status
    exwm-mode gnus-summary-mode gnus-group-mode-hook
    text-mode gnus-group-mode)
  '("normal"))

(defun wymux/modaled-to-insert ()
  "Switch to insert state."
  (interactive)
  (modaled-set-state "insert"))

(setq completion-styles '(hotfuzz))

(setq emms-player-mpd-server-name "localhost")
(setq emms-player-mpd-server-port "6600")
(add-to-list 'emms-player-list 'emms-player-mpd)
(setq emms-player-mpd-music-directory "~/Media/Musica/")
(setq emms-source-file-default-directory "~/Media/Musica/")
(emms-player-mpd-connect)

(emms-player-set emms-player-mpd
		 'regex
		 "\\(flac\\|mp3\\|ape\\|wav\\)$")

(defun wymux/doas ()
  ""
  (interactive)
  (when (not (file-writable-p buffer-file-name))
    (progn
      (find-alternate-file (concat "/doas::" buffer-file-name))
      (read-only-mode -1))))

(add-hook 'find-file-hook 'wymux/doas)

(setq recentf-max-saved-items 1000)
(recentf-mode 1)

(keymap-set minibuffer-mode-map "+" 'minibuffer-complete)
(keymap-set isearch-mode-map "<up>" 'isearch-ring-retreat)
(keymap-set isearch-mode-map "<down>" 'isearch-repeat-advance)
(keymap-set isearch-mode-map "<left>" 'isearch-repeat-backward)
(keymap-set isearch-mode-map "<right>" 'isearch-repeat-forward)
(keymap-set isearch-mode-map "C-l" 'isearch-yank-kill)

(setopt use-short-answers t)

(customize-set-variable 'exwm-manage-configurations 
			'(((member exwm-class-name '("llpp" "Chromium-browser" "firefox"))
			   char-mode t)))

(setq c-default-style "linux"
      c-basic-offset 8)

(defun wymux/auto-create-missing-dirs ()
  (let ((target-dir (file-name-directory buffer-file-name)))
    (unless (file-exists-p target-dir)
      (make-directory target-dir t))))

(add-to-list 'find-file-not-found-functions #'wymux/auto-create-missing-dirs)

(customize-set-variable 'read-file-name-completion-ignore-case t)
(customize-set-variable 'read-buffer-completion-ignore-case t)
(customize-set-variable 'completion-ignore-case t)
(customize-set-variable 'backup-directory-alist
			'(("." . "~/Media/Document/Archive/Emacs/Edit")))
(customize-set-variable 'delete-old-versions t)
(customize-set-variable 'version-control t)
(customize-set-variable 'kept-new-versions 20)
(customize-set-variable 'kept-old-versions 20)
