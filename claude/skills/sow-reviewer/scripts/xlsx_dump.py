"""Dump every sheet of an .xlsx as text: cell address, cached value and formula.

Standard library only (openpyxl is usually not installed). Run it isolated:

    python3 -I xlsx_dump.py <file.xlsx> [--formulas-only]

Output: one block per sheet (hidden state noted), one line per non-empty row,
cells as ADDR:value, formulas as ADDR:value{=formula}. Also lists hidden sheets,
hidden rows/columns, merged cells and defined names, because hidden or hardcoded
totals are exactly what an LOE check must catch.
"""
import re
import sys
import zipfile
import xml.etree.ElementTree as ET

NS = {"m": "http://schemas.openxmlformats.org/spreadsheetml/2006/main",
      "r": "http://schemas.openxmlformats.org/officeDocument/2006/relationships"}
M = "{%s}" % NS["m"]


def shared_strings(z):
    if "xl/sharedStrings.xml" not in z.namelist():
        return []
    root = ET.fromstring(z.read("xl/sharedStrings.xml"))
    return ["".join(t.text or "" for t in si.iter(M + "t"))
            for si in root.findall("m:si", NS)]


def sheet_paths(z):
    wb = ET.fromstring(z.read("xl/workbook.xml"))
    rels = ET.fromstring(z.read("xl/_rels/workbook.xml.rels"))
    target = {r.get("Id"): r.get("Target") for r in rels}
    out = []
    for s in wb.find("m:sheets", NS):
        rid = s.get("{%s}id" % NS["r"])
        path = target[rid].lstrip("/")
        out.append((s.get("name"), s.get("state", "visible"),
                    path if path.startswith("xl/") else "xl/" + path))
    names = [(d.get("name"), d.text) for d in
             (wb.find("m:definedNames", NS) or [])]
    return out, names


def main(path, formulas_only=False):
    z = zipfile.ZipFile(path)
    strings = shared_strings(z)
    sheets, names = sheet_paths(z)
    for name, state, sp in sheets:
        root = ET.fromstring(z.read(sp))
        dim = root.find("m:dimension", NS)
        print("===== %s [%s] %s" % (name, state,
                                    dim.get("ref") if dim is not None else ""))
        hidden_cols = [c.get("min") + "-" + c.get("max")
                       for c in root.iter(M + "col") if c.get("hidden") == "1"]
        if hidden_cols:
            print("HIDDEN COLUMNS:", hidden_cols)
        merged = [m.get("ref") for m in root.iter(M + "mergeCell")]
        if merged:
            print("MERGED:", merged[:40])
        for row in root.iter(M + "row"):
            cells = []
            for c in row.findall("m:c", NS):
                v, f = c.find("m:v", NS), c.find("m:f", NS)
                if c.get("t") == "s" and v is not None:
                    val = strings[int(v.text)]
                elif c.get("t") == "inlineStr":
                    val = "".join(t.text or "" for t in c.iter(M + "t"))
                else:
                    val = v.text if v is not None else ""
                if formulas_only and f is None:
                    continue
                txt = c.get("r") + ":" + val[:80]
                if f is not None:
                    txt += "{=%s}" % (f.text or "(shared)")
                if val != "" or f is not None:
                    cells.append(txt)
            if cells:
                flag = " [HIDDEN ROW]" if row.get("hidden") == "1" else ""
                print("r%s%s | %s" % (row.get("r"), flag, " | ".join(cells)))
    if names:
        print("DEFINED NAMES:", names)


if __name__ == "__main__":
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    if not args:
        sys.exit(__doc__)
    main(args[0], "--formulas-only" in sys.argv)
