---
title: 'Exercise 06: AI Governance and Model Observability'
layout: default
nav_order: 7
has_children: true
---

# Exercise 06: AI Governance and Model Observability

## Scenario

Zava’s AI service runs on Azure App Service with Application Insights and Log Analytics (provisioned in earlier exercises). In this exercise you will extend observability and governance for the chat completion path by adding custom telemetry, infrastructure for visualization and alerting, and automated summarization in CI/CD.

## Objectives

After you complete this exercise, you will be able to:

* Instrument AI chat completions with custom Application Insights telemetry (model version, latency, result).
* Validate telemetry ingestion through Log Analytics queries.
* Deploy an Application Insights Workbook that visualizes latency by model version.
* Deploy an Azure Monitor alert that triggers on sustained high completion latency.
* Summarize AI performance in a GitHub Actions workflow in order to track performance changes over time.
* Interpret workbook charts and alert signals for governance decisions.

## Duration

* **Estimated Time:** 45–60 minutes


