# Linux Practical Assignments (5-Week Long)

This workspace is organized as a practical, progressive Linux learning path.
Each week focuses on one core system skill and explains not only "how" but also "why".

## Folder Structure
- `week_1_filesystem`
- `week_2_processes`
- `week_3_streams`
- `week_4_text_networking`
- `week_5_automation`

## Week-by-Week Summary

### Week 1 - Filesystem (Inodes, Links, Permissions)
- Deliverables:
  - `inode_link_demo.sh`
  - Week README with concept explanation
- Why:
  - Understand how Linux actually tracks files using inodes.
  - Avoid confusion between filename and file identity.
  - Hard Link: "Ek hi bande ke do naam (Nicknames)"
  - Soft Link: "Ghar ka address ek parchi pe likhna (Shortcut)."

### Week 2 - Processes and 
- Deliverables:
  - `process_signals_demo.sh`
  - Commands reference for `ps`, `top`, `lsof`
- Why:
  - Process visibility and safe process control are essential for debugging.
  - Learn when to request stop (`SIGINT`) vs force stop (`SIGKILL`).

  - `ps` = attendance list, `top` = live CCTV, `lsof` = file detective.

### Week 3 - Streams, Pipes, and 
- Deliverables:
  - `demo_app.log`
  - `unique_errors_pipeline.sh`
  - `heredoc_demo.sh`
- Why:
  - Unix power is chaining small tools into one smart pipeline.
  - Fast extraction of repeating errors from logs.

  - Pipeline is like factory assembly line: each step adds value.

### Week 4 - Text and Data Processing
- Deliverables:
  - `log_analyzer.sh` (last-hour error filter)
  - `data_processor.sh` (CSV averages via awk)
  - sample `app.log`, `metrics.csv`
- Why:
  - Real systems produce continuous logs and metrics.
  - Quick parsing means faster root-cause analysis.

  - Analyze only fresh complaints, not old closed tickets.

### Week 5 - Automation and Build Basics
- Deliverables:
  - `src/hello.c`
  - `build.sh` using `set -e` and `set -o pipefail`
- Why:
  - Repeatable automation reduces human error.
  - One command build improves team consistency.

  - Scripted build is fixed recipe card; manual build is memory-based cooking.

## Quick Start
Run these from Linux shell inside each week folder:
```bash
chmod +x *.sh
```
Then execute the required script for that week.

## Best Practices Included
- All scripts use `#!/bin/bash`.
- Defensive shell options (`set -euo pipefail` where appropriate).
- Clear inline comments for learning and maintenance.
- Input file checks before processing.

## Suggested Learning Flow
1. Start with Week 1 and run every script once.
2. Read each weekly README before moving ahead.
3. Modify sample files (logs/CSV) and rerun scripts to observe behavior changes.
4. In Week 5, extend `hello.c` and rebuild to practice automation cycle.
