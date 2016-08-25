#!/bin/zsh

for FILE in svg/*.svg; do
    NOEXTNAME=${FILE:r}
    inkscape -z --verb=FitCanvasToDrawing --verb=FileSave --verb=FileClose $FILE
    inkscape $FILE --export-png=$NOEXTNAME.png --export-area-drawing -w1024
done
