# Design & Performance

- Default architecture: hexagonal with dependency injection. Separate pure computation from I/O/adapters.
- Prefer constants over magic numbers; minimal implementation only—solve present requirements, not hypotheticals.
- Emphasize concurrency-safety (PID/file namespacing, per-test isolation).
- Think in Big-O and cpu-clock: measure and simplify; favor algorithms that reduce asymptotic cost before micro-optimizing.
- When coding in languages that leave memory management up to you (e.g., Zig, C, C++, etc.), CAREFULLY consider optimal memory lifetime/custody patterns, especially in loops and concurrency pools; default to using the heap; only use the stack as a later optimization where merited after requirement-satisfaction is clearer and scope creep has slowed. Consider utilization of the Boehm-Demers-Weiser (BDW) collector to ease conceptual/maintenance burden.

## Documentation

- It is important to keep documentation up-to-date after every unit of work
- In code docs is preferred for Elixir with ExDocs
