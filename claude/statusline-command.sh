#!/usr/bin/env bash
input=$(cat)

model_name=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
used=$(echo "$input"       | jq -r '.context_window.used_percentage // empty')
total_in=$(echo "$input"   | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input"  | jq -r '.context_window.total_output_tokens // 0')
cost=$(echo "$input"       | jq -r '.cost.total_cost_usd // empty')

# ── Line 1: model + context bar ──────────────────────────────────────────────
if [ -n "$used" ]; then
	used_int=$(printf '%.0f' "$used")
	filled=$(( used_int / 5 ))
	empty=$(( 20 - filled ))
	bar=""
	for i in $(seq 1 $filled); do bar="${bar}#"; done
	for i in $(seq 1 $empty); do bar="${bar}-"; done
	line1=$(printf '%s  [%s] %d%%' "$model_name" "$bar" "$used_int")
else
	line1=$(printf '%s  [--------------------] --%%' "$model_name")
fi

# ── Line 2: context tokens + session cost ────────────────────────────────────
ctx_display=$(awk -v tin="$total_in" -v tout="$total_out" '
BEGIN {
	total = tin + tout
	if (total >= 1000000)   printf "%.1fM", total / 1000000
	else if (total >= 1000) printf "%.0fK", total / 1000
	else                    printf "%d",    total
}
')

if [ -n "$cost" ]; then
	cost_display=$(printf '$%.4f' "$cost")
else
	cost_display="$--"
fi

line2=$(printf 'ctx: %s  cost: %s' "$ctx_display" "$cost_display")

printf '%s\n%s' "$line1" "$line2"
