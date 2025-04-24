#!/usr/bin/env python3
import os
import sys

def dump_lib_contents(output_path="files_contents.txt"):
    root_dir = os.getcwd()
    lib_dir = os.path.join(root_dir, 'lib')
    if not os.path.isdir(lib_dir):
        print(f"Error: could not find a 'lib' folder at {lib_dir}")
        sys.exit(1)

    with open(output_path, 'w', encoding='utf-8') as out:
        for dirpath, dirnames, filenames in os.walk(lib_dir):
            for filename in sorted(filenames):
                file_path = os.path.join(dirpath, filename)
                # compute a relative path from project root
                rel_path = os.path.relpath(file_path, root_dir)
                out.write(f"{'='*10} {rel_path} {'='*10}\n")
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        out.write(f.read())
                except Exception as e:
                    out.write(f"<Could not read file: {e}>\n")
                out.write("\n\n")
    print(f"Wrote all lib/ files to {output_path}")

if __name__ == "__main__":
    dump_lib_contents()
