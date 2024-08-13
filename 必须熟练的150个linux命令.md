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



## 文件压缩及解压缩命令

```bash
tar  #用于打包和解包文件
基本用法：
-c：创建一个新的归档文件。
-x：从归档文件中提取文件。
-v：显示详细信息（verbose）。
-f：指定归档文件的名称。
-z：通过 gzip 进行压缩或解压缩。
-j：通过 bzip2 进行压缩或解压缩。
-J：通过 xz 进行压缩或解压缩。
-t：列出归档文件中的内容，但不提取。
-p：保持原文件的权限和属性。
-P：保留绝对路径名。
--exclude：在归档时排除指定的文件或目录。

tar -cvf archive_name.tar /path/to/directory_or_file
tar -xvf archive_name.tar  # 解包

tar -czvf archive_name.tar.gz /path/to/directory_or_file  #使用gzip压缩
tar -xzvf archive_name.tar.gz                                            #gzip 解压缩

tar -cjvf archive_name.tar.bz2 /path/to/directory_or_file #bzip2压缩
tar -xjvf archive_name.tar.bz2                                           #bzip2解压缩

tar -cJvf archive_name.tar.xz /path/to/directory_or_file   #xz 压缩
tar -xJvf archive_name.tar.xz											  #xz解压缩

#备份目录
tar -czvf /backup/directory/backup-$(date +%Y%m%d).tar.gz /path/to/important/directory
#删除超过30天的备份文件
find /backup/directory -name "*.tar.gz" -mtime +30 -exec rm {} \;
# scp 命令安全地将 tar 文件传输到远程服务器。
scp /path/to/archive.tar.gz user@remotehost:/path/to/destination


unzip # 专门用于解压缩 .zip 格式的压缩文件
unzip [选项] 压缩文件.zip
常用选项
-l：列出压缩文件中的内容，但不提取文件。
-p：将解压缩的文件输出到标准输出（stdout），不保存到磁盘。
-d：指定解压缩文件的目标目录。
-o：覆盖已存在的文件而不提示。
-n：不覆盖已存在的文件。
-q：静默模式，不显示任何信息。
-v：详细模式，显示解压缩过程中的详细信息。
unzip file.zip
unzip -v file.zip
unzip file.zip -d /path/to/destination  #解压文件到指定目录
unzip -l file.zip									   #查看一下不解压




gzip # 用于压缩文件。它使用 Lempel-Ziv 编码（LZ77）算法，压缩效果通常很好，尤其适用于文本文件
gzip [选项] 文件名
常用选项
-c：将输出写到标准输出（stdout），不删除原文件。
-d：解压缩文件。
-l：列出 .gz 文件的压缩信息。
-9：使用最大压缩比，但压缩速度较慢。
-1：使用最小压缩比，但压缩速度较快。
gzip filename.txt  #压缩 filename.txt 文件，并删除原文件，压缩后的文件名为 filename.txt.gz
gzip -c filename.txt > filename.txt.gz  #压缩文件并保留原文件
gzip -d filename.txt.gz                          # 解压缩
gzip -l filename.txt.gz                           #查看压缩信息

# # 解压缩 filename.gz 文件，并将内容解压到指定目录
gzip -cd filename.gz | tar -xv -C /path/to/destination 


zip  # 创建压缩文件（通常称为 .zip 文件
zip [选项] 压缩文件名.zip 文件或目录...
常用选项
-r：递归处理目录，包括子目录中的文件。
-9：使用最大压缩比，但压缩速度较慢。
-m：压缩完成后删除原文件。
-e：创建加密的 .zip 文件。
-j：忽略文件路径，仅存储文件名。
-l：将 Unix 的换行符转换为 DOS 格式。
-q：静默模式，不显示进度信息。

zip archive.zip file.txt
zip -r archive.zip directory/  # 压缩整个目录
zip archive.zip file1.txt file2.txt directory/  #压缩多个文件和目录
zip -rm archive.zip directory/   #解压完删除原目录(directory/)
zip -e archive.zip file.txt            # 会提示你输入密码来创建一个加密的 archive.zip 文件
unzip -l archive.zip                   #查看文件内容,而不实际解压


```



## 信息显示命令

```bash
uname # 用于显示系统信息
-a：显示所有可用的信息。
-s：显示内核名称（默认选项）。
-n：显示网络节点的主机名。
-r：显示内核发行版本号。
-m：显示硬件平台名称。
-p：显示处理器类型。
-v：显示内核版本。
-i：显示硬件平台的硬件名称。
-o：显示操作系统名称。

[root@m01 tmp]# uname
Linux
[root@m01 tmp]# uname -a
Linux m01 3.10.0-1160.71.1.el7.x86_64 #1 SMP Tue Jun 28 15:37:28 UTC 2022 x86_64 x86_64 x86_64 GNU/Linux
[root@m01 tmp]# uname -s
Linux
[root@m01 tmp]# uname -n
m01
[root@m01 tmp]# uname -r
3.10.0-1160.71.1.el7.x86_64
[root@m01 tmp]# uname -m
x86_64
[root@m01 tmp]# uname -p
x86_64
[root@m01 tmp]# uname -v
#1 SMP Tue Jun 28 15:37:28 UTC 2022
[root@m01 tmp]# uname -i
x86_64
[root@m01 tmp]# uname -o
GNU/Linux


hostname  # 用于显示或设置系统的主机名;主机名是一个网络节点的名称，用于标识网络中的设备。

[root@m01 tmp]# hostname   #查看主机名
m01
[root@m01 tmp]# # sudo hostname new_hostname  #临时修改主机名
[root@m01 tmp]# # vi /etc/hostname                        #永久修改主机名
# hostnamectl set-hostname new_hostname  #命令永久修改主机名,会修改文件.




dmesg # 用于查看和控制内核环形缓冲区（kernel ring buffer）。内核环形缓冲区记录了系统启动时的信息以及硬件和驱动程序的消息。
dmesg | grep "特定文本"
dmesg -wH   #查看实时内核消息：



uptime  # 显示系统已经运行了多长时间，以及系统的平均负载情况。

[root@m01 tmp]# uptime
 10:54:36 up 46 min,  1 user,  load average: 0.00, 0.01, 0.03
10:54:36 当前时间  
up 46 min  已经运行46分钟 
1 user   当前登录系统的用户数
load average: 0.00, 0.01, 0.03: 系统过去的 1 ,5 ,15 分钟的平均负载,理想情况下，这个值应该低于CPU核心数，表示系统负载正常。



file  #用于确定文件类型
常见选项
-b 或 --brief：仅输出文件类型，不包括文件名。
-i 或 --mime：输出文件的MIME类型。
-z：尝试解压缩归档文件并分析其内容。
-F 或 --separator：指定输出字段之间的分隔符。
[root@m01 tmp]# file text.txt
text.txt: ASCII text
[root@m01 tmp]# file -b text.txt
ASCII text
[root@m01 tmp]# file -i text.txt
text.txt: text/plain; charset=us-ascii
[root@m01 tmp]# file -z archive.zip
archive.zip: ASCII text (Zip archive data, at least v1.0 to extract)
在生产环境中，file 命令可以用于：

安全扫描：检查上传的文件类型，以防止恶意文件上传。
自动化脚本：在自动化脚本中使用，以根据文件类型执行不同的操作。
故障排查：当遇到文件相关的问题时，可以使用 file 命令来确认文件的格式和内容。



stat  # 用于显示文件或文件系统状态的详细信息
# 文件的元数据，如大小、块数、权限、最后访问、修改和改变时间等
[root@m01 tmp]# stat file1
  File: ‘file1’
  Size: 14              Blocks: 8          IO Block: 4096   regular file
Device: fd00h/64768d    Inode: 34280920    Links: 1
Access: (0644/-rw-r--r--)  Uid: (    0/    root)   Gid: (    0/    root)
Access: 2024-08-12 20:08:45.000000000 +0800
Modify: 2024-08-12 20:08:34.000000000 +0800
Change: 2024-08-13 10:43:09.428983316 +0800
 Birth: -
字段解释
File: 显示文件名。
Size: 文件的大小，单位通常是字节。
Blocks: 文件占用的512字节块的数量。现代系统可能使用更大的块大小（如4096字节），这取决于文件系统的配置。
IO Block: 文件系统的IO块大小，这是文件系统用于读写操作的基本单位。
regular file: 表明这是一个普通文件。其他可能的类型包括目录（directory）、字符设备（character device）、块设备（block device）等。
Device: 文件所在的设备标识，通常以十六进制表示。
Inode: 文件的inode编号。inode是文件系统中用于存储文件元数据（如权限、所有者、大小、时间戳等）的结构。
Links: 文件的硬链接数。硬链接是文件系统中指向同一inode的多个文件名。
Access: 文件的访问权限。这里显示的是八进制数（0644），以及对应的符号表示（-rw-r--r--）。
Uid: 文件所有者的用户ID和用户名。
Gid: 文件所属组的组ID和组名。
Access: 文件最后一次被访问的时间。
Modify: 文件内容最后一次被修改的时间。
Change: 文件的元数据（如权限或所有权）最后一次被改变的时间。
Birth: 文件创建时间。并非所有文件系统都记录这个时间，因此这里可能显示为“-”。



du  # 用于估算文件和目录的磁盘使用空间
常用选项
-h: 以人类可读的格式（如KB、MB、GB）显示大小。
-s: 显示总和，仅显示指定目录的总大小，不显示其子目录的大小。
-a: 显示每个文件的大小。
-c: 在输出的最后添加一个总和。
-d: 指定深度，只显示到指定层级的目录大小。
-x: 仅计算与指定文件系统相同的文件系统上的文件和目录。

du -sh  #显示当前目录的总磁盘使用情况
du -sh /path/to/directory  #指定目录
du -ah /path/to/directory  #显示指定目录里每个文件的大小


df  #用于报告文件系统的磁盘空间使用情况
常用选项
-h: 以人类可读的格式（如KB、MB、GB）显示大小。
-T: 显示文件系统类型。
-i: 显示inode使用情况，而不是块（block）使用情况。
-t: 仅显示指定类型的文件系统。
-x: 排除指定类型的文件系统。
-P: 使用POSIX输出格式。
df -h
df -h /dev/sda1
df -hT | grep ext4
df -hi


top #实时系统监控工具
# 动态更新的视图，显示系统中进程的资源使用情况，包括CPU、内存、运行状态等信息
常用功能和快捷键
动态更新：top 默认每3秒更新一次显示的信息，
交互式命令：
h 或 ?：显示帮助信息。
k：杀死一个进程。输入 k 后，系统会提示你输入要杀死的进程的PID。
r：重新安排一个进程的优先级。输入 r 后，系统会提示你输入要重新安排优先级的进程的PID。
M：按内存使用量排序进程。
P：按CPU使用量排序进程。
u：显示特定用户的进程。
i：忽略闲置和僵尸进程。
q：退出 top。

top - 11:31:12 up  1:23,  2 users,  load average: 0.00, 0.01, 0.03
Tasks:  96 total,   2 running,  94 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.3 sy,  0.0 ni, 99.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem :   995640 total,   571088 free,   129760 used,   294792 buff/cache
KiB Swap:  2097148 total,  2097148 free,        0 used.   684904 avail Mem

   PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND
   915 root      20   0  220772   7444   3420 S  0.3  0.7   0:00.47 rsyslogd
     1 root      20   0   51732   3852   2576 S  0.0  0.4   0:01.30 systemd
     2 root      20   0       0      0      0 S  0.0  0.0   0:00.00 kthreadd
     4 root       0 -20       0      0      0 S  0.0  0.0   0:00.00 kworker/0:0H
     5 root      20   0       0      0      0 S  0.0  0.0   0:00.08 kworker/u256:0
     6 root      20   0       0      0      0 S  0.0  0.0   0:00.10 ksoftirqd/0
     7 root      rt   0       0      0      0 S  0.0  0.0   0:00.00 migration/0

第一行：提供系统总体状态信息。
top：程序名称。
16:20:01：当前系统时间。
up 1:22：系统运行时间，此处表示系统已经运行了1小时22分钟。
2 users：当前登录用户数。
load average: 0.00, 0.01, 0.05：过去1分钟、5分钟和15分钟的平均负载。数值越低，表示系统负载越低。

第二行：显示任务状态。
Tasks: 206 total：系统中总共有多少个进程。
1 running：正在运行的进程数。
205 sleeping：处于睡眠状态的进程数。
0 stopped：被停止的进程数。
0 zombie：僵尸进程数（已经结束但其父进程尚未回收资源的进程）。
     
第三行：CPU状态。
Cpu(s): 0.3%us：用户空间占用CPU的百分比。
0.3%sy：内核空间占用CPU的百分比。
0.0%ni：改变过优先级的进程占用CPU的百分比。
99.3%id：空闲CPU百分比。
0.0%wa：等待I/O的CPU时间百分比。
0.0%hi：硬件中断请求占用CPU的百分比。
0.0%si：软件中断请求占用CPU的百分比。
0.0%st：虚拟机占用的CPU时间百分比（在虚拟化环境中）。  
第四行：内存状态。
Mem: 16275200k total：物理内存总量。
15618080k used：已使用的内存总量。
657120k free：空闲内存总量。
124960k buffers：用作缓冲的内存总量。
第五行：交换空间状态。
Swap: 2097144k total：交换空间总量。
0k used：已使用的交换空间总量。
2097144k free：空闲交换空间总量。
1561808k cached： :用作缓存的交换空间总量。
 684920 avail Mem :用作缓存的交换空间总量。

2. 进程列表区域
PID：进程ID。
USER：进程所有者。
PR：进程优先级。
NI：nice值。负值表示较高的优先级，正值表示较低的优先级。
VIRT：进程使用的虚拟内存总量。
RES：进程使用的物理内存总量。
SHR：进程使用的共享内存总量。
S：进程状态（S表示睡眠，R表示运行，Z表示僵尸进程，等等）。
%CPU：进程使用的CPU百分比。
%MEM：进程使用的物理内存百分比。
TIME+：进程自启动以来使用的CPU时间总量。
COMMAND：启动进程的命令名。


# 扩展  
# htop  (top升级版)
# atop  (监控CPU、内存、磁盘I/O、网络I/O、进程等)
# dstat(vmstat, iostat, netstat, ifstat,的结合)



free #显示系统中空闲和已使用的物理及交换内存总量

free -m  # 以MB为单位显示
free -g  # 以GB为单位显示
free -h

[root@m01 tmp]# free -h
                     total        used        free      shared  buff/cache   available
Mem:           972M        126M     557M        7.6M        287M        668M
Swap:           2.0G           0B        2.0G

total：表示系统安装的总内存大小。
used：表示当前被系统使用的内存总量，包括了缓存和缓冲区的内存。
free：表示当前未被使用的内存总量。
shared：表示被多个进程共享的内存总量（在某些系统上可能不准确或不显示）。
buff/cache：表示被内核用作文件系统缓存的内存总量。
available：表示估计的可用于启动新应用的内存总量，它考虑了当前的缓存和缓冲区，但不包括交换空间。



date #用于显示和设置系统的日期和时间
date -u                                                # 显示当前的UTC时间：
sudo date -s "2023-12-31 12:00:00"  # 设置系统时间为特定的UTC时间：
sudo date 123112002023  #时间设置为2023年12月31日中午12点，
sudo date MMDDhhmmYYYY

[root@m01 tmp]# date +%s  #当前时间戳
1723521301
[root@m01 tmp]# date -d "2023-01-01 12:00:00" +%s  #显示指定时间戳
1672545600

cal  #显示日历
cal
cal 2023
cal 9 2023
cal -my 2023
选项
-3：显示前一个月、当前月和下一个月的日历。
-m：将星期一作为一周的第一天（默认情况下，cal 将星期日作为一周的第一天）。
-j：显示儒略日（Julian day），即从年初开始的天数。
-y：显示整年的日历。
```



## 搜索文件命令

```bash
which # 确定可执行文件的位置
[root@m01 tmp]# which python
/usr/bin/python
[root@m01 tmp]# which ls
alias ls='ls --color=auto'
        /usr/bin/ls



find # 文件系统中搜索文件和目录
find [路径] [条件] [动作]
路径：指定开始搜索的目录，默认是当前目录。
条件：指定搜索的条件，如文件名、大小、类型、修改时间等。
动作：对找到的文件执行的操作，如打印文件名、删除文件等。
常用选项
-name：按文件名搜索。
-type：按文件类型搜索，如 f 表示普通文件，d 表示目录。
-size：按文件大小搜索，如 +100k 表示大于100KB的文件。
-mtime：按文件最后修改时间搜索，如 -mtime -7 表示最后7天内修改过的文件。
-empty：搜索空文件或目录。
-inum：按inode号搜索文件。
-user：按文件所有者搜索。
-group：按文件所属组搜索。

find . -name example.txt  #当前目录根据文件名查找
find . -type f -size +1M    # 找大于1M的文件
find . -type d -empty -delete  #当前目录下所有的空目录 找到删除
find . -user john                       #找john用户的文件
find . -mtime -7 -print       # 打印 最近7天内修改过的文件

# 查找当前目录及其子目录下所有包含空格的文件，并使用 rm 命令删除它们
find . -type f -print0 | xargs -0 rm
-print0  # 使用 NUL 字符（\0）作为输出项之间的分隔符
xargs 命令用于构建并执行命令行。-0 选项告诉 xargs 使用 NUL 字符作为输入项之间的分隔符，

find . -type f -name "*.txt" -size +1M
find . ! -user john
find . -type f -name "*.txt" -exec cat {} \;
find . -type f -name "*.txt" -exec grep "search_text" {} \;
find . -type f -name "*.txt" -ok rm {} \;
find . -inum 12345 -print   #查找特定inode号文件

#  -path "./node_modules" -prune   避免进入特定目录
find . -path "./node_modules" -prune -o -type f -print
# 查找所有比文件 reference.txt 更新的文件：
find . -newer reference.txt
find . -type d -empty  #查找空目录


whereis  #快速查找二进制文件、源代码和手册页的位置

whereis [选项] 命令名
常用选项
-b：仅查找二进制文件。
-s：仅查找源代码文件。
-m：仅查找手册页。
-B：指定搜索二进制文件的目录。
-M：指定搜索手册页的目录。
-S：指定搜索源代码的目录。
whereis gcc
whereis -b gcc

locate  #快速查找文件和目录的位置
# 使用一个预先构建的数据库（通常由 updatedb 命令维护）来快速定位文件。
# 这使得 locate 在速度上通常比 find 快得多，
# 但它的缺点是不能找到在数据库更新之后新创建或修改的文件。
yum install -y locate


locate [选项] 模式
常用选项
-i：忽略大小写。
-c：仅输出匹配文件的总数，不显示文件路径。
-r 或 --regexp：使用正则表达式进行搜索。
-S 或 --statistics：显示数据库统计信息，如数据库大小、文件数量等。
-q：静默模式，不显示任何错误信息。
locate example.txt
locate -r 'config$'              #查找所有以 config 结尾的文件：
locate -c example.txt         #仅显示匹配文件的总数
locate -i httpd                    #查找所有包含 httpd 的文件路径：

locate 依赖于数据库的特性,确保数据库是最新的,或者需要查找心文件时使用find命令



```



## 用户管理命令

```bash
useradd
useradd [选项] 用户名
常用选项
-m：创建用户的家目录。如果指定此选项，useradd 会创建一个与用户名同名的目录在 /home 下。
-d：指定家目录的路径。如果使用此选项，-m 选项将被忽略。
-s：指定用户的登录shell。默认情况下，许多系统使用 /bin/bash。
-g：指定用户的初始登录组。如果未指定，通常会创建一个与用户名同名的组。
-G：指定用户的附加组。用户将同时成为指定的附加组成员。
-u：指定用户的UID（用户ID）。如果未指定，系统会自动分配一个唯一的UID。
-p：设置用户的密码。通常，密码会通过 passwd 命令单独设置。
-c：添加用户账户的注释信息，如用户的全名或联系信息。
-e：设置账户的过期日期。日期格式为 YYYY-MM-DD。

useradd -m -s /bin/bash newuser  #创建新用户,指定家目录和登录shell
# 指定初始组和附加组
useradd -g users -G wheel,developers newuser
# 指定UID和账户过期日期
useradd -u 1010 -e 2023-12-31 newuser

usermod #用于修改已存在的用户账户属性
# usermod 来更改用户的登录信息、家目录、所属组等属性
usermod [选项] 用户名
常用选项
-l：更改用户的登录名。
-d：更改用户的家目录。如果指定此选项，usermod 会将用户的家目录更改为指定的路径。
-m：移动用户旧的家目录到新的位置（与 -d 选项一起使用）。
-s：更改用户的登录shell。
-g：更改用户的初始登录组。
-G：更改用户的附加组列表。用户将成为指定的附加组成员，原有的附加组成员资格将被替换。
-a：与 -G 选项一起使用，用于向用户的附加组列表中添加新的组，而不是替换它们。
-L：锁定用户账户，使其无法登录。
-U：解锁用户账户，允许用户登录。
-e：设置账户的过期日期。日期格式为 YYYY-MM-DD。
usermod -l newname oldname   #修改登录名
usermod -d /new/home/dir -m oldname  #更改用户的家目录并移动旧的家目录：
usermod -s /bin/zsh oldname    #更改shell
usermod -g newgroup oldname  #更改组
usermod -a -G newgroup oldname  #添加新组
# 锁定和解锁用户
usermod -L oldname  
usermod -U oldname
usermod -e 2023-12-31 oldname  #设置账户过期日期



userdel   #删除用户账户
userdel [选项] 用户名
常用选项
-r：删除用户的同时，删除与该用户相关的家目录和邮件目录。
-f：强制删除用户，即使用户当前登录或有未删除的文件。
userdel username
userdel -r username

groupadd   #，用于创建新的用户组
groupadd [选项] 组名
常用选项
-g GID：指定新创建的组的组ID（GID）。如果未指定，系统会自动分配一个唯一的GID。
-r：创建一个系统组。系统组的GID通常低于1000（这个值可能因系统而异）。
-f：如果组已经存在，强制创建该组而不报错。

groupadd newgroup
groupadd -g 1010 newgroup
groupadd -r systemgroup



passwd   #，用于更改用户账户的密码
选项
-l：锁定用户账户，使其无法登录。
-u：解锁用户账户。
-d：删除用户的密码，使其无需密码登录（不推荐）。
-e：强制用户下次登录时更改密码。
-S：显示用户账户的状态。
passwd  #普通用户更改自己的密码
sudo passwd 用户名 # 系统管理员为其他用户设置或更改密码
sudo passwd -l john #锁定用户
sudo passwd -u john # 解锁用户
sudo passwd -e john #强制用户 john 在下次登录时更改密码




chage #用于管理用户密码过期信息
chage [选项] 用户名
选项
-l：列出指定用户的密码过期信息。
-d：设置上次密码更改的日期。日期格式通常是 YYYY-MM-DD。
-m：设置密码的最小使用天数。
-M：设置密码的最大使用天数。
-W：设置密码过期前的警告天数。
-I：设置密码过期后账户被禁用的天数。
-E：设置账户过期的日期。日期格式通常是 YYYY-MM-DD。
sudo chage -l john         #查看用户 john 的密码过期信息
sudo chage -M 60 john  #设置用户 john 的密码最大使用天数为60天
sudo chage -W 7 john    # 设置用户 john 在密码过期前7天开始警告
sudo chage -I 30 john     #设置用户 john 的密码过期后账户禁用30天：
sudo chage -d 0 john      # 强制用户 john 在下次登录时更改密码：




id   #显示当前用户或指定用户的用户ID（UID）、组ID（GID）以及所属的其他组信息
id [选项] [用户名]
如果不指定用户名，id 命令将显示当前用户的ID信息。
如果指定了用户名，id 将显示该用户的ID信息。
选项
-u：仅显示用户的UID。
-g：仅显示用户的主组ID（GID）。
-G：显示用户所属的所有组的GID。
-n：显示名称而非数字ID（与 -u, -g, -G 一起使用时有效）。
-r：显示实际的UID和GID，而非有效UID和GID
显示当前用户的ID信息：
id   #这将显示当前用户的UID、GID以及所属的其他组。
仅显示当前用户的UID：
id -u
仅显示当前用户的主组ID：
id -g
显示当前用户所属的所有组的GID：
id -G
显示指定用户的ID信息（例如用户 john）：
id john



su  # 切换当前用户身份到另一个用户
su [选项] [用户名]
如果不指定用户名，su 默认切换到root用户。
如果指定了用户名，su 将切换到该用户。
选项
-：切换用户时，同时加载该用户的环境变量（如PATH、HOME等）。
-c：执行一个命令后立即退出，不切换到新用户。
-l 或 --login：模拟登录shell，加载用户的登录环境。

su -   #切换到root用户
su -c 'command'  #以root身份执行单个命令
su -c 'tail -f /var/log/syslog'  #以root身份查看日志文件
su - john   #切换john 用户并加载john的环境变量






visudo  #用于编辑 /etc/sudoers 文件
# etc/sudoers 文件定义了哪些用户和用户组可以使用 sudo 命令，以及他们可以执行哪些命令
/etc/sudoers 文件通常包含以下部分：

1.别名（Aliases）：定义了用户别名、主机别名、命令别名和运行时别名，用于简化配置。
2.用户权限：指定哪些用户或用户组可以使用 sudo。
3.主机权限：指定哪些主机可以使用 sudo。
4.命令权限：指定用户可以使用 sudo 执行哪些命令。
5.默认设置：定义了 sudo 的默认行为，如是否需要密码、是否记录命令等。

#允许用户 john 无密码使用 sudo 执行所有命令
john ALL=(ALL) NOPASSWD: ALL
# 允许用户组 developers 中的任何用户使用 sudo 执行特定命令
%developers ALL=(ALL) /usr/bin/apt-get, /usr/bin/systemctl
# 限制用户 jane 只能在 webserver 主机上使用 sudo 执行 service 命令：
jane webserver=(ALL) NOPASSWD: /usr/sbin/service


conf-----------------------------------------------
# 用户别名
User_Alias ADMINS = alice, bob

# 主机别名
Host_Alias SERVERS = server1, server2

# 命令别名
Cmnd_Alias SYSTEMCTL = /usr/bin/systemctl

# 默认设置
Defaults secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# 用户权限
ADMINS ALL=(ALL:ALL) ALL

# 特定命令权限
alice SERVERS=(root) SYSTEMCTL



sudo  #它允许用户以另一个用户的身份（通常是超级用户root）执行命令
sudo [选项] 命令
选项
-u 用户名：以指定的用户身份执行命令，不指定时默认为root。
-s：启动指定用户的shell。
-l：列出当前用户可以使用 sudo 执行的命令。
-v：如果用户是 sudoers 文件中的用户，这个选项将延长其密码的有效时间。
-k：清除用户密码的有效时间，下次使用 sudo 时需要重新输入密码。

sudo ls /root  #以root用户身份执行命令
sudo -u john /bin/ls /home/john  #以特定用户执行命令
sudo -s                                           # 启动root用户shell
sudo -l                                            #列出当前用户可执行的sudo命令
sudo -v



sudo和su有什么区别？
1. 目的和使用场景
su (substitute user)：用于切换当前用户到另一个用户，通常用于切换到root用户。使用 su 时，你将获得新用户的完整环境和权限，直到你退出该用户会话。
sudo (substitute user do)：允许你以另一个用户（通常是root）的身份执行单个命令，而不需要切换到该用户的登录会话。使用 sudo 时，你通常需要输入自己的密码（除非配置了免密码执行特定命令）。
2. 权限和安全性
su：当你使用 su 切换到root用户时，你将拥有系统上所有权限，这可能带来安全风险。如果操作不当，可能会对系统造成严重损害。
sudo：sudo 提供了更细粒度的权限控制。管理员可以配置哪些用户或用户组可以使用 sudo 执行哪些命令。此外，sudo 通常会记录所有使用情况，便于审计和追踪。
3. 使用便捷性
su：需要输入目标用户的密码，除非当前用户已经配置为无密码切换到该用户。
sudo：通常只需要输入当前用户的密码，这使得执行需要提升权限的命令更加方便快捷。
4. 配置
su：不需要特别的配置，任何用户都可以使用 su 切换到其他用户，前提是他们知道目标用户的密码。
sudo：需要在 /etc/sudoers 文件中进行配置，指定哪些用户或用户组可以使用 sudo，以及他们可以执行哪些命令。这需要管理员权限。
5. 日志记录
su：通常不会记录切换用户的活动，除非系统管理员特别配置了日志记录。
sudo：所有使用 sudo 执行的命令都会被记录在 /var/log/auth.log 或 /var/log/secure 等日志文件中，这有助于系统审计和安全检查。

```





以后linux 命令问题请按 介绍,语法,常用选项,示例,生产环境建议及常用组合命令

