# Testing Principles

- Tests stay deterministic, fast, and isolated; inject clocks/RNG/I/O; seed DPRNGs for reproducibility; avoid sleeps or timing hacks as these are brittle and create an invisible input dependency on nondeterministic time taken. There is always another way to test something that you would default to a timing hack for (callbacks, injected mock clock, etc.).
- Keep business logic out of tests; assert on returned scalars.
- Mocking awareness: code under test should not know it is being tested; debug hooks are optional, not required by tests.
- DO NOT trust your (admittedly strong but not perfect) ability to bang out good code first. Always plan first and start by writing failing tests that set behavior expectations (TDD). When you encounter a problem, first try to write a test that surfaces the problem again by failing, then make it pass.
