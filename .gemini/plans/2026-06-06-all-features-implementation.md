# Plan: Comprehensive Multi-Track Implementation (2026-06-06)

This master plan details the sequence and architecture for building out the selected feature tracks: WebSockets, AI Enhancements, Premium Marketplace, Third-Party Integrations, and Mobile App foundations.

## Roadmap & Sequence

### Track 1: Real-Time Messaging (WebSockets)
- **Goal**: Introduce live, reactive messaging with typing indicators and online presence.
- **Tasks**:
  1. Add `@fastify/websocket` to `apps/api`.
  2. Implement a WebSocket manager to route incoming client sockets and manage active connections.
  3. Update Next.js frontend to establish connection on thread mount and listen for real-time messages.
  4. Add typing indicator event broadcast (`user-typing`) and state storage in Redis for online presence.

### Track 2: AI & ML Enhancements
- **Goal**: Make onboarding and matching highly automated and intelligent.
- **Tasks**:
  1. Build a local-first **Resume Parser** inside `apps/orchestrator` that ingests raw PDF/text data and uses an LLM node to extract entities.
  2. Implement an **AI Recommendation Service** matching mentors to mentees based on capability schema overlaps.
  3. Create an **Auto-Suggest Mask** utility that dynamically calculates the top matching mask based on raw text questions.

### Track 3: Premium Marketplace & Analytics
- **Goal**: Stripe-backed booking flow and profile analytics.
- **Tasks**:
  1. Create pricing models and products in Stripe for paid mentoring sessions.
  2. Implement `GET /profiles/:id/analytics` on `apps/api` to return view logs.
  3. Add the booking workflow in the React frontend, handling successful checkouts.

### Track 4: Third-Party Integrations
- **Goal**: Connect system outputs to Slack, Discord, and Zapier.
- **Tasks**:
  1. Implement a unified webhook notification dispatcher.
  2. Add connection UI for Slack and Discord in the settings panel.

### Track 5: Native Mobile Companion App
- **Goal**: Provide API endpoints and schema layouts for a React Native companion app.
- **Tasks**:
  1. Ensure all APIs are PKCE/mobile-auth ready.
  2. Document mobile app design and wireframe routes.

---

## Phase 1 Execution: Real-Time WebSockets
We will start by laying the foundation for **Track 1: Real-Time Messaging**.
1. Install `@fastify/websocket` in `apps/api`.
2. Implement the websocket router in `apps/api/src/routes/websocket.ts`.
3. Verify connection stability and add test suites.
