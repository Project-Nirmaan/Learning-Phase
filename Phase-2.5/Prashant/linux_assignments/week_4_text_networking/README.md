# Week 4 - Text Processing and Lightweight Log Analytics

## Why This Matters
Production systems generate logs and CSV metrics continuously.
Agar aap text quickly parse kar pao, to issue detection bahut fast ho jata hai.

## Files in This Week
- `log_analyzer.sh`: filters ERROR logs from the last hour.
- `data_processor.sh`: computes averages from a CSV using awk.
- `app.log`: sample log input file.
- `metrics.csv`: sample metrics data.

## Run Log Analyzer
```bash
chmod +x log_analyzer.sh
./log_analyzer.sh
```

## Run CSV Processor
```bash
chmod +x data_processor.sh
./data_processor.sh
```

## Why in Simple Hinglish
- Log analyzer is like checking only recent complaints in customer care, not old resolved tickets.
- CSV processor is like calculating class average marks quickly instead of manual calculator effort.

These are practical, interview-friendly skills for SRE, backend ops, and support automation.
