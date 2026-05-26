"""Minimal Markdown -> HTML converter for HouseKeep legal docs.

Handles: headings, paragraphs, bold, italic, inline code, links, lists,
tables, horizontal rules, fenced code blocks. Enough for legal markdown.

Usage:
    python3 tools/md_to_html.py
Output: docs/legal/*.html  (one per .md, plus style.css)
"""
from __future__ import annotations

import html
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
LEGAL_DIR = ROOT / "docs" / "legal"

CSS = """
body { max-width: 760px; margin: 2rem auto; padding: 0 1.2rem;
       font: 16px/1.6 -apple-system, BlinkMacSystemFont, "Segoe UI",
       system-ui, sans-serif; color: #1a1a1a; background: #fafaf8; }
h1 { color: #2E7D6F; border-bottom: 2px solid #2E7D6F; padding-bottom: .4rem;
     font-size: 2rem; }
h2 { color: #2E7D6F; margin-top: 2.2rem; font-size: 1.4rem; }
h3 { margin-top: 1.6rem; font-size: 1.1rem; }
a { color: #2E7D6F; }
code { background: #efece4; padding: 2px 6px; border-radius: 4px;
       font-family: "SF Mono", Menlo, Consolas, monospace; font-size: .92em; }
pre code { display: block; padding: 1rem; overflow-x: auto; }
table { border-collapse: collapse; width: 100%; margin: 1rem 0; }
th, td { border: 1px solid #d6d3c4; padding: 8px 12px; text-align: left;
         font-size: .95rem; }
th { background: #efece4; }
hr { border: none; border-top: 1px solid #d6d3c4; margin: 2rem 0; }
ul, ol { padding-left: 1.6rem; }
li { margin: .3rem 0; }
.footer { margin-top: 3rem; padding-top: 1rem; border-top: 1px solid #d6d3c4;
          font-size: .85rem; color: #6b6b6b; }
""".strip()

TITLES = {
    "privacy_en.md": "HouseKeep — Privacy Policy",
    "privacy_es.md": "HouseKeep — Política de Privacidad",
    "terms_en.md": "HouseKeep — Terms of Use",
    "terms_es.md": "HouseKeep — Términos de Uso",
}


def inline(text: str) -> str:
    def link_sub(m: re.Match[str]) -> str:
        label = html.escape(m.group(1))
        url = html.escape(m.group(2), quote=True)
        return f'<a href="{url}">{label}</a>'

    code_spans: list[str] = []

    def code_sub(m: re.Match[str]) -> str:
        code_spans.append(html.escape(m.group(1)))
        return f"\x00C{len(code_spans) - 1}\x00"

    text = re.sub(r"`([^`]+)`", code_sub, text)

    links: list[str] = []

    def linkx(m: re.Match[str]) -> str:
        links.append(link_sub(m))
        return f"\x00L{len(links) - 1}\x00"

    text = re.sub(r"\[([^\]]+)\]\(([^)]+)\)", linkx, text)

    text = html.escape(text)

    text = re.sub(r"\*\*([^*]+)\*\*", r"<strong>\1</strong>", text)
    text = re.sub(r"(?<!\*)\*([^*]+)\*(?!\*)", r"<em>\1</em>", text)

    text = re.sub(r"\x00C(\d+)\x00", lambda m: f"<code>{code_spans[int(m.group(1))]}</code>", text)
    text = re.sub(r"\x00L(\d+)\x00", lambda m: links[int(m.group(1))], text)
    return text


def convert(md: str) -> str:
    out: list[str] = []
    lines = md.splitlines()
    i = 0
    in_list = False
    list_tag = ""

    def close_list() -> None:
        nonlocal in_list
        if in_list:
            out.append(f"</{list_tag}>")
            in_list = False

    while i < len(lines):
        line = lines[i].rstrip()

        if not line.strip():
            close_list()
            i += 1
            continue

        m = re.match(r"^```(\w*)$", line)
        if m:
            close_list()
            lang = m.group(1)
            code: list[str] = []
            i += 1
            while i < len(lines) and not re.match(r"^```$", lines[i]):
                code.append(lines[i])
                i += 1
            i += 1
            cls = f' class="lang-{lang}"' if lang else ""
            out.append(f"<pre><code{cls}>{html.escape(chr(10).join(code))}</code></pre>")
            continue

        if re.match(r"^---+$", line):
            close_list()
            out.append("<hr />")
            i += 1
            continue

        m = re.match(r"^(#{1,6})\s+(.+)$", line)
        if m:
            close_list()
            level = len(m.group(1))
            out.append(f"<h{level}>{inline(m.group(2))}</h{level}>")
            i += 1
            continue

        if "|" in line and i + 1 < len(lines) and re.match(r"^\s*\|?\s*:?-+:?\s*(\|\s*:?-+:?\s*)+\|?\s*$", lines[i + 1]):
            close_list()
            headers = [c.strip() for c in line.strip().strip("|").split("|")]
            out.append("<table><thead><tr>")
            for h in headers:
                out.append(f"<th>{inline(h)}</th>")
            out.append("</tr></thead><tbody>")
            i += 2
            while i < len(lines) and "|" in lines[i] and lines[i].strip():
                cells = [c.strip() for c in lines[i].strip().strip("|").split("|")]
                out.append("<tr>")
                for c in cells:
                    out.append(f"<td>{inline(c)}</td>")
                out.append("</tr>")
                i += 1
            out.append("</tbody></table>")
            continue

        m = re.match(r"^[-*+]\s+(.+)$", line)
        if m:
            if not in_list or list_tag != "ul":
                close_list()
                out.append("<ul>")
                in_list = True
                list_tag = "ul"
            out.append(f"<li>{inline(m.group(1))}</li>")
            i += 1
            continue

        m = re.match(r"^\d+\.\s+(.+)$", line)
        if m:
            if not in_list or list_tag != "ol":
                close_list()
                out.append("<ol>")
                in_list = True
                list_tag = "ol"
            out.append(f"<li>{inline(m.group(1))}</li>")
            i += 1
            continue

        close_list()
        para = [line]
        i += 1
        while i < len(lines) and lines[i].strip() and not re.match(
            r"^(#{1,6}\s|```|---+$|[-*+]\s|\d+\.\s)|^.*\|.*$", lines[i]
        ):
            para.append(lines[i].rstrip())
            i += 1
        joined = " ".join(p.strip() for p in para)
        out.append(f"<p>{inline(joined)}</p>")

    close_list()
    return "\n".join(out)


def wrap(title: str, body: str) -> str:
    lang = "es" if title.endswith(("Privacidad", "Uso")) else "en"
    return f"""<!doctype html>
<html lang="{lang}">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1" />
<title>{html.escape(title)}</title>
<link rel="stylesheet" href="style.css" />
</head>
<body>
{body}
<div class="footer">HouseKeep · <a href="https://github.com/Darumo92/housekeep-legal">source</a></div>
</body>
</html>
"""


def main() -> int:
    if not LEGAL_DIR.exists():
        print(f"ERROR: {LEGAL_DIR} not found", file=sys.stderr)
        return 1

    (LEGAL_DIR / "style.css").write_text(CSS + "\n", encoding="utf-8")
    print(f"wrote {LEGAL_DIR / 'style.css'}")

    for md_path in sorted(LEGAL_DIR.glob("*.md")):
        if md_path.name == "README.md":
            continue
        title = TITLES.get(md_path.name, md_path.stem)
        body = convert(md_path.read_text(encoding="utf-8"))
        html_path = md_path.with_suffix(".html")
        html_path.write_text(wrap(title, body), encoding="utf-8")
        print(f"wrote {html_path}")

    index_body = """
<h1>HouseKeep — Legal</h1>
<p>Policies for the <strong>HouseKeep</strong> mobile app.</p>
<ul>
<li><a href="privacy_en.html">Privacy Policy (English)</a></li>
<li><a href="privacy_es.html">Política de Privacidad (Español)</a></li>
<li><a href="terms_en.html">Terms of Use (English)</a></li>
<li><a href="terms_es.html">Términos de Uso (Español)</a></li>
</ul>
""".strip()
    (LEGAL_DIR / "index.html").write_text(wrap("HouseKeep — Legal", index_body), encoding="utf-8")
    print(f"wrote {LEGAL_DIR / 'index.html'}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
