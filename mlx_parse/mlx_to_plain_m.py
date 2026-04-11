#!/usr/bin/env python3
"""Convert MATLAB .mlx files to plain-text live script .m files.

This script uses MATLAB's internal Live Editor conversion API:
    matlab.internal.liveeditor.openAndConvert(inputFile, outputFile)
"""

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path


def matlab_quote(path: Path) -> str:
    """Return a MATLAB single-quoted string literal for the given path."""
    return str(path).replace("'", "''")


def convert_one(input_file: Path, output_file: Path, matlab_cmd: str) -> tuple[bool, str]:
    """Convert one .mlx file to plain-text live script .m using MATLAB."""
    command = (
        "matlab.internal.liveeditor.openAndConvert("
        f"'{matlab_quote(input_file.resolve())}',"
        f"'{matlab_quote(output_file.resolve())}'"
        ");"
    )

    result = subprocess.run(
        [matlab_cmd, "-batch", command],
        capture_output=True,
        text=True,
    )

    if result.returncode == 0 and output_file.exists():
        return True, ""

    output = "\n".join(
        part for part in [result.stdout.strip(), result.stderr.strip()] if part
    )
    return False, output


def find_mlx_files(paths: list[Path], recursive: bool) -> list[Path]:
    """Collect .mlx files from input paths (files and/or directories)."""
    collected: list[Path] = []
    for path in paths:
        if not path.exists():
            continue
        if path.is_file() and path.suffix.lower() == ".mlx":
            collected.append(path)
            continue
        if path.is_dir():
            pattern = "**/*.mlx" if recursive else "*.mlx"
            collected.extend(sorted(path.glob(pattern)))

    # Keep order stable but remove duplicates.
    seen: set[Path] = set()
    unique: list[Path] = []
    for item in collected:
        resolved = item.resolve()
        if resolved in seen:
            continue
        seen.add(resolved)
        unique.append(item)
    return unique


def default_output_for(input_file: Path) -> Path:
    """Map file.mlx -> file.m in the same directory."""
    return input_file.with_suffix(".m")


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        prog="mlx_to_plain_m.py",
        description="Convert MATLAB .mlx files to plain-text live script .m files.",
    )
    parser.add_argument(
        "inputs",
        nargs="+",
        help="One or more .mlx files or directories containing .mlx files.",
    )
    parser.add_argument(
        "-o",
        "--output",
        help="Output .m path (only valid when converting exactly one input file).",
    )
    parser.add_argument(
        "-r",
        "--recursive",
        action="store_true",
        help="Recursively search directories for .mlx files.",
    )
    parser.add_argument(
        "--force",
        action="store_true",
        help="Overwrite output files if they already exist.",
    )
    parser.add_argument(
        "--matlab",
        default=os.environ.get("MATLAB_CMD", "matlab"),
        help="MATLAB executable command (default: MATLAB_CMD env var or 'matlab').",
    )
    return parser.parse_args()


def main() -> int:
    args = parse_args()

    input_paths = [Path(item).expanduser() for item in args.inputs]
    mlx_files = find_mlx_files(input_paths, recursive=args.recursive)

    if not mlx_files:
        print("No .mlx files found in provided inputs.", file=sys.stderr)
        return 1

    if args.output:
        if len(mlx_files) != 1 or not mlx_files[0].is_file():
            print(
                "--output is only valid when converting exactly one .mlx input file.",
                file=sys.stderr,
            )
            return 2
        outputs = [Path(args.output).expanduser()]
    else:
        outputs = [default_output_for(path) for path in mlx_files]

    failures = 0
    for input_file, output_file in zip(mlx_files, outputs):
        output_file.parent.mkdir(parents=True, exist_ok=True)

        if output_file.exists() and not args.force:
            print(f"SKIP  {output_file} (exists, use --force to overwrite)")
            continue

        print(f"CONVERT  {input_file} -> {output_file}")
        ok, details = convert_one(input_file, output_file, args.matlab)
        if ok:
            print(f"OK      {output_file}")
        else:
            failures += 1
            print(f"ERROR   {input_file}", file=sys.stderr)
            if details:
                print(details, file=sys.stderr)

    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())