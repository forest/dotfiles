#!/usr/bin/env bash
input=$(cat)

model_name=$(echo "$input"   | jq -r '.model.display_name // "Unknown"')
output_style=$(echo "$input" | jq -r '.output_style.name // "default"')
remaining=$(echo "$input"    | jq -r '.context_window.remaining_percentage // empty')
cwd=$(echo "$input"          | jq -r '.workspace.current_dir // .cwd // empty')

# ── colors (dim-friendly; the status line is already rendered dimmed) ───────
c_reset=$'\033[0m'
c_model=$'\033[36m'   # cyan
c_style=$'\033[35m'   # magenta
c_ctx_ok=$'\033[32m'  # green
c_ctx_low=$'\033[31m' # red
c_branch=$'\033[34m'  # blue
c_dirty=$'\033[33m'   # yellow
c_path=$'\033[37m'    # white

# ── context window remaining ─────────────────────────────────────────────────
if [ -n "$remaining" ]; then
	remaining_int=$(printf '%.0f' "$remaining")
	if [ "$remaining_int" -le 15 ]; then
		ctx_color="$c_ctx_low"
	else
		ctx_color="$c_ctx_ok"
	fi
	ctx_display=$(printf '%s%d%% left%s' "$ctx_color" "$remaining_int" "$c_reset")
else
	ctx_display=$(printf '%s--%% left%s' "$c_ctx_low" "$c_reset")
fi

# ── git branch + dirty state (skip optional locks; no-op outside a repo) ────
git_info=""
if [ -n "$cwd" ] && git --no-optional-locks -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
	branch=$(git --no-optional-locks -C "$cwd" branch --show-current 2>/dev/null)
	[ -z "$branch" ] && branch=$(git --no-optional-locks -C "$cwd" rev-parse --short HEAD 2>/dev/null)

	dirty=""
	if [ -n "$(git --no-optional-locks -C "$cwd" status --porcelain=v1 2>/dev/null)" ]; then
		dirty="*"
	fi

	sync=""
	ahead_behind=$(git --no-optional-locks -C "$cwd" rev-list --left-right --count '@{u}...HEAD' 2>/dev/null)
	if [ -n "$ahead_behind" ]; then
		behind=$(echo "$ahead_behind" | awk '{print $1}')
		ahead=$(echo "$ahead_behind"  | awk '{print $2}')
		[ "$ahead" != "0" ]  && sync="${sync}↑${ahead}"
		[ "$behind" != "0" ] && sync="${sync}↓${behind}"
	fi

	git_info=$(printf ' %s%s%s%s%s' "$c_branch" "$branch" "$c_dirty" "$dirty" "$c_reset")
	[ -n "$sync" ] && git_info="${git_info} ${sync}"
fi

# ── cwd (swap $HOME for ~) ────────────────────────────────────────────────────
cwd_display=${cwd/#$HOME/\~}

line1=$(printf '%s%s%s · %s%s%s · %s' \
	"$c_model" "$model_name" "$c_reset" \
	"$c_style" "$output_style" "$c_reset" \
	"$ctx_display")
line2=$(printf '%s%s%s%s' "$c_path" "$cwd_display" "$c_reset" "$git_info")

printf '%s\n%s' "$line1" "$line2"
