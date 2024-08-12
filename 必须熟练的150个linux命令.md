线上查询及帮助命令
文件和目录操作命令
查看文件及内容处理命令
文件压缩及解压缩命令
信息显示命令
搜索文件命令
用户管理命令
基础网络操作命令
深入网络操作命令
有关磁盘与文件系统的命令
关机和查看系统信息的命令
系统管理相关命令
系统安全相关命令
查看系统用户登录信息的命令
其他
系统性能监视高级命令





## 线上查询及帮助命令

```
[root@m01 ~]# man ls
[root@m01 ~]# ls --help
info cp  
```
## 文件和目录操作命令

```bash
ls -lht --full-time  # l 长格式显示 h 人类可读显示  t 排序 --full-time 完整时间格式
cd  /
cd ~  # ~家目录
cd -  # 返回上一次目录位置   
cd ..  # . 当前目录  .. 上级目录


ln -s /bin/last lin/last  #创建软链接   
cp lin/last tmp/  #复制文件  cp [option]  source dest
cp -r tmp lin      # -r 递归复制目录及目录里所有文件
cp -a  === -pdr
-p  复制保持属性不变
-d  复制后的文件保持是软链接文件
-r   递归
----------------------
-i：交互式复制
-v：详细模式
-f：强制复制  如果目标文件已存在，会直接覆盖而不提示。


# find 起始目录 搜索条件 操作
# 按文件名搜索
find /home -name "*.txt"   
find /home -iname  "bilibili"     #-iname 不区分大小写

# 按文件类型搜索
-type d   #目录
-type f    #普通文件
-type l    #符号链接

# 按文件大小
-size +10M   # 大于10MB 文件
-size -5k    #小于5kb文件
-size 10k   # 正好10kb文件

# 按时间搜索 
-mtime n   #文件修改时间搜索, n表示天数, -mtime +7表示修改时间在7天前的文件, -mtime -1表示1天内修改的文件
-atime :  按访问时间修改
-ctime   按文件状态改变时间(如权限更改等)


# 操作
-exec command {} \;   对搜索到的文件执行指定的命令.
find . -name "*.txt" -exec rm {}\;   #删除当前目录与目录下所有扩展名.txt文件.
-print      默认操作,打印出来
-delete    直接删除搜索到的文件或目录

find /tmp -mtime +7 -type f -delete  #删除一周前的文件  /tmp目录下的
find /var/log -type f -size +1G  #找出大于1G的日志文件
find /data -name "*.bak" -exec cp {} /backup \; #找到.bak文件复制到/backup 目录下.


mkdir   #创建目录
mkdir [选项] 目录名  
-p   可以创建多级目录   
-v   显示创建过程详细信息

mkdir test_dir
mkdir -p a/b/c
mkdir backup_$(date +%Y%m%d)

mv  #移动或重命名 文件或目录
mv [选项] 源文件或目录 目标文件或目录
-i    #交互式
-f    #强制操作
-v   #显示详细记录

mv file.txt /home/user/backup      #移动文件
mv old_file.txt new_file.txt             #重命名
mv dir1 /home/user/destination   # 移动目录
mv *.log /backup/logs                   #批量移动文件

pwd    #打印当前工作目录绝对路径

rename  #批量重命名文件
rename [options] expression replacement file...
-v 显示详细信息
-s  更新符号链接的目标路径

touch {file1,file2,file3}.txt  #创建3个文件
rename -v file newfile *.txt
[root@m01 tmp]# rename -v file newfile *.txt
`file1.txt' -> `newfile1.txt'
`file2.txt' -> `newfile2.txt'
`file3.txt' -> `newfile3.txt'

rm    remove删除文件或目录
rm 文件名 
rm -r 目录名
-f   --force  强制删除
-i   --interactive   交互式删除
-r  -R  --recursive  递归删除目录及内容
-v  --verbose   显示详细操作信息

rmdir 是一个用于删除空目录的命令行工具。它是 "remove directory" 的缩写，
-p 或 --parents：删除指定目录及其上级目录，直到遇到非空目录为止。
-v 或 --verbose：显示每个删除目录的信息。


rmdir my_empty_directory 
rmdir -p my_empty_directory/sub_directory  # 删除一个空目录及其上级目录（如果它们也是空的）


touch  用于创建和更新文件的时间戳, 还可以创建空文件
touch [选项] 文件...
选项
-a 或 --time=ATIME：仅更新访问时间。
-m 或 --time=MTIME：仅更新修改时间。
-c 或 --no-create：如果文件已经存在，则不创建新文件。
-t 或 --timestamp=TIMESTAMP：设置文件的访问和修改时间为指定的时间和日期。
-d 或 --date=DATE：设置文件的访问和修改时间为指定的日期和时间。
-r 或 --reference=FILE：将指定文件的访问和修改时间复制到当前文件。


[root@m01 tmp]# stat file2
  File: ‘file2’
  Size: 0               Blocks: 0          IO Block: 4096   regular empty file
Device: fd00h/64768d    Inode: 33554510    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2024-08-12 16:28:21.438816399 +0800
Modify: 2024-08-12 16:28:21.438816399 +0800
Change: 2024-08-12 16:28:21.438816399 +0800
 Birth: -
[root@m01 tmp]# touch -d '2 weeks ago' file2  # # 设置文件时间为两周前的日期 

touch -am  file1
touch -c file1
[root@m01 tmp]# touch -d  "2023-09-20 15:30:00" file1  # Access Modify 时间被修改
touch -t 1905200520 file2    # 19年05月20号05点20分




[root@m01 tmp]# date +%s  #当前时间戳 
1723452299
[root@m01 tmp]# date -d "2023-09-20 15:30:00" +%s   #指定时间戳
1695195000
[root@m01 tmp]# # sudo date -s "2023-09-20 15:30:00"  #设置系统时间


tree  图形化展示目录结构和文件列表
tree [选项] [目录]
-a 或 --dirsfirst：先显示目录，后显示文件。
-d 或 --dirs：只显示目录。
-D 或 --dirstat：显示目录大小的统计信息。
-I PATTERN 或 --ignore=PATTERN：忽略与PATTERN匹配的文件和目录。
-L NUM 或 --max-depth=NUM：限制树的深度，最大为NUM。
-L NUM 或 --min-depth=NUM：最小显示深度，至少为NUM。
-P PATTERN 或 --prune=PATTERN：排除与PATTERN匹配的目录。
-s 或 --charset=CHARSET：设置字符集。
-u 或 --unique-directories：每个父目录只显示一次。
-v 或 --version：显示版本信息。
-F 或 --file-type：在文件类型后添加后缀。
-T 或 --tabsize=COLS：设置制表符宽度。

tree -d   只显示目录
tree -L 3    最大深度3

basename  从完整的文件路径中提取结尾 文件名或目录名
basename [OPTION]... [STRING]...
常用选项
-a：处理多个字符串，每个字符串都会被处理。
-s：指定分隔符，用于从路径中提取文件名或目录名。
-z：将输出结果用NUL字符分隔，而不是换行符。
[root@m01 tmp]# basename /usr/local/bin/python
python
[root@m01 tmp]# basename /usr/local/bin/
bin
[root@m01 tmp]# basename -a /usr/local/bin/python /usr/local/bin/
python
bin
[root@m01 tmp]# basename -s / /usr/local/bin/python
python


dirname  获取文件路径中目录部分(去除结尾的文件名)
#!/bin/bash
file_path="/home/user/data.txt"
dir_path=$(dirname "$file_path")
echo "文件所在目录为：$dir_path"   # /home/user

chattr  改变文件或目录的扩展属性
chattr [options] [mode] files
常用选项
-R：递归地对目录及其内容应用更改。
-V：显示命令的详细输出。
属性模式
+：添加属性。
-：移除属性。
=：设置属性
常用属性
a：仅追加模式。文件只能被追加内容，不能被删除或重命名。
i：不可变模式。文件或目录不能被删除、重命名、链接、写入或追加内容。
d：不可压缩模式。在使用 dump 命令备份文件系统时，该文件或目录将被忽略。
s：安全删除模式。当文件被删除时，其内容将被完全清除。
u：不可删除模式。如果文件被删除，其内容将被保存，以便之后可以恢复。

sudo chattr +i /etc/passwd #设置不可变属性
sudo chattr -i /etc/passwd  #移除不可变属性
lsattr /etc/passwd   #查看文件属性
lsattr -R /etc      #递归显示目录属性
lsattr -a /home  #显示所有文件和目录的属性


file  用于确定文件的类型
-b：仅输出文件类型信息，不包括文件名。
-f：从指定的文件中读取文件名列表。
-F：使用指定的分隔符来分隔文件名和文件类型信息。
-i：显示MIME类型。
-z：处理压缩文件。
[root@m01 tmp]# file file1
file1: ASCII text
[root@m01 tmp]# file -b file1
ASCII text
[root@m01 tmp]# file -i file1
file1: text/plain; charset=us-ascii
[root@m01 tmp]# file file1 file2
file1: ASCII text
file2: ASCII text


md5sum  计算和校验文件MD5值
MD5（Message-Digest Algorithm 5）是一种广泛使用的哈希函数，它将任意长度的数据计算为一个128位的哈希值（通常以32个十六进制字符表示）。
1 唯一性
2 不可逆
[root@m01 tmp]# md5sum file1 file2
d404401c8c6495b206fc35c95e55a6d5  file1
60b725f10c9c85c70d97880dfe8191b3  file2
```



## 查看文件及内容处理命令

```bash
cat  查看文件
cat file1 ; 
cat file1 file2
cat file1 file2 > merged.txt
cat -n file1   #显示行号
cat /dev/null > file.txt  #清空文件
#!/bin/bash

# 创建一个新文件并写入内容
#!/bin/bash
cat > new_script_file.txt << EOF
这是一个在脚本中使用 cat 创建的文件内容。
包含了多行信息。
EOF


tac  将文件内容反向输出
tac [OPTION]... [FILE]...
OPTION：可选参数，用于修改命令的行为。
FILE：要反向输出内容的文件。
常用选项
-b：在行之间添加空行。
-s：指定分隔符，用于分隔文件名。
-r：将反向输出视为正则表达式。
[root@m01 tmp]# cat file1
abc
123
456
[root@m01 tmp]# tac file1
456
123
abc


more  分页显示文件内容的命令
more  large_file.txt  # 这样在处理特别大的文件时，可能在内存使用效率上更有优势，因为它不需要一次性将整个文件加载到内存中。
交互操作  
    space  滚动一整页
	enter    滚动一行的内容
	q          退出



less #文件查看器，与more类似
less large_file.txt  
交互操作
	上下箭头
	空格和page down  下翻一页
	page up  上翻一页
	/ 搜索       /keyword  回车  n跳转下一个匹配项, N上一个
	q 退出
	
less file1 file2   #打开多文件 :n 切换到一下文件  :p 上一个文件



head  # 查看文件开头的部分文件内容
head file.txt # 默认前10行内容
head -n 行数 file.txt  



tail #查看文件尾部
tail file.txt  # 最后10行内容
tail -n 行数 file.txt  # 指定文件显示最后多少行
tail -f 文件名   #实时监控; 实时查看新添加到文件末尾的日志记录

tail -f access.log | grep "ERROR"  #观察新的访问记录和可能出现的错误信息。
tail -n 100 data.txt | awk '{sum+=$1} END {print sum}'  #计算文件最后 100 行中第一列数据的总和。

cut   #从文本文件或标准输入中提取特定的列或字段,
cut [OPTION]... [FILE]...
OPTION：可选参数，用于修改命令的行为。
FILE：要处理的文件。如果未指定文件，cut 将从标准输入读取数据。
常用选项
-d：指定分隔符。默认分隔符是制表符（\t）。
-f：指定要提取的字段编号。可以使用逗号分隔多个字段编号，或者使用范围（如3-5）。
-c：指定要提取的字符位置。可以使用逗号分隔多个字符位置，或者使用范围（如3-5）

cut -d, -f1,3 data.csv  #使用逗号分隔符,提取文件的第1列和第3列
cut -c1-5,10-15 data.txt  # 提取 data.txt 文件中第1到第5个字符和第10到第15个字符
cut -f2 file.txt   #文件的第二列。
echo "apple,banana,cherry" | cut -d, -f1




split # 将文件分割成多个较小文件
split [OPTION]... [INPUT [PREFIX]]
OPTION：可选参数，用于修改命令的行为。
INPUT：要分割的文件。如果未指定，split 将从标准输入读取数据。
PREFIX：指定输出文件的前缀。默认前缀是 x。

常用选项
-b, --bytes=SIZE：按字节大小分割文件。SIZE 可以是数字后跟单位（如 k、m、g）。
-l, --lines=NUMBER：按行数分割文件。NUMBER 是要分割成每个文件的行数。
-a, --suffix-length=LEN：指定输出文件后缀的长度，默认为2。
--verbose：显示详细信息，如每个生成的文件名。
不加参数 默认情况下它会按照每 1000 行（行结束符为\n）

 split -b 10k largefile.txt file_  # 每个文件大小为10KB，文件名前缀为 file_
 split -l 1000 bigfile.txt part_  # 每个文件包含1000行，文件名前缀为 part_。
 split -l 500 -a 3 bigfile.txt part_  # 每个文件包含500行，文件名前缀为 part_，后缀长度为3。
 
 
 #将一个大的数据库备份文件通过网络传输到另一个服务器，
 # 可以先在本地将其分割，然后逐块传输，
 tar -cf etc.tar /etc && split -b 10MB etc.tar etc_
 cat etc_* > etc2.tar  # 接收端再进行合并。
 
 # 结合scp和分割文件分发到不同节点
 split bigdata.txt smallpiece && for file in smallpiece*; do scp $file remote_node:$REMOTE_PATH; done
 
 # 计算每个分割文件的校验和，以便在数据恢复时进行验证。
 # 传输过程中出现部分数据损坏,就可以只传部分损坏的分割文件
[root@m01 tmp]# split file1 part_ && for f in part_*; do md5sum $f; done;
5ad6e1ebf4c1ce91a3af827c8301ed81  part_aa
.........
 
 
paste  # 将多个文件或标准输入的内容合并在一起
paste [OPTION]... [FILE]...
OPTION：可选参数，用于修改命令的行为。
FILE：要合并的文件。如果未指定文件，paste 将从标准输入读取数据。
常用选项
-d, --delimiters=LIST：指定分隔符列表。默认分隔符是制表符（\t）。
-s, --serial：串行地合并文件，而不是并行地。即一次只合并一个文件的行。
-：表示标准输入。

[root@m01 tmp]# echo "aa" > file1.txt;echo 'bb' > file2.txt
[root@m01 tmp]# paste file1.txt file2.txt
aa      bb
[root@m01 tmp]# paste -d',' file1.txt file2.txt
aa,bb
[root@m01 tmp]# echo "cc" > file3.txt
[root@m01 tmp]# paste file1.txt file2.txt file3.txt
aa      bb      cc
[root@m01 tmp]# paste -s file1.txt file2.txt file3.txt
aa
bb
cc
[root@m01 tmp]# echo "apple" | paste - file2.txt
apple   bb

# 生产常用
paste file1.txt file2.txt | awk '{print $1,$3}' # 从合并后的文件中提取第一列和第三列的数据。
#将多个相似配置文件的内容合并起来进行查看或修改。
#先对file1.cfg进行排序，然后与file2.cfg按制表符分隔合并
sort file1.cfg | paste -d '\t' - file2.cfg
# 将不同时间段的性能数据文件合并起来，生成一个综合的性能报告
# 将合并后的内容中的old替换为new，并保存到新的报告文件中。
paste data1.txt data2.txt | sed 's/old/new/g' > report.txt


sort # 文件内容或标准输入进行排序
常用选项
-r：逆序排序（降序）。
-k：指定排序的字段，字段从 1 开始计数。
-f：忽略大小写差异进行排序。
-n：按照数值大小进行排序。

sort file1.txt 
sort file1.txt > sorted_file.txt
sort -r file.txt  #排序翻转
sort -f file.txt   #排序不区分大小写字母
sort -k 2 file1.txt  # 默认按空格分割 按第二列字段排序
 sort -t ',' -k 2 data.txt  #指定用逗号分隔符,取第二字段排序
 
 
 
# 扩展
# 从一个逗号分隔的 CSV 文件中提取第二列（假设是用户ID）并进行排序。
cut -d ',' -f 2 data.csv | sort > sorted_ids.txt 
# 先过滤出包含"ERROR"的日志行，然后按日志中的时间字段（假设是第四列）进行排序。
grep "ERROR" access.log | sort -k 4
awk '{print $2}' data.txt | sort
cut -f 2 -d '\t' data.txt | sort  #取第二列  制表符\t作为分隔符, 后排序


uniq  # 用于报告或忽略文件中的重复行，通常与 sort 命令配合使用，因为它只能作用于相邻的重复行。
niq [选项] [输入文件 [输出文件]]。
常用选项
-c：在每行前显示该行重复出现的次数。
-d：只显示重复的行。
-u：只显示不重复的行。

[root@m01 tmp]# cat -n text.txt
     1  apple
     2  banana
     3  apple
     4  cherry
     5  banana
[root@m01 tmp]# sort text.txt | uniq -c  #显示重复次数
      2 apple
      2 banana
      1 cherry
[root@m01 tmp]# sort text.txt | uniq -d  #只显示有重复的行
apple
banana
[root@m01 tmp]# sort text.txt | uniq -u  #显示不重复的行
cherry
#显示每行内容及其重复次数并交换显示顺序。
[root@m01 tmp]# sort text.txt |uniq -c |awk '{print $2,$1}'
apple 2
banana 2
cherry 1



wc  （word count） 用于统计指定文件中的行数、单词数和字节数
wc [OPTION]... [FILE]...
OPTION：可选参数，用于修改命令的行为。
FILE：要统计的文件。如果未指定文件，wc 将从标准输入读取数据。
常用选项
-l：统计行数。
-w：统计单词数。
-c：统计字节数。
-m：统计字符数（适用于多字节字符集）。
-L：显示最长行的长度。

[root@m01 tmp]# wc text.txt
 5  5 33 text.txt  # 行数 单词数 字节数 文件名
 
wc -l text.txt
wc -w text.txt
wc -c text.txt

iconv # 用于在不同的字符编码之间转换文本文件
iconv [OPTION]... [-f FROM_ENCODING] [-t TO_ENCODING] [FILE]...
OPTION：可选参数，用于修改命令的行为。
-f FROM_ENCODING：指定输入文件的原始编码格式。
-t TO_ENCODING：指定输出文件的目标编码格式。
FILE：要转换编码的文件。如果未指定文件，iconv 将从标准输入读取数据。
常用选项
-l：列出所有支持的编码格式。
-c：忽略无法转换的字符，只输出可以转换的部分。
-s：静默模式，不输出错误信息。
--verbose：输出详细信息。
# 假设有一个文件 old.txt 使用的是 GBK 编码，
#  要将其转换为 UTF-8 编码并保存为新文件 new.txt：
iconv -f GBK -t UTF-8 old.txt > new.txt


dos2unix  # 于将DOS（Windows）格式的文本文件转换为Unix/Linux格式的文本文件
常用选项
-n：指定输出文件名，将转换后的内容保存到新文件中，而不是覆盖原文件。
-k：保留文件的日期和时间戳信息。
dos2unix example.txt  #单个文件转换为Unix格式：




file  # 用于确定文件类型
-b：简洁模式，只显示文件类型，省略文件名。
-i：显示 MIME 类型（互联网媒体类型）。例如，对于一个 JPEG 图片文件，可能会显示“image/jpeg”。
-f：从指定文件中读取文件名列表进行检测，而不是在命令行中直接指定文件。例如，创建一个名为filelist.txt的文件，其中包含要检测的文件列表，然后执行file -f filelist.txt。

[root@m01 tmp]# file text.txt
text.txt: ASCII text


diff # 用于比较两个文件或目录之间的差异。


[root@m01 tmp]# echo "this is file1" > file1
[root@m01 tmp]# echo "this is file2" > file2
[root@m01 tmp]# diff file1 file2
1c1
< this is file1
---
> this is file2
# -w或--ignore-all-space选项可以忽略空白字符（如空格、制表符等）的差异。
diff -w file1.txt file2.txt
# -i或--ignore-case选项 忽略大小写

# -r 递归比较目录
diff -r dir1 dir2
diff -r -x "*.log" dir1 dir2  # -x 忽略的文件

# -u 统一格式显示
[root@m01 tmp]# diff -u file1 file2
--- file1       2024-08-12 20:08:34.878711568 +0800
+++ file2       2024-08-12 20:08:40.235711525 +0800
@@ -1 +1 @@
-this is file1
+this is file2


vimdiff #  Vim 编辑器的一个功能模式，主要用于比较和合并两个或多个文件之间的差异
vimdiff 文件 1 文件 2
# -o或-O：-o表示水平分屏打开文件，-O表示垂直分屏打开文件
# 使用Ctrl + w，然后再按w可以在不同的窗口之间切换。
# 使用方向键或j（下）、k（上）、h（左）、l（右）在文件中移动。


rev #  用于反转行中字符顺序的命令
# rev [文件或输入流]
[root@m01 tmp]# echo 'hello' |rev
olleh
[root@m01 tmp]# rev text.txt



grep  （Global Regular Expression Print） # 强大的文本搜索工具。它通过指定的模式来过滤文本，并将匹配该模式的行打印出来
grep [选项] 模式 [文件...]
常用选项
-i：忽略大小写进行搜索。
-v：只显示不匹配的行
-n：在输出的每一行前面显示行号。
-c：只输出匹配的行数，而不是具体的行内容。例如，grep -c "apple" test.txt 会显示文件中包含“apple”的行数。
-r（或--recursive） -R ：递归搜索子目录下的文件。当处理包含子目录的目录结构时很有用，如grep -r "apple" /home/user/directory。
-E：使用扩展正则表达式。
[root@m01 tmp]# cat text.txt
apple
banana
apple
cherry
banana
[root@m01 tmp]# grep 'apple' text.txt
apple
apple
[root@m01 tmp]# grep -n 'apple' text.txt
1:apple
3:apple
[root@m01 tmp]# grep -c "apple" test.txt
0
[root@m01 tmp]# grep -c "apple" text.txt
2
# 递归地在当前目录及其子目录中搜索所有包含 "example" 的文件，
[root@m01 tmp]# grep -r 'apple' .
./public/test.txt:apple
./text.txt:apple
./text.txt:apple

# 扩展
grep "ERROR" application.log
ps -ef | grep "process_name"：# 用于查找特定进程名的进程信息
tail -f logfile | grep "ERROR"：# 实时监控日志文件

grep高级用法
[root@m01 tmp]# grep "^appl" text.txt  # 以appl开头的行
[root@m01 tmp]# grep -E "apple|banana" text.txt #扩展正则
[root@m01 tmp]# grep --color=auto "cherry" text.txt  #高亮显示
[root@m01 tmp]# grep -A 2 -B 2 "banana" text.txt  #匹配的前后两行
[root@m01 tmp]# grep -c "apple" text.txt  #匹配的行数
grep -r "pattern" --exclude-dir={dir1,dir2,...}  #跳过的目录
grep -F "exact_string" filename    #以固定字符搜索,而不是正则表达式. 提高搜索速度
grep -l "banana" *     # 显示匹配的文件名


egrep   是 grep -E 的别名


join  # 用于将两个文件中具有共同字段的行合并在一起
join [选项] 文件1 文件2
常用的 join 选项
-t：指定字段分隔符，默认是空格或制表符。
-1：指定第一个文件的字段号。
-2：指定第二个文件的字段号。
-a：输出指定文件的所有行，即使没有匹配。
-e：指定一个字符串来替换空输出字段。
-o：指定输出格式。
-j：指定一个或多个字段号作为联接键。
-v：只输出那些没有匹配的行。

[root@m01 tmp]# cat student.txt
101 alice
102 Bob
103 Carol
[root@m01 tmp]# cat grades.txt
101 A
102 B
104 D
[root@m01 tmp]# join -t ' ' student.txt grades.txt #合并第一列有相同的数字的
101 alice A
102 Bob B
[root@m01 tmp]# join -a 1 -t ' ' student.txt grades.txt  # 第1个文件所有列都输出,哪怕没匹配的
101 alice A
102 Bob B
103 Carol


tr # 用于对输入的文本进行字符转换或删除.
tr [选项] [字符集1] [字符集2]
常用的 tr 选项：
-d：删除指定的字符集。
-s：压缩指定字符集中的重复字符。
-c：取字符集的补集，即删除不在指定字符集中的字符。

echo "Hello World" | tr -d '\n'  #删除文本的换行符
echo "Hello World" | tr 'a-z' 'A-Z'  # 小写字母转换为大写：
echo "Hello, World! 123" | tr -d -c '[:alnum:]' #删除所有非字母数据字符
echo "This   is  a test" | tr -s ' '    #压缩连续的空格为单个空格


vi/vim  # 文本编辑器 "visual interface"
基本操作：
启动 vi：在命令行中输入 vi 文件名 来打开或创建一个文件。

命令模式：默认启动 vi 时处于命令模式.

插入模式：按 i 进入插入模式，
                a（在光标后插入）、
                o（在当前行下方新开一行并插入）等。

末行模式：按 : 进入末行模式.

常用命令：
命令模式：
h、j、k、l：分别向左、下、上、右移动光标。
x：删除光标下的字符。
dd：删除（剪切）整行。
yy：复制（yank）整行。
p：粘贴。
u：撤销上一步操作。
G：移动到文件的最后一行。
gg：移动到文件的第一行。
末行模式：
:w：保存文件但不退出 vi。
:wq 或 :x：保存文件并退出 vi。
:q!：不保存更改退出 vi。
:s/old/new/g：将当前行中的 old 替换为 new。
:%s/old/new/g：将整个文件中的 old 替换为 new。
:set nu：显示行号。
:set nonu：隐藏行号。
```





以后linux 命令问题请按 介绍,基本用法,常用选项,示例,生产环境建议及常用组合命令

