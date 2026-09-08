# Implementation Plan - RAG Q-A System Frontend

This plan outlines the creation of a Flutter-based frontend for the `graphify` knowledge graph system, which serves as the "RAG Q-A system" for this project. The frontend will allow users to query the codebase, explore relationships, and visualize the graph data directly within the app.

## User Review Required

> [!IMPORTANT]
> The frontend will interact with the `graphify` tool via the command-line interface (`./cmds/graphify.sh`). This assumes that the `graphify` Python package is installed in the environment where the app is running (or accessible via the shell).

## Proposed Changes

### [Flutter Frontend]

#### [MODIFY] [main.dart](file:///Users/buddhadev/AndroidStudioProjects/rag_system/lib/main.dart)
Replace the default counter app with the RAG Q-A system interface.
- Add a `GraphifyService` to handle shell command execution.
- Implement a `RAGHomePage` with tabs for Query, Explain, Path, and Status.
- Use a `TerminalOutput` widget to display command results with basic highlighting for nodes and edges.

#### [NEW] [graphify_service.dart](file:///Users/buddhadev/AndroidStudioProjects/rag_system/lib/graphify_service.dart)
A service class to encapsulate calls to `./cmds/graphify.sh`.
- Methods: `query(String q)`, `explain(String concept)`, `path(String a, String b)`, `status()`.

#### [NEW] [models.dart](file:///Users/buddhadev/AndroidStudioProjects/rag_system/lib/models.dart)
Simple data models for representing Graphify output if parsing is needed (otherwise, raw string handling).

## Verification Plan

### Manual Verification
1. Run the Flutter app.
2. Navigate to the "Status" tab and verify it displays the current graph status.
3. Use the "Query" tab to ask "What is MyApp?" and verify the output shows the relevant nodes and edges.
4. Test the "Explain" tab with a concept like "MyHomePage".
5. Verify that error messages are handled gracefully if `graphify` is not available.
