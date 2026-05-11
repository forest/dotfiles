# Debugging Philosophy: Run Toward Problems, Not Away

When encountering bugs, especially threading/concurrency issues or crashes:

1. **Never dodge or contain** - Don't skip tests, add workarounds, or move on hoping the issue won't resurface. A contained problem is a time bomb.
2. **Smash the problem** - Oversaturate the problematic code path with the triggering input. For threading bugs, spawn many concurrent workers hitting the same code. For crashes, loop the failing operation thousands of times. Force statistical improbabilities to become certainties.
3. **Observe the devil emerge** - With enough pressure, intermittent bugs become reproducible. Capture stack traces, add debug output, watch memory patterns. The root cause will reveal itself.
4. **Fix with confidence** - Trust that with sufficient investigation, the true cause can be found. A proper fix at the root works forever; a workaround fails eventually.
5. **Threading caveat** - OS/CPU scheduling is beyond our control, but we CAN force race conditions to manifest by massively parallel stress testing. The goal is deterministic reproduction of "impossible" bugs.

This philosophy applies to all debugging: the shortcut of avoidance always costs more time than the direct path of confrontation.
