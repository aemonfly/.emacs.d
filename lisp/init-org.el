; -*-Emacs-Lisp-*-
;;; add the requirement for org
(require 'org-clock)
(require 'org-id)
(require 'org-agenda)

;;; Explicitly load required exporters export setup
(require 'ox-html)
(require 'ox-latex)
(require 'ox-ascii)

;;; add .org .txt .org_archive to the auto-mode-alist
;;; to enable org mode automatically for those files
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))

;;; define org global keys
(define-key global-map "\C-cc" 'org-capture)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-cb" 'org-iswitchb)

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))
(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

(setq org-tag-alist (quote ((:startgroup)
			    ("@office" . ?o)
			    ("@home" . ?H)
			    (:endgroup)
			    ("WAITING" . ?w)
			    ("HOLD" . ?h)
			    ("PERSONAL" . ?P)
			    ("WORK" . ?W)
			    ("ORG" . ?O)
			    ("crypt" . ?E)
			    ("NOTE" . ?n)
			    ("CANCELLED" . ?c)
			    ("FLAGGED" . ??))))

; Allow setting single tags without the menu
(setq org-fast-tag-selection-single-key (quote expert))

;For tag searches ignore tasks with scheduled and deadline dates
(setq org-agenda-tags-todo-honor-ignore-options t)

;; Capture templates for: TODO tasks, Notes, appointments, phone calls, meetings, and org-protocol
(setq org-capture-templates
      (quote (("t" "todo" entry (file "~/datas/orgws/org/refile.org")
               "* TODO %?\n%U\n%a\n" :clock-in t :clock-resume t)
              ("r" "respond" entry (file "~/datas/orgws/org/refile.org")
               "* NEXT Respond to %:from on %:subject\nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
              ("n" "note" entry (file "~/datas/orgws/org/refile.org")
               "* %? :NOTE:\n%U\n%a\n" :clock-in t :clock-resume t)
              ("j" "Journal" entry (file+datetree "~/datas/orgws/org/diary.org")
               "* %?\n%U\n" :clock-in t :clock-resume t)
              ("w" "org-protocol" entry (file "~/datas/orgws/org/refile.org")
               "* TODO Review %c\n%U\n" :immediate-finish t)
              ("m" "Meeting" entry (file "~/datas/orgws/org/refile.org")
               "* MEETING with %? :MEETING:\n%U" :clock-in t :clock-resume t)
              ("p" "Phone call" entry (file "~/datas/orgws/org/refile.org")
               "* PHONE %? :PHONE:\n%U" :clock-in t :clock-resume t)
              ("h" "Habit" entry (file "~/datas/orgws/org/refile.org")
               "* NEXT %?\n%U\n%a\nSCHEDULED: %(format-time-string \"<%Y-%m-%d %a .+1d/3d>\")\n:PROPERTIES:\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))
;(setq org-log-done 'time)

;; setup the org-refile-targets-dir
(setq org-refile-targets-dir (quote ("~/datas/orgws/org/"
                               "~/datas/orgws/org/client1/"
                               "~/datas/orgws/client2/")))

;; setup the org-agenda-files 
(setq org-agenda-files (quote ("~/datas/orgws/org/"
                               "~/datas/orgws/org/client1/"
                               "~/datas/orgws/client2/")))
;; setup the org-refile-targets
(setq org-refile-targets (quote ( 
			         (org-agenda-files :maxlevel . 9)
				 (nil :maxlevel . 9))))

; Use full outline paths for refile targets - we file directly with IDO
(setq org-refile-use-outline-path t)

; Targets complete directly with IDO
(setq org-outline-path-complete-in-steps nil)

; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

; Use IDO for both buffer and file completion and ido-everywhere to t
(setq org-completion-use-ido t)
(setq ido-everywhere t)
(setq ido-max-directory-size 100000)
(ido-mode (quote both))
; Use the current window when visiting files and buffers with ido
(setq ido-default-file-method 'selected-window)
(setq ido-default-buffer-method 'selected-window)
;; Use the current window for indirect buffer display
(setq org-indirect-buffer-display 'current-window)

;;disable keys to change agenda files
(defun org-mode-disable-keys ()
	(progn (define-key org-mode-map "\C-c[" nil)
	       (define-key org-mode-map "\C-c]" nil)
	       (define-key org-mode-map "\C-c;" nil)))
;;add the hook
(add-hook 'org-mode-hook 'org-mode-disable-keys)


;; time clocking options
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)

;;
;; Show lot of clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 23)

;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)

;;separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)

(setq bh/keep-clock-running nil)

(defun bh/clock-in-to-next (kw)
    "Switch a task from TODO to NEXT when clocking in.
Skips capture tasks, projects, and subprojects.
Switch projects and subprojects from NEXT back to TODO"
    (when (not (and (boundp 'org-capture-mode) org-capture-mode))
      (cond
       ((and (member (org-get-todo-state) (list "TODO"))
	     (bh/is-task-p))
	"NEXT")
       ((and (member (org-get-todo-state) (list "NEXT"))
	     (bh/is-project-p))
	      "TODO"))))

(defun bh/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
	(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	  (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))


(defun bh/punch-in (arg)
    "Start continuous clocking and set the default task to the
selected task.  If no task is selected set the Organization task
as the default task."
    (interactive "p")
    (setq bh/keep-clock-running t)
    (if (equal major-mode 'org-agenda-mode)
	;;
	;; We're in the agenda
	;;
	(let* ((marker (org-get-at-bol 'org-hd-marker))
	       (tags (org-with-point-at marker (org-get-tags-at))))
	  (if (and (eq arg 4) tags)
	      (org-agenda-clock-in '(16))
	    (bh/clock-in-organization-task-as-default)))
      ;;
      ;; We are not in the agenda
      ;;
      (save-restriction
	(widen)
					; Find the tags on the current task
	(if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
	    (org-clock-in '(16))
	          (bh/clock-in-organization-task-as-default)))))


(defun bh/punch-out ()
  (interactive)
  (setq bh/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))

(defun bh/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun bh/clock-in-parent-task ()
  "Move point to the parent (project) task if any and clock in"
  (let ((parent-task))
    (save-excursion
      (save-restriction
	(widen)
	(while (and (not parent-task) (org-up-heading-safe))
	  (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	    (setq parent-task (point))))
	(if parent-task
	    (org-with-point-at parent-task
	      (org-clock-in))
	  (when bh/keep-clock-running
	    (bh/clock-in-default-task)))))))

(defvar bh/organization-task-id "eb155a82-92b2-4f25-a3c6-0304591af2f9")

(defun bh/clock-in-organization-task-as-default ()
  (interactive)
  (org-with-point-at (org-id-find bh/organization-task-id 'marker)
    (org-clock-in '(16))))

(defun bh/clock-out-maybe ()
  (when (and bh/keep-clock-running
	     (not org-clock-clocking-in)
	     (marker-buffer org-clock-default-task)
	     (not org-clock-resolving-clocks-due-to-idleness))
    (bh/clock-in-parent-task)))

(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)

(defun bh/clock-in-task-by-id (id)
  "Clock in a task by id"
  (org-with-point-at (org-id-find id 'marker)
    (org-clock-in nil)))

(defun bh/clock-in-last-task (arg)
    "Clock in the interrupted task if there is one
Skip the default task and get the next one.
A prefix arg forces clock in of the default task."
    (interactive "p")
    (let ((clock-in-to-task
	   (cond
	    ((eq arg 4) org-clock-default-task)
	    ((and (org-clock-is-active)
		  (equal org-clock-default-task (cadr org-clock-history)))
	     (caddr org-clock-history))
	    ((org-clock-is-active) (cadr org-clock-history))
	    ((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
	    (t (car org-clock-history)))))
      (widen)
      (org-with-point-at clock-in-to-task
	      (org-clock-in nil))))

;; the bh utilitis
(defun bh/is-project-p ()
  "Any task with a todo keyword subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
	  (subtree-end (save-excursion (org-end-of-subtree t)))
	  (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
	(forward-line 1)
	(while (and (not has-subtask)
		    (< (point) subtree-end)
		    (re-search-forward "^\*+ " subtree-end t))
	  (when (member (org-get-todo-state) org-todo-keywords-1)
	    (setq has-subtask t))))
      (and is-a-task has-subtask))))

(defun bh/is-project-subtree-p ()
    "Any task with a todo keyword that is in a project subtree.
Callers of this function already widen the buffer view."
    (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
				(point))))
      (save-excursion
	(bh/find-project-task)
	(if (equal (point) task)
	    nil
	  t))))

(defun bh/is-task-p ()
  "Any task with a todo keyword and no subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
	  (subtree-end (save-excursion (org-end-of-subtree t)))
	  (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
	(forward-line 1)
	(while (and (not has-subtask)
		    (< (point) subtree-end)
		    (re-search-forward "^\*+ " subtree-end t))
	  (when (member (org-get-todo-state) org-todo-keywords-1)
	    (setq has-subtask t))))
      (and is-a-task (not has-subtask)))))

(defun bh/is-subproject-p ()
  "Any task which is a subtask of another project"
  (let ((is-subproject)
	(is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
    (save-excursion
      (while (and (not is-subproject) (org-up-heading-safe))
	(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	  (setq is-subproject t))))
    (and is-a-task is-subproject)))

(defun bh/list-sublevels-for-projects-indented ()
    "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
    (if (marker-buffer org-agenda-restrict-begin)
	(setq org-tags-match-list-sublevels 'indented)
      (setq org-tags-match-list-sublevels nil))
    nil)

(defun bh/list-sublevels-for-projects ()
    "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
  This is normally used by skipping functions where this variable is already local to the agenda."
    (if (marker-buffer org-agenda-restrict-begin)
	(setq org-tags-match-list-sublevels t)
      (setq org-tags-match-list-sublevels nil))
    nil)

(defvar bh/hide-scheduled-and-waiting-next-tasks t)

(defun bh/toggle-next-task-display ()
  (interactive)
  (setq bh/hide-scheduled-and-waiting-next-tasks (not bh/hide-scheduled-and-waiting-next-tasks))
  (when  (equal major-mode 'org-agenda-mode)
    (org-agenda-redo))
  (message "%s WAITING and SCHEDULED NEXT Tasks" (if bh/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

(defun bh/skip-stuck-projects ()
  "Skip trees that are not stuck projects"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (bh/is-project-p)
	  (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
		 (has-next ))
	    (save-excursion
	      (forward-line 1)
	      (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
		(unless (member "WAITING" (org-get-tags-at))
		  (setq has-next t))))
	    (if has-next
		nil
	      next-headline)) ; a stuck project, has subtasks but no next task
	nil))))

(defun bh/skip-non-stuck-projects ()
  "Skip trees that are not stuck projects"
  ;; (bh/list-sublevels-for-projects-indented)
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (bh/is-project-p)
	  (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
		 (has-next ))
	    (save-excursion
	      (forward-line 1)
	      (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
		(unless (member "WAITING" (org-get-tags-at))
		  (setq has-next t))))
	    (if has-next
		next-headline
	      nil)) ; a stuck project, has subtasks but no next task
	next-headline))))

(defun bh/skip-non-projects ()
  "Skip trees that are not projects"
  ;; (bh/list-sublevels-for-projects-indented)
  (if (save-excursion (bh/skip-non-stuck-projects))
      (save-restriction
	(widen)
	(let ((subtree-end (save-excursion (org-end-of-subtree t))))
	  (cond
	   ((bh/is-project-p)
	    nil)
	   ((and (bh/is-project-subtree-p) (not (bh/is-task-p)))
	    nil)
	   (t
	    subtree-end))))
    (save-excursion (org-end-of-subtree t))))

(defun bh/skip-project-trees-and-habits ()
  "Skip trees that are projects"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
	subtree-end)
       ((org-is-habit-p)
	subtree-end)
       (t
	nil)))))

(defun bh/skip-projects-and-habits-and-single-tasks ()
  "Skip trees that are projects, tasks that are habits, single non-project tasks"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((org-is-habit-p)
	next-headline)
       ((and bh/hide-scheduled-and-waiting-next-tasks
	     (member "WAITING" (org-get-tags-at)))
	next-headline)
       ((bh/is-project-p)
	next-headline)
       ((and (bh/is-task-p) (not (bh/is-project-subtree-p)))
	next-headline)
       (t
	nil)))))

(defun bh/skip-project-tasks-maybe ()
    "Show tasks related to the current restriction.
When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
When not restricted, skip project and sub-project tasks, habits, and project related tasks."
    (save-restriction
      (widen)
      (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
	     (next-headline (save-excursion (or (outline-next-heading) (point-max))))
	     (limit-to-project (marker-buffer org-agenda-restrict-begin)))
	(cond
	 ((bh/is-project-p)
	  next-headline)
	 ((org-is-habit-p)
	  subtree-end)
	 ((and (not limit-to-project)
	       (bh/is-project-subtree-p))
	  subtree-end)
	 ((and limit-to-project
	       (bh/is-project-subtree-p)
	       (member (org-get-todo-state) (list "NEXT")))
	  subtree-end)
	 (t
	  nil)))))

(defun bh/skip-project-tasks ()
    "Show non-project tasks.
Skip project and sub-project tasks, habits, and project related tasks."
    (save-restriction
      (widen)
      (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
	(cond
	 ((bh/is-project-p)
	  subtree-end)
	 ((org-is-habit-p)
	  subtree-end)
	 ((bh/is-project-subtree-p)
	  subtree-end)
	 (t
	  nil)))))

(defun bh/skip-non-project-tasks ()
    "Show project tasks.
Skip project and sub-project tasks, habits, and loose non-project tasks."
    (save-restriction
      (widen)
      (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
	     (next-headline (save-excursion (or (outline-next-heading) (point-max)))))
	(cond
	 ((bh/is-project-p)
	  next-headline)
	 ((org-is-habit-p)
	  subtree-end)
	 ((and (bh/is-project-subtree-p)
	       (member (org-get-todo-state) (list "NEXT")))
	  subtree-end)
	 ((not (bh/is-project-subtree-p))
	  subtree-end)
	 (t
	  nil)))))

(defun bh/skip-projects-and-habits ()
  "Skip trees that are projects and tasks that are habits"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
	subtree-end)
       ((org-is-habit-p)
	subtree-end)
       (t
	nil)))))

(defun bh/skip-non-subprojects ()
  "Skip trees that are not projects"
  (let ((next-headline (save-excursion (outline-next-heading))))
    (if (bh/is-subproject-p)
	nil
            next-headline)))

; Set default column view headings: Task Effort Clock_Summary
(setq org-columns-default-format "%80ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM")

; global Effort estimate values
; global STYLE property values for completion
(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")
                                    ("STYLE_ALL" . "habit"))))

; New Exporter Setup
(setq org-alphabetical-lists t)


(setq org-ditaa-jar-path "~/java/ditaa0_9.jar")
(setq org-plantuml-jar-path "~/java/plantuml.jar")

(add-hook 'org-babel-after-execute-hook 'bh/display-inline-images 'append)

; Make babel results blocks lowercase
(setq org-babel-results-keyword "results")

(defun bh/display-inline-images ()
  (condition-case nil
      (org-display-inline-images)
    (error nil)))

(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote ((emacs-lisp . t)
         (dot . t)
         (ditaa . t)
         (R . t)
         (python . t)
         (ruby . t)
         (gnuplot . t)
         (clojure . t)
         (sh . t)
         (ledger . t)
         (org . t)
         (plantuml . t)
         (latex . t))))

; Do not prompt to confirm evaluation
; This may be dangerous - make sure you understand the consequences
; of setting this -- see the docstring for details
(setq org-confirm-babel-evaluate nil)

; Use fundamental mode when editing plantuml blocks with C-c '
(add-to-list 'org-src-lang-modes (quote ("plantuml" . fundamental)))

; set the org export encoding
(setq org-export-coding-system 'utf-8)

; include the latex path for Mac
(setenv "PATH" (concat (getenv "PATH") ":/usr/texbin"))

(provide 'init-org)
