# Hagar the Horrible Commodore 64 Source Code

Extract of the "Haggar the Horrible Commodore 64" game source code.

The code has been released in 2021 in a not very accessible format (source files are in Turbo Assembler binary format, stored in a `D64` image file); I've extracted and processed the files, so that the source files can be easily studied in plaintext.

## Source

Internet archive: https://archive.org/details/hagar-the-horrible-c-64-kingsoft-1992-source-code.-7z

## Original release content

The released image includes a few files:

- `H_BACK1.D64`  : the original German version
- `H_BACK2.D64`  : the original English version
- `H_DEMO1.D64`  : two demos released for publicity
- `HAG_SRC1.D64` : the game's source code
- `HAG_SRC2.D64` : the compiled game's source code

This files are in the directory `released_files`.

## Extracting the data

### Extract the TASM binary files from the disk image

Install VICE, then run this bash script:

```sh
# Skip disk header and free blocks lines.
#
files_list=$(c1541 HAG_SRC1.D64 -dir | head -n -1 | tail -n +2 | perl -lne 'print "$1 $2" if /"(.+)" +(\w+) $/')

while IFS= read -r file_entry; do
  filename=${file_entry% *}
  extension=${file_entry#* }

  output_file=$filename.$extension

  if [[ $extension == seq ]]; then
    filename=$filename,s
  fi

  c1541 HAG_SRC1.D64 -read "$filename" "$output_file"
done <<< "$files_list"
```

Note that the above won't work if the filenames include odd characters.

Watch out! c1541 does _not_ exit with error when a file can't be read, so one must parse the output (either manually or programmatically) in order to ensure that the operation succeeded.

### Convert binary Turbo Assembler source to human-readable files

Install [TMPview](https://style64.org/release/tmpview-v1.3.1-style), and run:

```sh
for f in *.prg; do
  tmpview "$f" > "${f%.prg}".asm
done

petcat undwarf.r.seq > undwarf.r.asm
```

The SEQ file is human-readable already, but it's PETSCII-encoded; `petcat` is a tool included with VICE.

## Notes

The character's name is actually "Hägar", not "Hagar" 🤓
