# [devs.guide/to/nvidia](devs.guide/to/nvidia/)
> A Devs Guide to NVIDIA-focused documentation.

## __Repository Structure:__
- [`nvidia/`](./) — top-level NVIDIA documentation hub
    - [`nvidia/virtualization/docker/`](virtualization/docker/) — shared Docker workflows
    - [`nvidia/models/formats/nvfp4/`](models/formats/nvfp4/) — NVFP4 format, runtime, and model notes
    - [`nvidia/dgx/spark/`](dgx/spark/) — DGX Spark-specific documentation

## __URL Paths:__
- [devs.guide/to/nvidia/](./)
- [devs.guide/to/nvidia/virtualization/docker/](virtualization/docker/)
- [devs.guide/to/nvidia/models/formats/nvfp4/](models/formats/nvfp4/)
- [devs.guide/to/nvidia/dgx/spark/](dgx/spark/)

## Table of Contents
1. [Overview](#overview)
   - [Current Scope](#current-scope)
   - [Repository Structure](#repository-structure)

2. [Guides](#guides)
   - [Docker](#docker)
   - [NVFP4](#nvfp4)
   - [DGX Spark](#dgx-spark)

---

## Overview
> A guide intended to organize NVIDIA-related material in a path-based structure that can grow over time.

This guide currently follows a minimal structure focused on shared Docker workflows, NVFP4 model-format documentation, and DGX Spark platform documentation.

- [Docker](#docker)
- [NVFP4](#nvfp4)
- [DGX Spark](#dgx-spark)

---

## Guides

### [Docker](virtualization/docker/)
> Installation, images, volumes, networking, and troubleshooting.

- image management
- volumes and bind mounts
- container networking
- logs and troubleshooting

### [NVFP4](models/formats/nvfp4/)
> Format, runtimes, model layout, validation, and deployment notes.

- supported runtimes
- model layout conventions
- validation commands
- memory considerations
- deployment troubleshooting

### [DGX Spark](dgx/spark/)
> Deployment, setup, runtime validation, networking, and troubleshooting.

- initial setup
- Docker and container runtime
- NVFP4 workflows
- networking
- troubleshooting
