#!/bin/zsh

for FILE in images/*.svg; do
    NOEXTNAME=${FILE:r}
    #inkscape -D -z --file="${FILE}" --export-pdf="${NOEXTNAME}.pdf" --export-latex
    inkscape -z --verb=FitCanvasToDrawing --verb=FileSave --verb=FileClose $FILE
    inkscape $FILE --export-png=$NOEXTNAME.png --export-area-drawing -w1024
done
