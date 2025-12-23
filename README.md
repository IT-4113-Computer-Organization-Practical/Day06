# 📚 MIPS Assembly - Day 06 Guide

Easy-to-memorize MIPS assembly programs with examples! 🚀

---

## 📋 Table of Contents

1. [prog01.asm](#-prog01asm---function-with-5-arguments) - Function with 5 Arguments
2. [prog02.asm](#-prog02asm---add-5-numbers-alternative) - Add 5 Numbers (Alternative)
3. [prog03.asm](#-prog03asm---string-inputoutput) - String Input/Output

---

## 🔢 prog01.asm - Function with 5 Arguments

**What it does:** Passes 5 numbers to a function and adds them up!

### 🎯 Key Concept: **Stack for Extra Arguments**

- First 4 args → `$a0, $a1, $a2, $a3` ✅
- 5th arg → **Stack** 📦

### 💡 Memory Trick:

> **"4 in registers, rest on stack!"** 🎒

### 📝 Code Flow:

```
1. Put 100-103 in $a0-$a3           🎯 First 4 args
2. Push 104 to stack                📦 5th arg on stack
3. Call addition function           📞
4. Function reads 5th from stack    📖
5. Add all 5 numbers                ➕
6. Return result in $v0             ✅
```

**Result:** 100 + 101 + 102 + 103 + 104 = **510** 🎉

### 💻 Code:

```assembly
    .text
    .globl main

main:
    li $a0, 100
    li $a1, 101
    li $a2, 102
    li $a3, 103          # ⭐ First 4 args in $a0-$a3

    addi $sp, $sp, -4    # ⭐ IMPORTANT: Make space on stack
    li $t0, 104
    sw $t0, 0($sp)       # ⭐ IMPORTANT: Store 5th arg on stack

    jal addition
    addi $sp, $sp 4

    move $a0, $v0
    li $v0, 1
    syscall
    li $v0, 10
    syscall

addition:
    addi $sp, $sp, -8
    sw $ra, 4($sp)       # ⭐ IMPORTANT: Save return address

    lw $t0, 8($sp)       # ⭐ IMPORTANT: Load 5th arg (offset = 8 because we added 8 bytes)

    add $t1, $a0, $a1
    add $t1, $t1, $a2
    add $t1, $t1, $a3
    add $v0, $t1, $t0    # Result in $v0

    lw $ra, 4($sp)       # ⭐ IMPORTANT: Restore return address
    addi $sp, $sp, 8
    jr $ra
```

**🔑 Key Points:**

- 📦 **Stack offset 8:** Because we pushed 8 bytes (-8), the 5th arg is at 8($sp)
- 💾 **Save $ra:** Always save return address before calling functions
- ➕ **Result in $v0:** Functions return values in $v0

---

## 🔄 prog02.asm - Add 5 Numbers (Alternative)

**What it does:** Same as prog01 but with cleaner stack management!

### 🎯 Key Concept: **Save Return Address First**

```
Stack Layout:
[Return Address]  ← 0($sp)  📌 Save $ra first!
[5th Argument]    ← 4($sp)  📦 Then 5th arg
```

### 💡 Memory Trick:

> **"RA before data!"** 💾

### 📝 Code Flow:

```
1. Make space on stack (8 bytes)    📦📦
2. Save $ra at 0($sp)                💾
3. Load 100-104 into temp regs       🔢
4. Move first 4 to $a0-$a3           ➡️
5. Put 5th on stack at 4($sp)        📦
6. Call add5 function                📞
7. Function adds all 5               ➕
8. Restore $ra and return            ✅
```

**Result:** 100 + 101 + 102 + 103 + 104 = **510** 🎉

### 💻 Code:

```assembly
    .text

main:
    sub $sp, $sp, 8      # ⭐ IMPORTANT: Allocate 8 bytes (for $ra + 5th arg)
    sw $ra, 0($sp)       # ⭐ IMPORTANT: Save $ra at 0($sp)

    li $t0, 100
    li $t1, 101
    li $t2, 102
    li $t3, 103
    li $t4, 104

    move $a0, $t0
    move $a1, $t1
    move $a2, $t2
    move $a3, $t3        # First 4 args

    sw $t4, 4($sp)       # ⭐ IMPORTANT: 5th arg at 4($sp)

    jal add5
    move $a0, $v0
    li $v0, 1
    syscall

    lw $ra, 0($sp)       # ⭐ IMPORTANT: Restore $ra
    addi $sp, $sp, 8
    jr $ra

add5:
    lw $t0, 4($sp)       # ⭐ IMPORTANT: Read 5th arg from 4($sp)

    add $v0, $a0, $a1
    add $v0, $v0, $a2
    add $v0, $v0, $a3
    add $v0, $v0, $t0    # Result in $v0

    jr $ra
```

**🔑 Key Points:**

- 📌 **Stack Layout:** 0($sp) = $ra, 4($sp) = 5th arg
- 🎯 **Offset 4:** 5th arg is at offset 4 from stack pointer
- ✅ **Simpler:** Function doesn't save $ra (doesn't call other functions)

---

## 📝 prog03.asm - String Input/Output

**What it does:** Read a string and print each character on a new line!

### 🎯 Key Concept: **String = Array of Chars**

- Strings end with **null byte (0)** 🛑
- Loop until you hit 0!

### 💡 Memory Trick:

> **"Load Byte, Check Zero, Print, Move Next!"** 🔄

### 📝 Code Flow:

```
1. Read string (syscall 8)           ⌨️ Input
2. Print whole string (syscall 4)    📄 Full output
3. Loop through each character:      🔄
   - Load byte (lb)                  📖
   - Check if zero → done?           🛑
   - Print char (syscall 11)         🔤
   - Print newline                   ⬇️
   - Move to next byte               ➡️
4. Repeat until null byte            🔁
```

### 📌 Example:

**Input:** `Hello` ⌨️

**Output:**

```
Hello
H
e
l
l
o
```

### 💻 Code:

```assembly
    .text

main:
    li $v0, 8
    la $a0, string1
    li $a1, 100
    syscall              # ⭐ IMPORTANT: Read string (syscall 8)

    li $v0, 4
    la $a0, string1
    syscall              # Print entire string

    move $t0, $a0        # ⭐ IMPORTANT: $t0 = pointer to string

loop:
    lb $t1, 0($t0)       # ⭐ IMPORTANT: Load byte at pointer
    beq $t1, $zero, done # ⭐ IMPORTANT: Check if null (0) = end of string

    li $v0, 11
    move $a0, $t1
    syscall              # Print character

    li $v0, 4
    la $a0, newline
    syscall              # Print newline

    add $t0, $t0, 1      # ⭐ IMPORTANT: Move to next byte
    j loop

done:
    jr $ra

    .data
string1:    .space 100
newline:    .asciiz "\n"
```

**🔑 Key Points:**

- 📖 **lb (Load Byte):** Loads one character at a time
- 🛑 **Check for 0:** Strings end with null byte (0)
- ➡️ **Pointer:** Increment by 1 to move to next character
- 🔄 **Loop:** Repeat until null byte found

---

---

## 🎓 Quick Reference Card

### 📞 Syscall Cheat Sheet

| Code | Function     | Description        |
| ---- | ------------ | ------------------ |
| 1    | print_int    | Print integer 🔢   |
| 4    | print_string | Print string 📝    |
| 8    | read_string  | Read string ⌨️     |
| 11   | print_char   | Print character 🔤 |
| 10   | exit         | Exit program 🚪    |

### 📦 Register Guide

| Register  | Use            | Emoji |
| --------- | -------------- | ----- |
| `$a0-$a3` | Arguments 1-4  | 🎯    |
| `$v0-$v1` | Return values  | ✅    |
| `$t0-$t9` | Temporary      | ⏱️    |
| `$sp`     | Stack pointer  | 📦    |
| `$ra`     | Return address | 🔙    |

### 🧮 Stack Operations

```
Push: addi $sp, $sp, -4    ⬇️ Down
      sw $reg, 0($sp)      💾 Save

Pop:  lw $reg, 0($sp)      📖 Load
      addi $sp, $sp, 4     ⬆️ Up
```

---

## 💡 Pro Tips

1. **Stack grows DOWN** ⬇️ → Use negative offsets to push!
2. **Always save $ra** 💾 → Before calling functions!
3. **Strings end at 0** 🛑 → Check for null byte!
4. **4 args max in regs** 🎯 → Rest go on stack!

---

## 🎯 Practice Exercises

1. ✏️ Modify prog01 to add **6 numbers**
2. ✏️ Change prog03 to count the string length
3. ✏️ Create a function that multiplies 5 numbers

---

**Happy Coding! 🚀💻**
