# Plan: Resolve System Density Vacuums

## Observation
The system density readout in the rules shows `Δ24h: n/a | Δ7d: n/a`. According to the constitutional rules: "N/A is a vacuum — research it, plan it, log it" and "none-knowledge--N/A, no data, seed lacking--creates vacuum".

## Diagnosis
The system is failing to report 24-hour and 7-day delta metrics for events. The data is either not being collected, not being parsed, or not being propagated to the `GEMINI.md` / `AGENTS.md` context files.

## Action Plan
1. **Research**: Investigate the `organvm` pipeline that generates the System Density block. Locate the script or command responsible for calculating `Δ24h` and `Δ7d`.
2. **Log**: Create a new IRF tracking item to officially track the resolution of this vacuum.
3. **Remediate**: Update the data collection mechanisms to properly track and inject these event deltas.
4. **Deploy**: Update the `seed.yaml` if capabilities change, and ensure the local:remote parity is maintained.
