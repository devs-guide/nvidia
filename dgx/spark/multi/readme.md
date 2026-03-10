# MULTI SPARK
> Dual-DGX Spark pairing notes for `<SPARK_ONE>` to `<SPARK_TWO>`.

## __Repository Structure:__
- [`multi/readme.md`](./) — landing page for dual-host specifics
- [`multi/setup.md`](setup.md) — serialized pairing flow for two nodes
- [`multi/networking.md`](networking.md) — cabling, MTU, routes, and link tests
- [`multi/nccl.md`](nccl.md) — NCCL/IB validation and tuning
- [`multi/validation.md`](validation.md) — post-setup probes and smoke tests
- [`multi/troubleshooting.md`](troubleshooting.md) — quick fixes for common breakage

## Table of Contents
1. [Overview](#overview)
2. [Docs](#docs)
   - [Setup](#setup)
   - [Networking](#networking)
   - [NCCL](#nccl)
   - [Validation](#validation)
   - [Troubleshooting](#troubleshooting)

---

## Overview
> Setup for two DGX Sparks

Focus: 
- consistent IP plan 
- resilient links
- validated NCCL paths between `<SPARK_ONE>` to `<SPARK_TWO>`

---

## Docs

### Setup
See [`setup.md`](setup.md) for a linear host-to-host pairing flow.

### Networking
Link targets, MTU, and checks live in [`networking.md`](networking.md).

### NCCL
Collective validation and tuning steps are in [`nccl.md`](nccl.md).

### Validation
Post-setup probes and smoke tests sit in [`validation.md`](validation.md).

### Troubleshooting
Common break/fix snippets live in [`troubleshooting.md`](troubleshooting.md).
