# Week 3 - Streams, Pipes, and Heredoc

## Why This Matters
Linux power comes from connecting simple tools through pipelines.
1 command ka output doosre command ka input ban jata hai.
- Pipeline is like assembly line in factory.
- Har tool apna kaam karta hai, final output clean milta hai.

## Files in This Week
- `demo_app.log`: sample application log.
- `unique_errors_pipeline.sh`: grep + awk + sort + uniq pipeline.
- `heredoc_demo.sh`: example of Heredoc for multi-line text.

## Run Pipeline Script
```bash
chmod +x unique_errors_pipeline.sh
./unique_errors_pipeline.sh
```

## Run Heredoc Script
```bash
chmod +x heredoc_demo.sh
./heredoc_demo.sh
cat app.conf
```

## Why in Simple Terms
When logs are huge, manually reading is slow.
Pipeline approach helps you quickly answer:
- "Kaunse errors repeat ho rahe hain?"
- "Most common failure kya hai?"

This skill is essential for DevOps, production debugging, and incident response.
