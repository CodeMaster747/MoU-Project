# MoU Management & Outcome Feedback Tracking (Rails)

Rails app to manage MoUs (Memorandum of Understanding), track outcomes for each MoU, and collect outcome feedback.

## Prerequisites

- Ruby (see [.ruby-version](file:///Users/rahulakshath/Documents/Rahul/SSN/Assignments%20Sem%20VI/Web%20Programming%20Project/MoU/mou_management/.ruby-version))
- Bundler

## Setup

```bash
bundle install
bin/rails db:create db:migrate
bin/rails db:seed
```

## Run

```bash
bin/rails server
```

Open http://localhost:3000/

## Demo flow

- Import Excel dataset: Navbar → Import → Import Default Dataset (uses [data/Overall MoU list.xlsx](file:///Users/rahulakshath/Documents/Rahul/SSN/Assignments%20Sem%20VI/Web%20Programming%20Project/MoU/mou_management/data/Overall%20MoU%20list.xlsx))
- Create MoU manually: Navbar → MoUs → New MoU
- Add outcomes: open a MoU → Add Outcome
- Add feedback: open an Outcome → Add Feedback
- Edit/Delete records: available on each page
- Automatic MoU status: Pending / Active / Expired based on dates
- Analytics: Navbar → Analytics

## Test

```bash
bin/rails test
```
