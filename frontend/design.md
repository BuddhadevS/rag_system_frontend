Build a modern, clean, professional frontend UI for a "RAG-based Document Q&A System" using Flutter.

The application is a document-based AI assistant where the user first uploads a document, waits for successful document processing, and then asks questions about that document.

IMPORTANT:
- Create a polished production-quality UI.
- The design should look like a modern AI SaaS application.
- Keep the UI minimal, spacious, professional and easy to understand.
- Do NOT make it look like a basic CRUD application.
- Use reusable Flutter widgets and clean component-based architecture.
- Make the UI responsive for Web and Desktop.
- Use smooth animations and loading states.
- Use good typography, spacing, rounded cards, subtle shadows and modern colors.
- Keep accessibility and readable contrast in mind.

==================================================
1. APPLICATION LAYOUT
   ==================================================

Create a centered application with:

- A top navigation/header
- Main content area
- Responsive layout
- Maximum content width around 1100–1200px
- Comfortable horizontal and vertical spacing

Header:

Left:
- Small AI/document icon
- Application name:
  "DocuMind"
- Subtitle:
  "AI-powered Document Q&A"

Right:
- Status indicator:
  "AI Online"
- Small green status dot

Use a clean white/light background with subtle gray/blue gradients.

==================================================
2. INITIAL STATE — DOCUMENT UPLOAD
   ==================================================

When the user opens the application, show a large document upload card.

Heading:

"Upload your document"

Subtitle:

"Upload a document and ask questions about its content using AI."

Upload area:

Create a large drag-and-drop style area.

Inside:

- Document upload icon
- Text:
  "Drag & drop your document here"
- Secondary text:
  "or click to browse files"
- Supported formats:
  "PDF, DOCX, TXT"
- Maximum file size:
  "Maximum size: 10 MB"

The upload area should have:

- Dashed border
- Rounded corners
- Light background
- Hover effect
- Drag-over animation
- Upload icon animation

After the user selects a file, replace the empty upload state with a selected-file preview.

Selected file card should show:

- File icon
- File name
- File type
- File size
- Upload progress if applicable
- Remove button

Example:

┌──────────────────────────────────────────────┐
│ 📄  company-policy.pdf                  ✕   │
│     PDF • 2.4 MB                             │
│                                              │
│     Uploading...                 65%         │
│     ━━━━━━━━━━━━━━━━━━━━━━━                  │
└──────────────────────────────────────────────┘

==================================================
3. UPLOAD ACTION BUTTONS
   ==================================================

Below the upload component show two buttons:

Primary:

"Upload & Process"

Secondary:

"Cancel"

Primary button:

- Filled
- Rounded corners
- Document/Upload icon
- Disabled when no file is selected
- Loading state after clicking

Loading state:

"Processing document..."

Show a spinner.

Cancel button:

- Outlined/transparent
- Clears the selected document
- Returns to initial upload state

==================================================
4. DOCUMENT PROCESSING STATE
   ==================================================

After clicking "Upload & Process", show a processing state.

Display:

"Preparing your document..."

Subtitle:

"Extracting text, creating chunks and generating embeddings."

Show a step-based progress indicator:

✓ Document uploaded
✓ Text extracted
● Creating embeddings
○ Preparing document for Q&A

Use animated progress indicators.

Do not allow the question section to appear until processing succeeds.

==================================================
5. SUCCESS STATE
   ==================================================

When document processing succeeds, show a success banner/card.

Example:

✓ Document ready

"company-policy.pdf is ready for questions."

Then show a button:

"Ask a question"

Use a subtle success animation.

==================================================
6. QUESTION SECTION
   ==================================================

Only after successful document processing, reveal the question section using a smooth slide/fade animation.

Heading:

"Ask anything about your document"

Subtitle:

"Ask a question and the AI will answer using the information from your document."

Create a large question input card.

Input:

"Ask a question about your document..."

Use a multiline text field.

At the bottom/right of the input:

"Ask AI →"

The button should be disabled when the question is empty.

Example questions should appear below the input as clickable suggestion chips:

- "What is this document about?"
- "Summarize the key points"
- "What are the main requirements?"
- "Explain this in simple terms"

Clicking a suggestion should populate the question input.

==================================================
7. QUESTION PROCESSING STATE
   ==================================================

When the user clicks "Ask AI":

Show an animated loading state.

Display:

"Thinking..."

Subtitle:

"Searching the document and generating an answer."

Show:

Searching document
↓
Finding relevant sections
↓
Generating answer

The UI should feel like an AI assistant is working.

==================================================
8. ANSWER SECTION
   ==================================================

After receiving the answer, display a large answer card.

Header:

"AI Answer"

Include:

- AI icon/avatar
- "DocuMind AI"
- Small response time indicator if available
- Copy button

Answer content should be beautifully formatted.

Support:

- Paragraphs
- Bullet points
- Numbered lists
- Bold text
- Code blocks if necessary

Do not display the answer as plain unformatted text.

Example:

┌──────────────────────────────────────────────┐
│ ✨ DocuMind AI                    Copy       │
│                                              │
│ The document describes the company's...     │
│                                              │
│ Key points:                                  │
│                                              │
│ • Employees must...                          │
│ • Requests should...                         │
│ • Managers are responsible for...            │
└──────────────────────────────────────────────┘

==================================================
9. SOURCES / RAG CONTEXT
   ==================================================

Below the answer, show a "Sources" section.

Heading:

"Sources from your document"

Show the document chunks used by the RAG pipeline.

Each source card should contain:

- Source number
- Document name
- Page number if available
- Relevant text snippet
- Similarity/relevance score if available

Example:

Source 1
company-policy.pdf • Page 4

"Employees must submit leave requests at least
three working days in advance..."

Relevance: 92%

Make source cards collapsible.

==================================================
10. CHAT / QUESTION HISTORY
    ==================================================

Allow the user to ask multiple questions after uploading one document.

Display previous questions and answers in a conversation-style layout.

User message:

"You are an AI assistant..."

AI response:

"According to the document..."

Use different alignment/background for user and AI messages.

Add timestamps if available.

The conversation should remain scrollable.

==================================================
11. NEW DOCUMENT
    ==================================================

Provide a button near the document information:

"+ Upload New Document"

When clicked:

- Clear current document
- Clear questions
- Clear answers
- Return to upload state

Show a confirmation dialog if there is existing conversation history.

==================================================
12. ERROR STATES
    ==================================================

Design proper error states.

Upload error:

"Unable to upload document"

"Please check the file type and size and try again."

Processing error:

"Document processing failed"

"Something went wrong while preparing your document."

Question error:

"Unable to generate an answer"

"Please try again."

Use a retry button.

Never leave the user with an unexplained blank screen.

==================================================
13. EMPTY STATES
    ==================================================

Before uploading:

Show:

📄
"Your document is waiting"

"Upload a document to start asking questions."

After processing:

✨
"Your document is ready"

"Ask your first question to get started."

==================================================
14. CSS / VISUAL DESIGN
    ==================================================

Use a modern AI SaaS visual style.

Color palette:

- Primary: deep indigo / blue
- Secondary: soft purple
- Background: very light gray/blue
- Cards: white
- Text: dark charcoal
- Secondary text: muted gray
- Success: green
- Error: red

Use subtle gradients for important AI elements.

Avoid excessive gradients.

Cards:

- Border radius: 16–20px
- Very subtle shadow
- Thin light borders
- Generous padding

Buttons:

- Border radius: 10–12px
- Height around 44–48px
- Clear hover state
- Clear pressed state
- Disabled state
- Loading state

Input:

- Rounded corners
- Focus border animation
- Clear focus state
- Comfortable padding
- Multiline support

Typography:

Use a modern font such as Inter.

Hierarchy:

Application title:
24–28px

Section title:
22–24px

Body:
14–16px

Secondary text:
13–14px

Use appropriate font weights.

==================================================
15. RESPONSIVE DESIGN
    ==================================================

The UI must work well on:

- Desktop
- Tablet
- Mobile
- Flutter Web

Desktop:

Use a centered content area around 1100–1200px.

Tablet:

Reduce horizontal padding.

Mobile:

Stack all components vertically.

Upload card should become full width.

Question input should become full width.

Buttons should adapt to available width.

Sources should become expandable cards.

==================================================
16. ANIMATIONS
    ==================================================

Use subtle animations:

- Upload card hover animation
- File selection animation
- Upload progress animation
- Processing step animation
- Success check animation
- Question section fade/slide animation
- AI answer appearance animation
- Source expansion animation
- Button loading animation

Do NOT overuse animations.

Animations should feel professional and fast.

==================================================
17. APPLICATION FLOW
    ==================================================

The complete UI state flow should be:

STATE 1

Upload Document
↓
Select File
↓
Upload & Process / Cancel

STATE 2

Processing
↓
Extract Text
↓
Chunk Document
↓
Generate Embeddings
↓
Store Vectors

STATE 3

Document Ready
↓
Ask Question

STATE 4

Searching Document
↓
Retrieve Relevant Chunks
↓
Generate Answer

STATE 5

Display Answer
↓
Display Sources
↓
Ask Another Question

The user should be able to ask unlimited questions about the currently uploaded document.

==================================================
18. COMPONENT STRUCTURE
    ==================================================

Create reusable Flutter widgets/components such as:

AppShell
AppHeader
DocumentUploadCard
FileDropZone
SelectedFileCard
UploadProgress
ProcessingStatus
DocumentReadyCard
QuestionSection
QuestionInput
SuggestionChips
ThinkingIndicator
ChatMessage
AnswerCard
SourceSection
SourceCard
DocumentInfoCard
ErrorBanner
EmptyState
NewDocumentButton

Keep business logic separate from UI.

Use proper Flutter architecture such as:

presentation/
domain/
data/

Do not put API calls directly inside UI widgets.

==================================================
19. BACKEND API READY
    ==================================================

Design the frontend so it can later connect to a Spring Boot REST API.

Expected APIs:

POST   /api/v1/documents
GET    /api/v1/documents/{id}
GET    /api/v1/documents/{id}/status

POST   /api/v1/questions
GET    /api/v1/questions/{id}

The frontend should use a service/repository layer for API communication.

Do not hardcode fake backend logic into UI components.

Initially, mock API responses can be used if backend APIs are not implemented yet.

==================================================
20. FINAL UX GOAL
    ==================================================

The final application should feel similar to a modern AI document assistant.

The user experience should be:

1. Open application
2. See a beautiful upload screen
3. Upload PDF/DOCX/TXT
4. See processing progress
5. Receive "Document Ready"
6. Question section smoothly appears
7. Ask a question
8. See AI thinking/loading state
9. Receive formatted answer
10. See RAG sources below the answer
11. Ask follow-up questions
12. Upload another document when needed

Make the final UI polished enough to be used as a portfolio project and demonstrated in a technical interview.