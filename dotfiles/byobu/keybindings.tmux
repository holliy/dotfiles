set -g prefix F12
unbind-key -n C-a

# クリックだけしたときにコピーモードに入らないように
bind-key -T root MouseDrag1Pane if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" "send-keys -M" "set-environment -F DRAG_START \"#{copy_cursor_x},#{copy_cursor_y}\"; copy-mode -M"
bind-key -T copy-mode MouseDragEnd1Pane send-keys -X stop-selection\; if-shell -F "#{==:\"#{copy_cursor_x},#{copy_cursor_y}\",#{DRAG_START}}" "send-keys -X cancel" \; set-environment -u DRAG_START
bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X stop-selection\; if-shell -F "#{==:\"#{copy_cursor_x},#{copy_cursor_y}\",#{DRAG_START}}" "send-keys -X cancel" \; set-environment -u DRAG_START

# 単語/行を選択したままにする
bind-key -T root DoubleClick1Pane select-pane -t = \; if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" "send-keys -M" "copy-mode\; send-keys -X select-word"
bind-key -T root TripleClick1Pane select-pane -t = \; if-shell -F "#{||:#{pane_in_mode},#{mouse_any_flag}}" "send-keys -M" "copy-mode\; send-keys -X select-line"
bind-key -T copy-mode DoubleClick1Pane select-pane\; send-keys -X select-word
bind-key -T copy-mode-vi DoubleClick1Pane select-pane\; send-keys -X select-word
bind-key -T copy-mode TripleClick1Pane select-pane\; send-keys -X select-line
bind-key -T copy-mode-vi TripleClick1Pane select-pane\; send-keys -X select-line

# vi: ft=tmux:
