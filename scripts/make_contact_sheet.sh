#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="$ROOT_DIR/store-assets/screenshots"
CONTACT="$OUT_DIR/contact-sheet.jpg"

if command -v magick >/dev/null 2>&1; then
  magick montage \
    "$OUT_DIR/en/home.png" "$OUT_DIR/en/add.png" "$OUT_DIR/en/detail.png" "$OUT_DIR/en/people.png" "$OUT_DIR/en/settings.png" \
    "$OUT_DIR/zh-Hans/home.png" "$OUT_DIR/zh-Hans/add.png" "$OUT_DIR/zh-Hans/detail.png" "$OUT_DIR/zh-Hans/people.png" "$OUT_DIR/zh-Hans/settings.png" \
    -label '%d/%t' -geometry 220x476+12+36 -tile 5x2 -background '#f7f2ea' "$CONTACT"
  echo "$CONTACT"
  exit 0
fi

swift - "$OUT_DIR" "$CONTACT" <<'SWIFT'
import AppKit
import Foundation

let args = CommandLine.arguments
let root = URL(fileURLWithPath: args[1])
let output = URL(fileURLWithPath: args[2])
let names = ["home", "add", "detail", "people", "settings"]
let langs = ["en", "zh-Hans"]
let thumbSize = NSSize(width: 220, height: 476)
let padding: CGFloat = 28
let labelHeight: CGFloat = 32
let width = padding + CGFloat(names.count) * (thumbSize.width + padding)
let height = padding + CGFloat(langs.count) * (thumbSize.height + labelHeight + padding)

let image = NSImage(size: NSSize(width: width, height: height))
image.lockFocus()
NSColor(calibratedRed: 0.965, green: 0.935, blue: 0.885, alpha: 1).setFill()
NSRect(origin: .zero, size: image.size).fill()

let attributes: [NSAttributedString.Key: Any] = [
    .font: NSFont.systemFont(ofSize: 16, weight: .semibold),
    .foregroundColor: NSColor(calibratedRed: 0.145, green: 0.164, blue: 0.18, alpha: 1)
]

for (row, lang) in langs.enumerated() {
    for (column, name) in names.enumerated() {
        let file = root.appending(path: lang).appending(path: "\(name).png")
        guard let source = NSImage(contentsOf: file) else { continue }
        let x = padding + CGFloat(column) * (thumbSize.width + padding)
        let y = image.size.height - padding - CGFloat(row + 1) * (thumbSize.height + labelHeight + padding) + padding
        let rect = NSRect(x: x, y: y + labelHeight, width: thumbSize.width, height: thumbSize.height)
        source.draw(in: rect)
        "\(lang)/\(name)".draw(in: NSRect(x: x, y: y, width: thumbSize.width, height: labelHeight), withAttributes: attributes)
    }
}

image.unlockFocus()

guard let tiff = image.tiffRepresentation,
      let bitmap = NSBitmapImageRep(data: tiff),
      let data = bitmap.representation(using: .jpeg, properties: [.compressionFactor: 0.86]) else {
    fatalError("Unable to render contact sheet")
}

try data.write(to: output)
print(output.path)
SWIFT
