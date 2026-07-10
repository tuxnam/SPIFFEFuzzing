## SPIFFEFuzzing

SPIFFEFuzzing is an invariant-driven testing framework for SPIFFE implementations.

The project extracts normative requirements (MUST, MUST NOT, SHOULD, MAY) from the SPIFFE specifications and converts them into executable test cases. These tests are then executed against multiple implementations to identify inconsistencies, specification ambiguities, and potential security issues.

The initial focus is on:

* Building a machine-readable database of SPIFFE invariants.
* Testing SPIRE through its native Workload API.
* Comparing behaviour with Python SPIFFE libraries.
* Using AI agents to generate edge cases, perform differential analysis, and assist with vulnerability research.

The goal is to better understand SPIFFE at a specification level while playing with agents orchestration through systematic testing.
