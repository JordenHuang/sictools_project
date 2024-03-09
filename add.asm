. 註解是錯的，尚未修改
ss      START   0           . 程式的起始地址
        CLEAR   A
        LDA     VALUE1      . 將 VALUE1 裝載到累加器
. output the letter a
        JSUB	td
. output + sign
        LDA     plussign
        JSUB	td
. output offset
        LDA     offset
        ADD     #48
        JSUB	td
. output equal sign
        LDA     equalsign
        JSUB	td
        LDA     VALUE1
        ADD     offset      . 將 offset 加到累加器
        JSUB	td
. write newline
        LDA     newline
        JSUB	td
        J	ss
. halt	J	    halt

td	TD	stdout
        JEQ	td
        WD	stdout
        RSUB

        END     ss          . 程式的結束標記

VALUE1  WORD    97          . VALUE1 is letter a 定義 VALUE1 為一個 10 進制的數字
plussign WORD   43
equalsign WORD  61
offset  WORD    5           . offset is 5 定義 VALUE2 為一個 10 進制的數字
newline WORD    10
stdout  BYTE    X'01'       . 輸出設備的代碼
