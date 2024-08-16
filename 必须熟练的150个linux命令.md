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



# 以及安装的执行文件 查找是属于哪个包
[root@m01 ~]# rpm -q --whatprovides `which nslookup`  
bind-utils-9.11.4-26.P2.el7_9.16.x86_64

# 未安装的软件,只知道命令,找包
yum provides router
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

## 基础网络操作命令

```bash
telnet  #是一个网络协议，用于通过网络连接到远程服务器
telnet [选项] 主机名 [端口]
常用选项
-l 用户名：指定登录时使用的用户名。
-a：尝试自动登录。
-f：保存从远程主机接收到的认证信息到本地主机的 .netrc 文件中（不推荐使用，因为不安全）。
主机名：远程服务器的主机名或IP地址。
端口：远程服务器上监听的端口号，默认通常是23。

telnet example.com
telnet example.com 8080
安全性：由于 telnet 不加密传输数据，因此不应在传输敏感信息（如密码、个人数据等）时使用。建议使用SSH替代 telnet。
网络调试：telnet 可用于网络调试，例如检查特定端口是否开放。
特定服务测试：在某些情况下，telnet 可用于测试特定服务是否正常运行，如测试HTTP服务是否响应。



ssh  #（Secure Shell）是一种网络协议，用于在不安全的网络中为计算机之间提供安全的加密通信
ssh [选项] 用户名@主机名 [远程命令]
用户名：远程服务器上的用户名。
主机名：远程服务器的主机名或IP地址。
远程命令：可选，指定在远程服务器上执行的命令。
常用选项
-p 端口：指定连接的端口号，默认是22。
-i 私钥文件：指定用于身份验证的私钥文件。
-l 用户名：指定登录时使用的用户名。
-L 本地端口:远程主机:远程端口：本地端口转发。
-R 远程端口:本地主机:本地端口：远程端口转发。
-D 动态端口转发：动态端口转发，用于SOCKS代理。

ssh username@remote_host
ssh -p 2222 username@remote_host
ssh -i /path/to/private_key username@remote_host
ssh username@remote_host 'ls -l'


# SSH密钥认证比密码认证更安全。生成密钥对（公钥和私钥），将公钥添加到服务器的 ~/.ssh/authorized_keys 文件中，然后使用私钥进行认证。
ssh-keygen
ssh-copy-id username@remote_host

# 本地端口转发：
# 将本地的3306端口转发到 example.com 上的3306端口。现在，你可以通过本地的3306端口安全地访问远程MySQL服务，就像它在本地运行一样。
ssh -L [本地绑定地址:]本地端口:远程主机:远程端口 用户名@SSH服务器
[本地绑定地址:] 是可选的，用于指定本地端口绑定的地址，默认是 localhost
ssh -L 3306:localhost:3306 username@example.com



# 远程端口转发
#将 example.com 上的8080端口转发到本地计算机的80端口。现在，你可以通过 example.com 的8080端口访问本地的HTTP服务。
ssh -R [远程绑定地址:]远程端口:本地主机:本地端口 用户名@SSH服务器
ssh -R 8080:localhost:80 username@example.com

# 使用SSH隧道 
# SSH隧道通常是指通过SSH连接建立的加密通道，用于保护通过该通道传输的数据。这个术语强调的是数据传输的安全性。
# 创建一个隧道，将本地的3306端口转发到 ssh_host 上的3306端口。
ssh -fNg -L 3306:localhost:3306 username@ssh_host

# 使用SSH多路复用
#可以使用 ssh -S /tmp/sshsocket 来复用这个连接
ssh -N -f -M -S /tmp/sshsocket username@ssh_host


# ssh的socks代理 
-----------------------------------------------------------------------------------
#服务器端 保证有ssh服务端口开通  端口转发功能打开(默认开)
ssh-keygen
ssh-copy-id root@10.0.0.3

nohup ssh -D 1080 root@10.0.0.3 & #放后台 ,目前不成功
yum install screen
screen   #启动一个新的screen会话
ssh -D 1080 root@10.0.0.3 
# ctrl+A 然后再按D  返回原始的终端会话
# screen -r  再回到screen  会话

检查端口是否启动
netstat -tulnp |grep 1080
lsof -i :1080
# 测试代理是否正常工作
curl --socks5 localhost:1080 https://www.baidu.com

操作系统设置 代理   手动设置代理  
代理ip地址写 localhost
端口 1080
--------------------------------------------------------------------------------

scp  #（secure copy）是一个用于在本地主机和远程主机之间，或者远程主机之间安全地复制文件的命令行工具。
# 它使用SSH协议来保证数据传输的安全性

scp [选项] 源文件 目标文件
常用选项
-P 端口：指定远程主机的端口号。
-r：递归复制整个目录。
-p：保留原文件的修改时间和访问权限。
-i 私钥文件：指定用于身份验证的私钥文件。

# 从本地复制文件到远程主机
scp local_file.txt username@remote_host:/path/to/remote/directory
# 从远程主机复制文件到本地
scp username@remote_host:/path/to/remote/file.txt /path/to/local/directory

scp -P 2222 local_file.txt username@remote_host:/path/to/remote/directory
# 递归复制目录
scp -r local_directory username@remote_host:/path/to/remote/directory

# 使用私钥文件进行身份验证
scp -i /path/to/private_key local_file.txt username@remote_host:/path/to/remote/directory安全性：scp 使用SSH进行加密传输，因此比使用FTP等非加密协议更安全。
权限和所有权：复制文件时，文件的所有权和权限可能会改变。使用 -p 选项可以保留原文件的权限和时间戳。
网络要求：scp 需要能够访问远程主机的SSH服务。确保远程主机的SSH服务正在运行，并且端口没有被防火墙阻塞。
性能：对于大文件或大量文件的传输，scp 可能会比较慢。考虑使用 rsync 或其他文件同步工具来提高效率。

注意: 
安全性：scp 使用SSH进行加密传输，因此比使用FTP等非加密协议更安全。
权限和所有权：复制文件时，文件的所有权和权限可能会改变。使用 -p 选项可以保留原文件的权限和时间戳。
性能：对于大文件或大量文件的传输，scp 可能会比较慢。考虑使用 rsync 或其他文件同步工具来提高效率。




wget # 用于从网络上下载文件
wget [选项] URL
常用选项
-O：指定下载文件的保存名称。
-c：继续未完成的下载任务。
-b：后台下载模式。
-r：递归下载，用于下载整个网站或目录。
-np：不下载父目录，仅用于递归下载。
-nc：如果文件已存在，不覆盖现有文件。
-A：指定要下载的文件类型。
-limit-rate：限制下载速度。
-i：从文件中读取URL进行下载。

wget http://example.com/file.zip
wget -O mydownload.zip http://example.com/file.zip
wget -c http://example.com/largefile.zip
wget -b http://example.com/file.zip
##下载 http://example.com/ 网站的所有内容，但不会下载父目录中的内容
wget -r -np http://example.com/  

axel  #多线程下载工具
sudo yum install axel  # CentOS 7 及以下版本
axel -n 线程数 URL




ping  #测试网络连接 
# 它通过发送ICMP（Internet Control Message Protocol）回显请求消息到目标主机，并等待接收回显应答
ping [选项] 目标主机
常用选项
-c：指定发送的回显请求数量。
-i：设置发送回显请求之间的时间间隔（秒）。
-s：指定数据包的大小（字节）。
-W：设置等待回显应答的超时时间（秒）。

ping example.com
#发送4个回显请求到 example.com，然后显示结果并退出
ping -c 4 example.com
# 超时时间2秒
ping -W 2 example.com
# 设置数据包大小 1000字节
ping -s 1000 example.com

[root@kh1 tmp]# ping -c 4 www.bing.com
PING a-0001.a-msedge.net (204.79.197.200) 56(84) bytes of data.
64 bytes from a-0001.a-msedge.net (204.79.197.200): icmp_seq=1 ttl=128 time=59.1 ms
64 bytes from a-0001.a-msedge.net (204.79.197.200): icmp_seq=2 ttl=128 time=57.8 ms
64 bytes from a-0001.a-msedge.net (204.79.197.200): icmp_seq=3 ttl=128 time=58.2 ms
64 bytes from a-0001.a-msedge.net (204.79.197.200): icmp_seq=4 ttl=128 time=58.7 ms

--- a-0001.a-msedge.net ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3021ms
rtt min/avg/max/mdev = 57.898/58.526/59.162/0.514 ms

输出详细说明
1 .(204.79.197.200)  : 域名对应的ip地址
2. 56(84) : 表示发送了56字节的数据，但IP头部额外增加了28字节，所以总共是84字节。
3. ICMP序列号：icmp_seq=1 表示这是序列号为1的ICMP回显请求和应答。
4. TTL（Time To Live）：ttl=128 表示数据包在网络中可以存活的最大跳数。每经过一个路由器，TTL值减1，直到为0时数据包被丢弃。
5. 往返时间（RTT）：time=59.1 ms 表示从发送回显请求到接收回显应答的往返时间是59.1毫秒。这个时间可以反映网络延迟。
6. 统计信息：显示了发送的数据包数量、接收到的数据包数量、丢包率、总时间以及最小、平均、最大往返时间等统计信息。
packets transmitted：发送的数据包数量。
packets received：接收到的数据包数量。
packet loss：丢包率，如果为0%，表示没有丢包。
time：测试的总时间。
rtt min/avg/max/mdev：最小、平均、最大往返时间以及标准偏差（mdev），标准偏差越小表示网络延迟越稳定。



route #显示和修改IP路由表
选项说明
-n：以数字形式显示地址，而不是尝试将它们解析为主机名。
add：添加一条新的路由规则。
del：删除一条现有的路由规则。
-net：指定目标是一个网络。
-host：指定目标是一个主机。
netmask：指定目标网络的子网掩码。
gw：指定路由的网关地址。

route -n  #查看路由表
# 添加一条路由规则：
sudo route add -net 目标网络 netmask 子网掩码 gw 网关地址
# 删除一条路由规则
sudo route del -net 目标网络 netmask 子网掩码 gw 网关地址

[root@kh1 tmp]# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
0.0.0.0         	10.0.0.254      0.0.0.0               UG    0         0        0    eth0
10.0.0.0        	0.0.0.0           255.255.255.0   U       0         0        0    eth0
169.254.0.0      0.0.0.0           255.255.0.0       U     1002     0        0    eth0
Destination：目标网络或主机。
Gateway：网关地址，数据包将通过这个地址转发。
Genmask：子网掩码。
Flags：路由标志，如 U 表示路由是活动的，G 表示使用网关。
Metric：路由的度量值，用于选择最佳路由。
Ref：路由条目的引用数。
Use：路由条目的使用次数。
Iface：数据包将通过的网络接口。

# 添加一条路由规则，使得所有发往 192.168.2.0/24 网络的数据包通过 192.168.1.2 网关：
sudo route add -net 192.168.2.0 netmask 255.255.255.0 gw 192.168.1.2
# 删除之前添加的路由规则：
sudo route del -net 192.168.2.0 netmask 255.255.255.0 gw 192.168.1.2

#注意
# 使用 ip 命令代替：在许多现代Linux发行版中，route 命令已被 ip 命令取代。

常见的路由标志
U (Up)：表示该路由是活动的，即它当前是可用的。
G (Gateway)：表示该路由使用网关。如果设置了这个标志，说明到达目标网络的数据包需要通过指定的网关转发。
H (Host)：表示目标是一个主机。如果没有设置这个标志，目标通常是一个网络。
D (Dynamic)：表示该路由是动态添加的，例如通过 routed 守护进程或 metricom 程序。
M (Modified)：表示该路由被 metricom 程序修改过。
! (Reject)：表示该路由是一个被拒绝的路由。所有不符合其他路由规则的数据包都会被发送到这个路由，通常用于实现默认路由的“拒绝”行为。
R：表示对该路由进行动态更新（例如，通过路由协议）


ifconfig  # 用于配置和显示网络接口参数
ifconfig -a  # 查看所有网络接口状态
选项说明
-a：显示所有网络接口的状态，包括那些未激活的接口。
-s：显示网络接口的简短摘要信息。
eth0：指定要配置的网络接口名称。在Linux中，网络接口通常以 eth 开头，例如 eth0、eth1 等。在一些现代Linux发行版中，接口可能以 enp 或其他前缀开头。

sudo ifconfig eth0 192.168.1.10 netmask 255.255.255.0 up
sudo ifconfig eth0 down


[root@kh1 tmp]# ifconfig -a
eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.0.0.4  netmask 255.255.255.0  broadcast 10.0.0.255
        inet6 fe80::20c:29ff:fe92:d070  prefixlen 64  scopeid 0x20<link>
        ether 00:0c:29:92:d0:70  txqueuelen 1000  (Ethernet)
        RX packets 2559  bytes 289676 (282.8 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 1983  bytes 294883 (287.9 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 107  bytes 33923 (33.1 KiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 107  bytes 33923 (33.1 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

字段解释: 
eth0: 网络接口的名称
flags=4163<UP,BROADCAST,RUNNING,MULTICAST>: 接口状态标志。UP 表示接口已启用，BROADCAST 表示接口支持广播，RUNNING 表示接口正在运行，MULTICAST 表示接口支持多播。

mtu 1500: 最大传输单元（MTU）为1500字节。

inet 10.0.0.4 netmask 255.255.255.0 broadcast 10.0.0.255: IPv4地址为10.0.0.4，子网掩码为255.255.255.0，广播地址为10.0.0.255。

inet6 fe80::20c:29ff:fe92:d070 prefixlen 64 scopeid 0x20<link>: IPv6地址为fe80::20c:29ff:fe92:d070，前缀长度为64位，作用范围为链路本地（link-local）。

ether 00:0c:29:92:d0:70: 接口的MAC地址。

txqueuelen 1000: 发送队列长度为1000。

RX packets 2559 bytes 289676 (282.8 KiB): 接收到2559个数据包，总字节数为289676字节（约282.8 KiB）。

RX errors 0 dropped 0 overruns 0 frame 0: 接收错误数为0，丢弃的数据包数为0，溢出数为0，帧对齐错误数为0。

TX packets 1983 bytes 294883 (287.9 KiB): 发送了1983个数据包，总字节数为294883字节（约287.9 KiB）。

TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0: 发送错误数为0，丢弃的数据包数为0，溢出数为0，载波错误数为0，冲突数为0。

lo 接口信息
flags=73<UP,LOOPBACK,RUNNING>: 接口状态标志。UP 表示接口已启用，LOOPBACK 表示是本地回环接口，RUNNING 表示接口正在运行。
mtu 65536: 最大传输单元（MTU）为65536字节，这是本地回环接口的标准MTU值。
inet 127.0.0.1 netmask 255.0.0.0: IPv4地址为127.0.0.1，子网掩码为255.0.0.0。这是本地回环地址，用于本机通信。
inet6 ::1 prefixlen 128 scopeid 0x10<host>: IPv6地址为::1，前缀长度为128位，作用范围为宿主（host）。
loop: 表示这是一个本地回环接口。
RX packets 107 bytes 33923 (33.1 KiB): 接收到107个数据包，总字节数为33923字节（约33.1 KiB）。
RX errors 0 dropped 0 overruns 0 frame 0: 接收错误数为0，丢弃的数据包数为0，溢出数为0，帧对齐错误数为0。
TX packets 107 bytes 33923 (33.1 KiB): 发送了107个数据包，总字节数为33923字节（约33.1 KiB）。
TX errors 0 dropped 0 overruns 0 carrier 0 collisions 0: 发送错误数为0，丢弃的数据包数为0，溢出数为0，载波错误数为0，冲突数为0。

flags=4163 字段的数值。下面是每个标志对应的位和数值：
UP: 二进制的第0位，十进制的1。
BROADCAST: 二进制的第1位，十进制的2。
RUNNING: 二进制的第3位，十进制的8。
MULTICAST: 二进制的第4位，十进制的16。
将这些数值相加（1 + 2 + 8 + 16），我们得到4163。因此，flags=4163 实际上是这些标志组合的数值表示。

flags=73 字段的数值。下面是每个标志对应的位和数值：
UP: 二进制的第0位，十进制的1。
LOOPBACK: 二进制的第7位，十进制的128。
RUNNING: 二进制的第3位，十进制的8。
将这些数值相加（1 + 128 + 8），我们得到73。因此，flags=73 实际上是这些标志组合的数值表示。




ifup  # 用于激活（启动）网络接口
选项
-a：激活所有未激活的网络接口。
--allow-auto=yes/no：允许或禁止自动配置接口。
--force：强制激活接口，即使它已经被激活。
--no-act：不实际激活接口，只是显示将要执行的操作。

sudo ifup eth0




ifdown #用于关闭（停用）网络接口
选项
-a：停用所有已激活的网络接口。
--exclude=interface：排除特定的接口，不对其进行停用操作。
--allow-auto=yes/no：允许或禁止自动配置接口。
--no-act：不实际停用接口，只是显示将要执行的操作。

sudo ifdown eth0


netstat  # 用于显示网络连接、路由表、接口统计、伪装连接和多播成员
netstat [选项]
常用选项
-t 或 --tcp：显示TCP连接。
-u 或 --udp：显示UDP连接。
-n：以数字形式显示地址和端口号，而不是尝试解析为主机名和服务名。
-l 或 --listening：仅显示监听状态的套接字。
-p 或 --program：显示套接字所属的进程ID和名称。
-r 或 --route：显示内核路由表。
-i 或 --interfaces：显示网络接口列表。

netstat -t   		#显示所有tcp连接
netstat -u         #显示所有udp连接
netstat -tuln     # 显示监听状态的TCP和UDP端口
netstat -tulpn   #显示每个套接字的进程ID和名称：
netstat -r          # 显示路由表
netstat -i           # 显示网络接口统计信息


netstat 的输出通常包含以下列：

Proto：协议类型（TCP或UDP）。
Recv-Q：接收队列中的字节数。
Send-Q：发送队列中的字节数。
Local Address：本地地址和端口。
Foreign Address：远程地址和端口。
State：连接的状态（例如，LISTEN、ESTABLISHED、TIME_WAIT等）。
PID/Program name：与套接字关联的进程ID和名称（如果使用 -p 选项）。
MSS（Maximum Segment Size，最大报文段长度
Window  是一种流量控制和拥塞控制的机制
IRTT（Initial Round Trip Time，初始往返时间

state 网络连接状态:
LISTEN:  监听 ;表示服务器程序正在等待连接进入
ESTABLISHED: 已经建立连接;
SYN_SENT: 
  -客户端已发送 SYN（同步）数据包来发起连接，但尚未收到对方的 SYN-ACK（同步确认）数			据包。这是在 TCP 三次握手过程中的一个中间状态。
	-当客户端尝试连接到服务器时，首先发送 SYN 包，此时客户端的连接状态就是SYN_SENT。
SYN_RECV:
   -服务器接收到了客户端的 SYN 数据包，并已发送 SYN-ACK 数据包，但尚未收到客户端的 ACK（确认）数据包。在服务器端，当接收到新的连接请求时，会进入这个状态。
  -例如，Web 服务器在接收到 HTTP 请求时，在建立连接的过程中可能会出现这个状态。

FIN_WAIT1
  -表示一方已经发送了 FIN（结束）数据包来终止连接，但仍在等待对方的 ACK 数据包。通常是主   动关闭连接的一方首先进入这个状态。
  -比如，一个客户端完成数据传输后，主动发起关闭连接操作，就会进入 FIN_WAIT1 状态。

FIN_WAIT2
-已经收到对方的 ACK 数据包，正在等待对方的 FIN 数据包。在 FIN_WAIT1 状态收到 ACK 后，  会进入 FIN_WAIT2 状态。
- 继续以上的例子，客户端在 FIN_WAIT1 状态收到服务器的 ACK 后，进入 FIN_WAIT2 状态，等待服务器关闭连接。

TIME_WAIT
- 在关闭连接后，主动关闭的一方会进入这个状态一段时间，以确保所有的数据都已经被接收方处理完毕，防止出现“已关闭的连接上的数据”问题。
-这是 TCP 连接关闭过程中的一个重要状态，通常会持续一段时间（通常是 2 倍的最大段生存期，即 2MSL）。

CLOSE_WAIT
-表示收到了对方的 FIN 数据包，但本地应用程序尚未关闭连接。在被动关闭连接的一方收到 FIN 后，会进入这个状态。
-例如，服务器在接收到客户端的关闭请求后，如果还有数据未处理完，就会处于 CLOSE_WAIT 状态。

LAST_ACK
-被动关闭的一方在发送了 FIN 数据包后，等待对方的 ACK 数据包来确认连接的完全关闭。通常是服务器在所有数据处理完毕并发送 FIN 后进入这个状态。
-例如，在 FTP 会话结束时，服务器在关闭连接之前会进入 LAST_ACK 状态，等待客户端的最终确认。

CLOSED
- 连接已经完全关闭，资源已释放。这是连接的最终状态，当两端都完成了关闭操作后，连接就会进入 CLOSED 状态。
- 一旦进入这个状态，相关的套接字资源会被系统回收



[root@kh1 tmp]# netstat -i
Kernel Interface table
Iface             MTU    RX-OK RX-ERR RX-DRP RX-OVR    TX-OK TX-ERR TX-DRP TX-OVR Flg
eth0             1500     2690      0          0               0          2129      0          0          0    BMRU
lo                 65536      107      0         0                0           107      0          0          0    LRU
输出解释
当运行 netstat -i 命令时，输出通常包含以下列：
Iface: 网络接口的名称，例如 eth0、wlan0 等。
MTU: 最大传输单元，表示接口可以发送的最大数据包大小（以字节为单位）。
RX-OK: 成功接收的数据包数量。
RX-ERR: 接收时发生错误的数据包数量。
RX-DRP: 接收时被丢弃的数据包数量。
RX-OVR: 接收时的溢出数据包数量。
TX-OK: 成功发送的数据包数量。
TX-ERR: 发送时发生错误的数据包数量。
TX-DRP: 发送时被丢弃的数据包数量。
TX-OVR: 发送时的溢出数据包数量。
Flg: 接口的状态标志，例如 B 表示接口处于广播模式，L 表示接口处于混杂模式，U 表示接口处于激活状态。M：表示该接口已设置为监测（monitor）模式,R：表示该接口正在运行（running）




```



## 深入网络操作命令

```bash
nmap #开源的网络探测和安全审核工具，广泛用于网络发现和安全审计
nmap [扫描类型] [选项] 目标
常用扫描类型
-sT：TCP connect()扫描。这是最基本的TCP扫描类型，它尝试与目标主机的每个端口建立完整的TCP连接。
-sS：TCP SYN扫描。也称为半开放扫描，它发送一个SYN数据包，然后等待响应。如果收到SYN/ACK响应，则端口被认为是开放的。
-sU：UDP扫描。用于发现哪些UDP端口是开放的。
-sP：Ping扫描。仅用于确定哪些主机在网络上是活跃的。
-sV：版本探测。尝试确定开放端口上运行的服务和版本信息。
-O：操作系统探测。尝试确定目标主机的操作系统类型。
常用选项
-p：指定要扫描的端口范围。例如 -p 80,110,443。
-A：启用高级和版本探测。
-v：增加冗余度，显示扫描过程中的详细信息。
-T：设置时间模板，控制扫描速度和效率。例如 -T4 表示快速扫描。
-oN：将扫描结果保存到一个名为 nmap-output 的文件中。
-oX：将扫描结果保存为XML格式。

nmap -sP 192.168.1.0/24    #快速扫描本地网络中活跃的主机：
nmap -sT 192.168.1.1         #扫描特定主机的开放端口：
nmap -sU -p 53 192.168.1.1 #扫描特定端口
nmap -O -sV 192.168.1.1     #进行操作系统探测和版本探测
nmap -A 192.168.1.1  #对 192.168.1.1 进行高级探测，包括操作系统探测、版本探测等
nmap -sV 192.168.1.1 #对 192.168.1.1 进行版本探测，尝试确定开放端口上运行的服务和版本信息


# 于对一个子网进行快速扫描，并保存结果到文件
nmap -sP 192.168.1.0/24 -oN network_scan_results.txt

# 对活跃的主机进行详细扫描
nmap -sV -O -T4 --max-parallelism 10 -p 21,22,80,443 192.168.1.1-254 -oN detailed_scan_results.txt

lsof  #（list open files）是一个在Unix和类Unix系统中广泛使用的命令行工具，用于列出当前系统打开的文件
lsof [选项]
常用选项
-i：列出网络连接信息。
-p：指定进程ID，列出该进程打开的文件。
-u：指定用户，列出该用户打开的文件。
-n：不将IP地址解析为域名，显示数字形式的IP地址。
-P：不将端口号解析为服务名。
-s：指定文件的类型，如TCP、UDP等。
-t：仅输出进程ID。
-U：列出UNIX套接字。
lsof -p 1234
lsof -u username
lsof -i
lsof -i :80
lsof -i tcp
lsof -t

[root@m01 ~]# lsof
COMMAND    PID  TID    USER   FD      TYPE             DEVICE  SIZE/OFF       NODE NAME
systemd      		1         		root  cwd       DIR              253,0       244         64 /
systemd      		1         		root  rtd         DIR              253,0       244         64 /
systemd      		1         		root  txt         REG              253,0   1632960     283086 /usr/lib/systemd/systemd
                   
输出解释
lsof 的输出通常包含以下列：
COMMAND：运行进程的名称。
PID：进程ID。
USER：进程所有者的用户名。
FD：文件描述符（或文件类型）。
TYPE：文件类型，如 REG（常规文件）、DIR（目录）、CHR（字符设备）、FIFO（管道）、IPv4（IPv4套接字）等。
DEVICE：设备号。
SIZE/OFF：文件大小或偏移量。
NODE：节点号。
NAME：文件名或网络连接的详细信息。




mail  #用于发送和接收电子邮件  #待添加




mutt  #  流行的文本界面邮件用户代理（MUA）





nslookup #获取域名或IP地址映射信息
[root@m01 ~]# nslookup www.taobao.com 223.5.5.5
Server:         223.5.5.5
Address:        223.5.5.5#53

Non-authoritative answer:
www.taobao.com  canonical name = www.taobao.com.danuoyi.tbcache.com.
Name:   www.taobao.com.danuoyi.tbcache.com
Address: 106.225.235.139
Name:   www.taobao.com.danuoyi.tbcache.com
Address: 106.225.235.140
Name:   www.taobao.com.danuoyi.tbcache.com
Address: 240e:cf:8800:15:3::3d0
Name:   www.taobao.com.danuoyi.tbcache.com
Address: 240e:cf:8800:15:3::3d1





dig  #（domain information groper）是一个灵活的命令行工具，用于查询DNS（域名系统）信息
dig [@服务器] 域名 [查询类型] [选项]
服务器：指定用于查询的DNS服务器。
域名：要查询的域名。
查询类型：指定要查询的DNS记录类型，如 A、MX、NS、TXT 等。
常用选项
+short：仅显示查询结果的简短形式。
+trace：显示从根服务器开始的查询过程。
+noall 和 +answer：仅显示查询结果部分。
+tcp：使用TCP协议进行查询。
+time=T：设置查询的超时时间，其中 T 是秒数。


dig www.baidu.com  #查询域名A记录
dig example.com MX  
dig @8.8.8.8 example.com #指定dns服务器进行查询
dig +trace www.baidu.com  #显示详细信息

输出解释
dig 的输出通常包含以下部分：
; <<>> DiG 9.16.1-Ubuntu <<>> example.com：显示 dig 版本和查询命令。
;; global options: +cmd：显示全局选项。
;; Got answer:：显示查询结果。
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 53：显示DNS响应头信息。
;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 1：显示查询标志和响应部分的数量。
;; OPT PSEUDOSECTION:：显示额外的选项信息。
;; QUESTION SECTION:：显示查询的问题部分。
;; ANSWER SECTION:：显示查询的答案部分，包括域名、TTL（生存时间）和记录类型。
;; Query time:：显示查询所花费的时间。
;; SERVER:：显示响应的DNS服务器。
;; WHEN:：显示查询的时间。
;; MSG SIZE rcvd:：显示收到的消息大小。

DNS（域名系统）记录类型定义了域名与IP地址或其他信息之间的映射关系
记录类型
A 记录（Address Record） 将域名映射到IPv4地址。
AAAA 记录（IPv6 Address Record） 将域名映射到IPv6地址
MX 记录（Mail Exchange Record） 指定接收邮件的服务器
NS 记录（Name Server Record）  指定负责域名区域的DNS服务器
CNAME 记录（Canonical Name Record） 为一个域名提供别名
TXT 记录（Text Record） 提供任意文本信息。
PTR 记录（Pointer Record） 将IP地址映射回域名（反向DNS）。
SRV 记录（Service Locator Record） 指定提供特定服务的服务器地址和端口
SOA 记录（Start of Authority Record） 标识域名的权威DNS服务器。



host  #查询域名系统（DNS）并获取域名相关信息
host [选项] 域名 [服务器]
域名：要查询的域名。
服务器：可选，指定用于查询的DNS服务器。
常用选项
-a：显示所有记录。
-t：指定记录类型，如 A、MX、NS、TXT 等。
-v：显示详细输出。
-4：仅使用IPv4。
-6：仅使用IPv6。

host example.com
host -t MX example.com
host example.com 8.8.8.8

traceroute # 是一个网络诊断工具，用于追踪数据包从源主机到目标主机所经过的路径
traceroute [选项] 目标主机
目标主机：可以是域名或IP地址。

常用选项
-4：使用IPv4。
-6：使用IPv6。
-w：设置等待每个响应的超时时间（秒）。
-m：设置最大跳数。
-q：设置每个路由器的探测次数。


[root@m01 ~]# traceroute www.qq.com
traceroute to www.qq.com (58.246.163.58), 30 hops max, 60 byte packets
 1  gateway (10.0.0.254)  0.168 ms  0.092 ms  0.092 ms
 2  * * *

输出解释
traceroute 的输出通常包含以下列：
序号：每个路由器的序号。
IP地址：每个路由器的IP地址。
往返时间（RTT）：数据包从源主机到该路由器再返回源主机的平均时间（通常显示为三个值，分别对应三个探测包）。

某些防火墙或路由器可能配置为不响应 traceroute 的探测包，这会导致某些跳数显示为 * 或不显示。

tcpdump #强大的命令行网络分析工具，用于捕获和分析网络上的数据包
tcpdump [选项]
常用选项
-i：指定要监听的网络接口。例如，-i eth0 用于监听名为 eth0 的接口。
-n：以数字形式显示地址和端口号，而不是尝试解析为主机名和服务名。
-nn：以数字形式显示地址、端口号和协议名称。
-c：指定要捕获的数据包数量。
-w：将捕获的数据包写入文件，而不是直接显示在屏幕上。
-s：设置数据包捕获的大小。默认情况下，tcpdump 只捕获每个数据包的前68字节。
-X：以十六进制和ASCII码的形式显示数据包内容。
-S：以绝对序列号显示TCP数据包。
-v, -vv, -vvv：增加详细程度，-vvv 提供最详细的输出。

tcpdump -i eth0           #监听eth0接口上的所有数据包：
tcpdump -i eth0 tcp   
tcpdump -i eth0 'tcp port 80'  #监听eth0接口上的所有HTTP请求
tcpdump -c 10 -v  #捕获10个数据包并显示详细信息：
tcpdump -w capture.pcap  #捕获的数据写入文件
#pcap文件分析：捕获的数据包可以使用Wireshark等图形界面工具进行详细分析。


[root@m01 ~]# tcpdump -c 2 -v
tcpdump: listening on eth0, link-type EN10MB (Ethernet), capture size 262144 bytes
00:01:37.285591 IP (tos 0x10, ttl 64, id 49369, offset 0, flags [DF], proto TCP (6), length 164)
    m01.ssh > 10.0.0.1.tht-treasure: Flags [P.], cksum 0x149a (incorrect -> 0x3ef3), seq 3903155851:3903155975, ack 2971274083, win 298, length 124
    
00:01:37.286243 IP (tos 0x0, ttl 64, id 30759, offset 0, flags [DF], proto UDP (17), length 67)
    m01.56634 > gateway.domain: 9336+ PTR? 1.0.0.10.in-addr.arpa. (39)
2 packets captured
10 packets received by filter
0 packets dropped by kernel

输出解释
tcpdump 的输出通常包含以下信息：
时间戳：数据包捕获的时间。
源地址和目的地址：数据包的源IP地址和目的IP地址。
端口号：源端口和目的端口（对于TCP和UDP数据包）。
协议：数据包使用的协议（如TCP、UDP、ICMP等）。
数据包长度：数据包的长度。



```

## 有关磁盘与文件系统的命令

```bash
mount   # 用于挂载文件系统
mount [选项] 设备文件 挂载点
设备文件：表示要挂载的存储设备的文件路径，例如 /dev/sda1。
挂载点：系统目录树中的一个目录，作为挂载设备的入口点。
常用选项
-a：挂载 /etc/fstab 文件中列出的所有文件系统。
-t：指定文件系统的类型，如 ext4、xfs、vfat、ntfs 等。
-o：options 指定挂载选项，如 rw（读写模式）、ro（只读模式）、remount（重新挂载）、noexec（禁止执行程序）、nosuid（禁止set-user-id位）等。
-r：以只读模式挂载文件系统。
-w：以读写模式挂载文件系统。

挂载选项
-o 选项允许你指定挂载时使用的特定选项。一些常用的挂载选项包括：
rw/ro：以读写（rw）或只读（ro）模式挂载文件系统。
remount：重新挂载一个已经挂载的文件系统。常用于改变挂载选项，如从只读改为读写。
noexec：禁止在该文件系统上执行二进制文件。
async/sync：指定I/O操作是异步（async）还是同步（sync）执行。
auto/noauto：指定该文件系统是否在执行 mount -a 时自动挂载。
user/nouser：允许（user）或禁止（nouser）普通用户挂载文件系统。

mount  #命令用于显示已挂载的文件系统信息
sysfs on /sys type sysfs (rw,nosuid,nodev,noexec,relatime) 
表示 sysfs 文件系统已经被挂载到 /sys 目录上，并且具有以下挂载选项：
rw：表示该文件系统是以读写模式挂载的。
nosuid：表示不允许设置SUID位。这意味着即使文件或目录设置了SUID位，执行时也不会以文件所有者的身份执行，这增加了安全性。
nodev：表示不允许设备文件。这意味着 /sys 目录下的文件不会被视为设备文件，这有助于防止某些类型的攻击。
noexec：表示不允许在该文件系统上执行二进制文件。这有助于防止恶意代码的执行。
relatime：表示提供相对时间戳。这个选项优化了文件系统访问时间的记录，当文件被访问时，只有当文件的访问时间比其修改时间或状态改变时间更晚时，才会更新其访问时间。这可以提高性能，特别是在文件系统访问频繁的情况下。



mount /dev/sda1 /mnt/data
mount -t ext4 /dev/sda1 /mnt/data
mount -t nfs server:/path/to/share /mnt/nfs
mount -o remount,ro /  #重新挂载根文件系统为只读：
mount -a    #挂载所有在 /etc/fstab 中定义的文件系统
# -t vfat 指定了文件系统类型为 vfat（通常用于FAT32文件系统），/dev/sdb1 是USB驱动器的设备文件，/mnt/usb 是挂载点。
mount -t vfat /dev/sdb1 /mnt/usb

# 只读模式挂载一个分区
sudo mount -o ro /dev/sda1 /mnt/data



#注意
挂载点：挂载点目录必须事先存在，且在挂载前应为空目录。
卸载文件系统：使用 umount 命令来卸载已挂载的文件系统，例如 sudo umount /mnt/usb。
文件系统类型：正确识别并指定文件系统类型是成功挂载的关键。如果不确定文件系统类型，可以使用 lsblk 或 blkid 命令来查看。

umount #用于卸载已挂载文件系统
sudo umount /mnt/usb  #卸载挂载点
sudo umount /dev/sdb1  #卸载设备文件

#注意
卸载正在使用的文件系统：如果尝试卸载的文件系统正在被使用（例如，有程序或用户在访问挂载点），系统会阻止卸载操作。确保所有相关进程都已关闭或移动到其他目录。
卸载失败：如果 umount 命令失败，可能是因为文件系统正在被使用。可以使用 fuser 命令来找出并终止使用该文件系统的进程。

fuser -m /mnt/usb
sudo kill -9 $(fuser -m /mnt/usb)



df  #（disk free） 用于报告文件系统的磁盘空间使用情况
df [选项] [文件或目录]
常用选项
-h 或 --human-readable：以易于阅读的格式（例如 KB、MB、GB）显示磁盘空间。
-i 或 --inodes：显示索引节点的使用情况，而不是磁盘空间。
-T 或 --print-type：显示每个文件系统的类型。
-t 或 --target-directory：仅显示指定目录所在的文件系统的使用情况。
-x 或 --exclude-type：排除指定类型的文件系统。

df -h 
df /path/to/directory  #显示特定目录的使用情况
df -i     #显示索引节点的使用情况

df 命令的输出通常包含以下列：
filesystem 文件系统：文件系统的名称。
size 大小：文件系统的总大小。
used 已用：已使用的空间量。
avail 可用：剩余的可用空间量。
use% 使用%：已使用的空间占总空间的百分比。
 mounted on 挂载点：文件系统挂载的位置。

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


fsck #（File System Check）用于检查和修复文件系统一致性
fsck [选项] 文件系统设备或挂载点
检查并修复/dev/sda1分区上的文件系统，可以使用：fsck /dev/sda1
常用选项
-a或--auto：自动修复文件系统中的错误，无需用户交互（但对于一些严重错误可能仍然需要确认）。
-n或--no-act：仅执行检查，不实际进行修复操作，用于预览可能的修复措施。
-y或--yes：对于所有修复询问自动回答“是”，尽量减少交互。

fsck -a /dev/sdb1（假设/dev/sdb1是ext4文件系统分区）
fsck -n /dev/sdc1（查看/dev/sdc1分区的文件系统错误情况但不修复）

# 生产环境建议
fsck 之前,最好先卸载文件系统
关键业务系统,先备份
与mount和umount命令结合使用。在检查之前先卸载文件系统（umount），检查修复后再重新挂载（mount）。
例如：
umount /dev/sdd1（卸载分区）
fsck /dev/sdd1（执行检查和修复）
mount /dev/sdd1 /mnt（重新挂载到/mnt目录）


dd  #用于数据的复制、转换和备份
dd if=/dev/sda of=/dev/sdb
常用选项
if（input file）：指定输入文件或设备。
of（output file）：指定输出文件或设备。
bs（block size）：设置每次读写的块大小。
			例如：bs=4k表示块大小为 4KB，块大小的选择会影响数据传输的效率。
count：指定要复制的块数量。
			例如：count=100表示复制 100 个块。
status=progress  #显示dd命令的进度。



#创建一个大小为 10MB 的空文件empty_file
dd if=/dev/zero of=empty_file bs=1M count=10
#  ISO 文件刻录到 USB 设备
dd if=your_iso_file.iso of=/dev/sdc

#dd命令和cp命令的区别?
dd 更为底层和灵活的工具，能够进行按块级别的数据复制操作  还可以数据格式转换,处理设备文件,磁盘镜像制作
cp 用于文件和目录的复制，更侧重于文件系统层面的操作



dumpe2fs  #用于查看 ext2、ext3 或 ext4 文件系统详细信息
dumpe2fs [选项] 设备文件名
dumpe2fs /dev/sda1
常用选项
-h：只显示超级块和块组描述符信息，不显示完整的块组信息，这样可以使输出更简洁，快速获取关键信息。
-b：显示文件系统中坏块的信息。对于检测和了解文件系统中的物理存储问题很有帮助。
-f：显示文件系统特征标志信息。这些标志可以表明文件系统支持的特定功能或属性。

xfs_info是专门用于获取 XFS 文件系统详细信息的命令
xfs_info [挂载点或设备文件名]
xfs_info /dev/sda1
xfs_info /mnt/xfs

[root@m01 ~]# xfs_info /dev/sda1
meta-data=/dev/sda1              isize=512      agcount=4, agsize=65536 blks
               =                                sectsz=512    attr=2, projid32bit=1
               =                                crc=1             finobt=0 spinodes=0
data        =                                bsize=4096   blocks=262144, imaxpct=25
               =                                sunit=0          swidth=0 blks
naming   =version 2                 bsize=4096   ascii-ci=0 ftype=1
log          =internal                    bsize=4096   blocks=2560, version=2
               =                                sectsz=512    sunit=0 blks, lazy-count=1
realtime  =none                        extsz=4096   blocks=0, rtextents=0

输出解释
meta-data=/dev/sda1：文件系统的元数据存储在 /dev/sda1 设备上。
isize=512：索引节点大小为512字节。
agcount=4, agsize=65536 blks：文件系统被划分为4个分配组（allocation groups），每个分配组包含65536个块（block）。每个块大小为4096字节。
attr=2, projid32bit=1：文件系统支持扩展属性，并且项目ID（projid）是32位的。
crc=1：文件系统启用了元数据的循环冗余校验（CRC）。
finobt=0：文件系统没有使用自由空间的索引块树（free inode btree）。
spinodes=0：文件系统中没有特殊索引节点。
data=bsize=4096 blocks=262144, imaxpct=25：数据块大小为4096字节，总共有262144个数据块。imaxpct=25 表示索引节点最大可以占用文件系统总空间的25%。
sunit=0 swidth=0 blks：条带单元大小和条带宽度都是0，这通常意味着文件系统不是在RAID上创建的，或者条带信息没有被指定。
naming=version 2 bsize=4096 ascii-ci=0 ftype=1：文件命名使用版本2的命名规则，块大小为4096字节，不区分ASCII大小写（ascii-ci=0），文件类型（ftype=1）是启用的。
log=internal bsize=4096 blocks=2560, version=2：日志是内部的，大小为2560个块，日志版本为2。
sectsz=512 sunit=0 blks, lazy-count=1：扇区大小为512字节，日志的条带单元大小为0，延迟计数（lazy-count）是启用的。
realtime=none extsz=4096 blocks=0, rtextents=0：文件系统没有使用实时设备，实时区域的块大小为4096字节，没有实时块和实时区域扩展。




dump  #linux系统中用于备份文件系统
#dump 通常用于创建文件系统的完整备份（全备份）或增量备份（只备份自上次备份以来发生变化的数据）。与 tar 不同，dump 是专门为备份文件系统设计的，因此它能够处理文件系统的特殊结构和属性。

dump [选项] 备份级别 目标文件系统
备份级别：指定备份的类型，可以是0到9之间的数字。0代表全备份，1到9代表增量备份。
目标文件系统：指定要备份的文件系统。
选项：可以指定不同的选项来控制备份的行为，如 -f 指定输出文件，-u 更新备份记录文件等。
常用选项
-f：指定备份输出的目标位置，可以是文件或设备。
-u：更新备份记录文件，记录备份的时间和级别。
-0 到 -9：指定备份级别，-0 是全备份，-1 到 -9 是增量备份。
-C：指定备份的文件系统大小，用于优化备份过程。
-s：指定备份的磁带长度（以1024字节块为单位）。
-S：显示备份的估计大小。
-W：显示需要备份的文件系统列表。

#执行全备份并保存到文件 
#-0 表示全备份，-u 表示更新备份记录文件（通常是 /etc/dumpdates），-f 指定备份文件的路径。
dump -0u -f /path/to/backup_file /dev/sda1

#执行增量备份： -1 表示第一级增量备份。
dump -1u -f /path/to/backup_file /dev/sda1

# dump 命令创建的备份可以通过 restore 命令来恢复
# -r 表示进入交互式恢复模式，-f 指定备份文件的路径。
restore -r -f /path/to/backup_file
选择恢复操作：在交互式模式下，你可以选择不同的命令来恢复文件系统或文件。
cd 目录：改变当前目录到指定目录。
ls：列出当前目录下的文件和目录。
pwd：显示当前目录的路径。
add 文件或目录：将文件或目录添加到恢复列表。
delete 文件或目录：从恢复列表中删除文件或目录。
extract：从备份中提取文件或目录。
quit：退出 restore。

使用 extract 命令从备份中提取文件或目录。

# 示例
mkdir /mnt/restore
mount -o loop /path/to/backup_file /mnt/restore  #  1挂载备份文件
restore -r -f /path/to/backup_file   #2进入交互式恢复模式
在 restore 提示符下，使用 cd 和 ls 命令导航到你想要恢复的文件或目录。
使用 add 命令添加文件或目录到恢复列表。
使用 extract 命令提取文件或目录。
使用 quit 命令退出 restore。
umount /mnt/restore  #卸载备份文件


xfsdump ,xfsrestore  # 专门用于XFS文件系统的备份和恢复工具
xfsdump [选项] 备份级别 备份目标 源文件系统或目录
源文件系统：要备份的XFS文件系统的设备文件名，如 /dev/sda1。
备份文件：备份数据将被写入的文件或设备。
常用选项
-l 级别：指定备份级别，级别0是完全备份，级别1到9是增量备份。
-L 标签：为备份指定一个标签，便于识别。
-M 备份介质ID：指定一个备份介质ID，用于标识备份介质。
-f 文件名：指定输出的备份文件名或设备。

mkdir -p /path/to/
 xfsdump -l 0 -L full_backup -M backup_media_id -f /path/to/backup_file /dev/mapper/centos-root
# 执行了一个级别0的完全备份，备份标签为 full_backup，介质ID为 backup_media_id，备份文件保存在 /path/to/backup_file

# xfsrestore 用于从 xfsdump 创建的备份中恢复文件系统或文件。
xfsrestore [选项] [命令] 备份文件   [目标目录]
备份文件：包含备份数据的文件或设备。
目标目录：备份数据将被恢复到的目录。
常用选项
-f 文件名：指定输入的备份文件名或设备。
-L 标签：指定要恢复的备份标签。
-i：进入交互式恢复模式，允许用户选择要恢复的文件和目录。
-J：跳过备份文件的完整性检查。

mkdir /mnt/restore
xfsrestore -f /path/to/backup_file -L full_backup /mnt/restore



fdisk #用于磁盘分区
# fdisk 可以列出、创建、删除和修改磁盘分区。它支持多种类型的分区表，包括MBR（Master Boot Record）和GPT（GUID Partition Table）

fdisk [选项] 设备名
设备名：要操作的磁盘设备，例如 /dev/sda。
常用选项
-l：列出所有分区表和分区信息。
-u：与 -l 选项一起使用，显示分区的扇区数而不是块数。
-b：指定分区表的大小（通常用于GPT）。

fdisk -l
# fdisk 交互式界面 
sudo fdisk /dev/sda
fdisk 交互式命令
在 fdisk 的交互式界面中，你可以使用以下命令：
m：显示帮助信息。
p：显示当前分区表。
n：创建新分区。
d：删除现有分区。
t：更改分区类型。
w：写入分区表并退出。
q：不保存更改并退出。

示例
1.创建新分区：
在 fdisk 交互式界面中，输入 n 创建新分区，然后按照提示操作。
2.删除分区：
在 fdisk 交互式界面中，输入 d 删除现有分区，然后按照提示操作。



# 如何查看当前磁盘是不是gpt 分区表
[root@m01 ~]# fdisk -l /dev/sdb
Disk /dev/sdb: 21.5 GB, 21474836480 bytes, 41943040 sectors
 设备名            总容量      总字节数                    总扇区数
Units = sectors of 1 * 512 = 512 bytes
                扇区大小和逻辑/         物理块大小
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: gpt  #显示了磁盘的分区表类型 dos表示mbr(Master boot Record)分区表
Disk identifier: 23DF68CC-FEFC-4958-AF88-BFE61521B9D0  #磁盘的唯一标识符
#         Start          End           Size  Type                Name
 1         2048     41943006     20G  Linux filesyste Linux filesystem
 
 -------------------------dos类型
 Disk label type: dos
Disk identifier: 0x000c84a4
  Device Boot      Start         End           Blocks          Id  System
/dev/sda1   *        2048     2099199       1048576      83  Linux
/dev/sda2         2099200   104857599    51379200   8e  Linux LVM
Start / End: 分区的起始和结束扇区。
Blocks: 分区的大小，以块为单位
Id: 分区类型代码。
System: 分区类型描述。




 
gdisk  #使用gpt分区表

[root@m01 ~]# gdisk -l /dev/sdb
GPT fdisk (gdisk) version 0.8.10

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.
Disk /dev/sdb: 41943040 sectors, 20.0 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): 23DF68CC-FEFC-4958-AF88-BFE61521B9D0
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 41943006
Partitions will be aligned on 2048-sector boundaries
Total free space is 2014 sectors (1007.0 KiB)

Number  Start (sector)    End (sector)  Size         Code     Name
   1            2048                41943006   20.0 GiB    8300  Linux filesystem

gdisk  /dev/sdb   #交互式操作, 和fdisk 操作类似


parted  # 适用于创建、删除、调整大小和管理磁盘分区, 大于2TB的分区用它处理
parted [选项] [设备名]
常用选项
-l 或 --list：列出所有分区表和分区信息。
-s 或 --script：以脚本模式运行，不显示任何提示信息。
-v 或 --version：显示 parted 的版本信息。
parted -l

parted /dev/sda   #parted 交互式界面：
在 parted 的交互式界面中，你可以使用以下命令：
print：显示当前分区表。
mklabel：创建新的分区表。
mkpart：创建新的分区。
rm：删除分区。
resizepart：调整分区大小。
quit：退出 parted。

# 实战 
# 1 确定分区的磁盘设备
 fdisk -l /dev/sdb  # 或者 lsblk
parted /dev/sdb #2 进入交互式界面
mklabel gpt    # 3 创建一个新的GPT分区表（如果你的磁盘大于2TB，或者你想要使用GPT分区表）
mkpart primary ext4 1MiB 100MiB  # 创建一个主分区，类型为ext4，从1MiB到100MiB
这里，mkpart 命令的参数解释如下：
primary：分区类型，可以是 primary、extended 或 logical。
ext4：文件系统类型，可以是 fat32、xfs、ext4 等。
1MiB：分区的起始位置。
100MiB：分区的结束位置。
# 4: 退出 parted
quit
# 格式化新分区
mkfs.ext4 /dev/sda1



mkfs  #make filesystem 用于创建文件系统, 
# 将一个分区或存储设备格式化为特定类型的文件系统，如ext2、ext3、ext4、xfs、vfat
mkfs [选项] [-t 文件系统类型] 设备名
常用选项
-t：指定要创建的文件系统类型。
-c：在创建文件系统之前检查设备上的坏块。
-L：设置文件系统的卷标。
-m：设置文件系统的保留空间百分比。
-v：显示详细信息。
文件系统类型：指定要创建的文件系统类型，如 ext4、xfs、vfat 等。

mkfs -t ext4 /dev/sda1
mkfs -t xfs /dev/sda1
mkfs -t vfat /dev/sda1



partprobe  #用于通知操作系统内核分区表已经更改，无需重启系统
# 当你对磁盘进行分区操作（如使用 fdisk、parted 等工具添加、删除或修改分区）后，内核可能不会立即意识到这些更改。运行 partprobe 可以让内核重新读取分区表，从而识别新的分区或分区更改。

partprobe /dev/sdb   # 通知内核分区表已更改：

# 查看内核分区表是不是更新 的命令
blkid 是一个用于显示块设备属性的命令行工具，包括分区的UUID、文件系统类型等
parted -l  用于列出所有分区信息。
fdisk -l  列出所有分区信息
lsblk     列出所有可用块设备信息


e2fsck  #用于检查和修复第二扩展文件系统（ext2）、扩展文件系统（ext3）和扩展文件系统4（ext4）的工具

e2fsck [选项] 设备名
设备名：要检查的文件系统所在的设备，例如 /dev/sda1。
常用选项
-f：强制检查，即使文件系统看起来是干净的。
-p：自动修复文件系统中发现的任何错误。
-y：对所有问题自动回答“是”，不提示用户。
-v：详细模式，显示正在执行的操作。
-c：在检查文件系统之前，扫描设备以寻找坏块。
-b superblock：指定备用超级块的位置，以防主超级块损坏。

e2fsck /dev/sda1       # 检查 /dev/sda1 文件系统：
e2fsck -f -p /dev/sda1  #强制检查并自动修复错误
e2fsck -v /dev/sda1     #详细模式检查

# xfs 文件系统使用  xfs_repair 
# 修复XFS文件系统中的错误，它可以在文件系统未挂载或以只读方式挂载时运行。
xfs_repair [选项] 设备名
常用选项
-f：强制检查，即使文件系统看起来是干净的。
-L：丢弃日志（仅在文件系统严重损坏时使用，会丢失所有未提交的更改）。
-n：执行非交互式修复，不写入任何更改到文件系统。
-v：详细模式，显示正在执行的操作。

xfs_repair /dev/sda1
xfs_repair -f /dev/sda1
xfs_repair -v /dev/sda1




mkswap  # （swap space） 创建交换分区或交换文件。
# 交换空间是硬盘上的一块区域，当物理内存（RAM）用尽时，操作系统会使用它来存储暂时不活跃的内存数据。
mkswap [选项] 设备名或文件名
设备名或文件名：指定要设置为交换空间的分区或文件。
常用选项
-L：指定交换空间的标签。
-U：指定交换空间的UUID。

mkswap /dev/sda5  #设置 /dev/sda5 分区为交换空间：

# 设置一个交换文件
dd if=/dev/zero of=/swapfile bs=1G count=4
chmod 600 /swapfile
mkswap /swapfile

#激活交换空间 swapon
swapon /dev/sda5
swapon /swapfile
# 要使交换空间在系统启动时自动激活，需要将它添加到 /etc/fstab 文件中
swapon -s   # 显示当前激活的交换空间列表。
cat /etc/fstab
/swapfile none swap sw 0 0

/etc/fstab（文件系统表）是一个配置文件，它定义了在系统启动时自动挂载的文件系统
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
六个字段，字段之间用空格或制表符分隔：
1.设备文件或UUID
2.挂载点：指定设备或文件系统应该挂载到的目录路径。
3.文件系统类型：指定文件系统的类型，如 ext4、xfs、vfat、ntfs 等。
4.挂载选项：指定挂载时使用的选项，如 rw（读写模式）、ro（只读模式）、noexec（禁止执行程序）、nosuid（禁止set-user-id位）等。
5.dump选项：用于 dump 命令，指定是否需要备份该文件系统。通常设置为 0（不备份）。
6.文件系统检查顺序：指定 fsck 命令在启动时检查文件系统的顺序。
         根文件系统（/）通常设置为 1，其他文件系统设置为 2。如果设置为 0，则不进行检查。





sync  #用于将所有未写入磁盘的文件系统缓冲区数据强制写入磁盘

# 在关闭或重启系统之前，运行 sync 命令可以确保所有文件系统的更改都被写入磁盘。
#  在编写脚本时，如果需要确保数据被写入磁盘，可以在脚本中加入 sync 命令



resize2fs # resize2fs 是一个用于调整（ext2（ext3（ext4）大小的命令行工具
resize2fs [选项] 设备名 [新大小]
设备名：要调整大小的文件系统所在的设备，例如 /dev/sda1。
新大小：可选，指定新的文件系统大小。如果未指定，resize2fs 将尝试使用设备的全部可用空间。
常用选项
-p：在调整大小的过程中显示进度信息。
-f：强制调整大小，即使新大小大于文件系统实际占用的空间。

# /dev/sda1 是一个挂载的 ext4 文件系统
# 扩展它到设备的全部可用空间
sudo resize2fs /dev/sda1

sudo resize2fs /dev/sda1 10G  # 将 /dev/sda1 文件系统调整为10GB大小

# 注意: 
文件系统未挂载或只读挂载: 文件系统未挂载或只读挂载 才能使用
检查文件系统：在调整文件系统大小之前，建议先运行 e2fsck 来检查文件系统是否有错误

XFS文件系统:    xfs_growfs
# xfs_growfs 用于扩展XFS文件系统，使其占据整个分区或逻辑卷的剩余空间。
# 请注意，xfs_growfs 不能用于缩小文件系统，只能用于扩展。

xfs_growfs /mnt/data  #扩展挂载在 /mnt/data 的XFS文件系统到其分区的全部可用空间：

xfs_growfs 命令本身不支持直接指定文件系统的新大小。
如果你需要将XFS文件系统扩展到特定的大小，你需要先扩展底层的分区或逻辑卷，然后再使用 xfs_growfs 来扩展文件系统。

要扩展分区或逻辑卷，你需要使用分区工具，如 fdisk、gdisk、parted（对于GPT分区表）或逻辑卷管理工具（如 lvextend 对于LVM）。以下是使用 lvextend 扩展LVM逻辑卷的示例：
sudo lvextend -L 新大小 /dev/逻辑卷组/逻辑卷
-L：指定新的逻辑卷大小。
/dev/逻辑卷组/逻辑卷：逻辑卷的设备路径。

lvextend -L 100G /dev/mapper/vg00-lv_data  #扩展逻辑卷到100GB
xfs_growfs /mnt/data     #扩展文件系统到逻辑卷的新大小



```



## 关机和查看系统信息的命令

```bash
shutdown  #用于关闭或重启Linux系统的命令行工具
shutdown [选项] 时间 [警告信息]
时间：指定系统关闭或重启的时间。可以是绝对时间（如 hh:mm）或相对时间（如 +m，表示从现在起m分钟后）。
警告信息：在系统关闭或重启前，向所有用户广播的信息。
常用选项
-h：关闭系统（halt）。
-r：重启系统（reboot）。
-c：取消已经安排的关闭或重启。
-t：设置延迟时间，单位为秒。

shutdown -h now  #立即关闭系统
shutdown -r now   #立即重启
shutdown -h +10   #10分钟后关闭
shutdown -r +10
shutdown -c   #取消安排的关机或重启
shutdown -h +5 "System will shutdown in 5 minutes for maintenance."  #5分钟后关机,并向所有用户广播




halt   #用于停止Linux系统运行的命令
halt [选项]
常用选项
-p 或 --poweroff：在停止系统后关闭电源。
		电源管理：使用 -p 选项可以关闭电源，这在服务器或台式机上可能需要额外的硬件支持。
-h 或 --halt：仅停止系统，不关闭电源。
-f 或 --force：强制停止系统，即使某些进程拒绝关闭。
-i 或 --init：在停止系统之前，使用init程序来停止所有进程。

halt      #立即停止系统
halt -p  #立即停止系统并关闭电源： 
halt -f   #强制停止系统
halt -i   #在停止系统之前使用init程序停止所有进程



init  # init 是一个传统的系统初始化程序，用于启动、停止和管理运行在Linux系统上的进程

配置文件
/etc/inittab：在较旧的系统中，init 使用 /etc/inittab 文件来配置启动过程。这个文件定义了运行级别（runlevels）和每个运行级别下应执行的命令。
/etc/init：在一些较新的系统中，如使用Upstart的系统，init 使用 /etc/init 目录下的配置文件来管理服务。

运行级别
init 使用运行级别（runlevels）来定义系统启动的不同状态。每个运行级别都与一组特定的服务和进程相关联。
常见的运行级别包括：
0：关机（halt）
1：单用户模式（single-user mode）
2：多用户模式，不使用网络服务
3：完全多用户模式，使用网络服务
4：未分配（用户自定义）
5：图形界面多用户模式
6：重启（reboot）

init [运行级别]  0/1/2/3/5/6  #命令切换


什么是Upstart和systemd？
Upstart和systemd都是Linux系统中用于初始化和管理系统服务的工具，它们替代了传统的init系统

Upstart
Upstart是由Ubuntu的开发者设计的，旨在解决传统init系统的一些限制，如启动速度慢、并行启动服务的能力有限等问题。Upstart的主要特点包括：

-并行启动服务：Upstart可以并行启动多个服务，而不是像传统init那样按顺序一个接一个地启动。
-事件驱动：Upstart使用事件驱动模型，服务启动和停止可以基于特定事件的发生，如设备添加、网络可用等。
-易于配置：Upstart的配置文件通常位于/etc/init目录下，每个服务或任务都有自己的配置文件，使得管理更加灵活。
Upstart在Ubuntu 14.10及更早版本中被使用，但在后续版本中被systemd取代。

systemd
systemd是目前最流行的初始化系统和系统管理器，被许多现代Linux发行版采用，包括Fedora、Debian、Arch Linux、CentOS等。systemd的主要特点包括：

-并行启动服务：systemd可以并行启动多个服务，显著加快了系统启动速度。
-单元（Unit）系统：systemd使用单元（unit）的概念来管理服务、挂载点、套接字等。每个单元都有一个.service、.mount、.socket等后缀的配置文件。
-日志管理：systemd自带了日志管理工具journalctl，可以方便地查看系统日志。
-资源控制：systemd可以控制服务的资源使用，如CPU和内存限制。
-依赖性管理：systemd可以管理服务之间的依赖关系，确保服务按正确的顺序启动和停止。
systemd的设计目标是提供一个更快速、更高效、更易于管理的系统初始化和管理框架。




```



## 系统管理相关命令

```bash
uptime  # 上面有
top      #上面有
ps  # （process status）显示当前系统中进程的快照
# 提供关于正在运行的进程的详细信息，包括进程ID、进程状态、使用的CPU和内存资源、启动时间、命令名
ps [选项]
常用选项
-e 或 -A：显示所有进程。
-f：显示完整格式的输出，包括父进程ID、启动时间等。
-u：显示指定用户的进程。
-U：显示指定用户ID的进程。
-p：指定进程ID。
-C：显示指定命令名的进程。
-N：显示不属于指定命令名的进程。
-t：显示指定终端上的进程。
-x：显示没有控制终端的进程。
-o：指定输出格式，后面跟上需要显示的列名，如 pid,ppid,cmd,stat,rss,vsz,etime,command。


ps -ef  #显示完整格式的进程信息
ps -u username  # 特定用户的进程
ps -C command_name # 显示特定命令名的进程
ps -eo pid,ppid,cmd,stat,rss,vsz,etime,command   #自定义输出格式
ps axu   
To print a process tree:
  ps -ejH
  ps axjf
          
[root@m01 ~]# ps -ef |head
UID   PID   PPID  C STIME TTY          TIME CMD
root    1      0       0 18:19  ?        00:00:01 /usr/lib/systemd/systemd --switched-root --system --deserialize 22
root    2      0       0 18:19  ?        00:00:00 [kthreadd]
root    4      2       0 18:19  ?        00:00:00 [kworker/0:0H]        
ps -ef 输出的列说明：
1.UID：用户ID（User ID），表示启动该进程的用户。
2.PID：进程ID（Process ID），唯一标识每个进程。
3.PPID：父进程ID（Parent Process ID），表示该进程的父进程。
4.C：CPU利用率，表示该进程占用CPU的百分比。
5.STIME：进程启动时间（Start Time），表示进程启动的时间。
6.TTY：终端类型（Terminal Type），表示进程启动时所在的终端设备。
7.TIME：进程使用的CPU时间（CPU Time），表示该进程自启动以来所占用的CPU时间。
8.CMD：命令名（Command），表示启动该进程的命令。

[root@m01 ~]# ps axu |head
USER PID %CPU %MEM    VSZ  RSS TTY   STAT START   TIME COMMAND
root   1      0.0      0.3       43540  3968 ?      Ss   18:19   0:01 /usr/lib/systemd/systemd --switched-root --system --deserialize 22
root   2      0.0      0.0           0            0 ?      S     18:19   0:00 [kthreadd]
root   4      0.0      0.0           0            0 ?      S<   18:19   0:00 [kworker/0:0H]

ps axu 输出的列说明：
1.USER：启动进程的用户名称。
2.PID：进程ID（Process ID），唯一标识每个进程。
3.%CPU：进程占用CPU的百分比。
4.%MEM：进程占用内存的百分比。
5.VSZ：虚拟内存大小，以千字节为单位。
6.RSS：常驻集大小，即进程占用的物理内存大小，以千字节为单位。
7.TTY：启动进程的终端设备。
8.STAT：进程状态，
			例如 R 表示运行中，S 表示睡眠中，D 表示不可中断的睡眠状态，Z 表示僵尸进程，T 表示停止状态。
9.START：进程启动时间。
10.TIME：进程自启动以来所占用的CPU时间。
11.COMMAND：启动进程的命令名。



free  #上面有

vmstat  #（Virtual Memory Statistics）是一个用于报告系统内存、进程、I/O、CPU等信息
#它提供了一个系统性能的快照，包括虚拟内存、内核线程、磁盘、系统进程、I/O块设备和CPU活动的信息
vmstat [选项] [刷新间隔 [次数]]
刷新间隔：指定报告之间的时间间隔，单位为秒。
次数：指定报告的次数。如果不指定次数，vmstat 将无限期地每秒报告一次，直到你手动停止它（通常是通过按 Ctrl+C）。

[root@m01 ~]# vmstat 2 5
procs  -----------memory---------- ---swap-- -----io---- -system-- ------cpu-----
 r  b    swpd   free       buff  cache     si   so       bi    bo     in   cs      us sy  id  wa st
 2  0      0    797792   2108  88676     0    0       10     1      17   37      0  0 100  0  0
 0  0      0    797792   2108  88708     0    0        0      0      11   16      0  0 100  0  0
 0  0      0    797792   2108  88708     0    0        0      0      15   17      0  0 100  0  0
 0  0      0    797792   2108  88708     0    0        0      0      12   15      0  0 100  0  0
 0  0      0    797792   2108  88708     0    0        0      0      14   16      0  0 100  0  0

vmstat 的输出通常分为几个部分：
1.Procs：进程信息
r：等待运行的进程数。
b：处于不可中断睡眠状态的进程数。
2.Memory：内存使用情况
swpd：虚拟内存使用量。
free：空闲内存量。
buff：用作缓冲的内存量。
cache：用作缓存的内存量。
3.Swap：交换空间使用情况
si：每秒从磁盘交换到内存的量。
so：每秒从内存交换到磁盘的量。
4.IO：输入/输出
bi：每秒从块设备读取的块数。
bo：每秒向块设备写入的块数。
5.System：系统活动
in：每秒中断数，包括时钟中断。
cs：每秒上下文切换数。
6.CPU：CPU使用情况
us：用户空间占用CPU的百分比。
sy：内核空间占用CPU的百分比。
id：空闲CPU百分比。
wa：等待I/O的CPU时间百分比。
st：被偷取时间的百分比（在虚拟化环境中，指被其他虚拟机占用的时间）。



mpstat #用于报告多处理器系统中每个可用处理器的CPU使用情况
# 它提供了关于CPU活动的详细信息，包括用户空间、内核空间、空闲时间、等待I/O的时间等
mpstat [选项] [刷新间隔 [次数]]
刷新间隔：指定报告之间的时间间隔，单位为秒。
次数：指定报告的次数。如果不指定次数，mpstat 将无限期地每秒报告一次，直到你手动停止它（通常是通过按 Ctrl+C）
[root@m01 ~]# mpstat 2 5
Linux 3.10.0-1160.71.1.el7.x86_64 (m01)         08/14/2024      _x86_64_        (1 CPU)

09:00:02 PM  CPU    %usr   %nice  %sys %iowait %irq   %soft  %steal  %guest  %gnice   %idle
09:00:04 PM  all        0.00    0.00    0.00    0.00      0.00    0.00    0.00       0.00       0.00      100.00
09:00:06 PM  all        0.00    0.00    0.00    0.00      0.00    0.00    0.00       0.00       0.00      100.00
09:00:08 PM  all        0.00    0.00    0.50    0.00      0.00    0.00    0.00       0.00       0.00       99.50
09:00:10 PM  all        0.00    0.00    0.00    0.00      0.00    0.00    0.00       0.00       0.00      100.00
09:00:12 PM  all        0.00    0.00    0.00    0.00      0.00    0.00    0.00       0.00       0.00      100.00
Average:        all        0.00    0.00    0.10    0.00      0.00    0.00    0.00       0.00       0.00       99.90
mpstat 的输出通常分为几个部分：
CPU：显示每个CPU的统计信息。
%usr：在用户空间运行的CPU使用率。
%nice：在用户空间以nice优先级运行的CPU使用率。
%sys：在内核空间运行的CPU使用率。
%iowait：等待I/O操作完成的CPU使用率。
%irq：处理硬件中断的CPU使用率。
%soft：处理软件中断的CPU使用率。
%steal：虚拟机管理程序偷取CPU时间的百分比（在虚拟化环境中）。
%guest：在虚拟处理器上运行客户机的CPU使用率。
%gnice：表示高优先级用户态（niced）的 CPU 时间百分比.  
				具有特定高优先级设置或特殊调整的用户态进程所占用的时间.
%idle：CPU空闲时间的百分比。


iostat #用于监控系统输入/输出设备负载
# 提供关于CPU使用率、设备I/O负载、吞吐量等的详细统计信息
iostat [选项] [刷新间隔 [次数]]
刷新间隔：指定报告之间的时间间隔，单位为秒。
次数：指定报告的次数。如果不指定次数，iostat 将无限期地每秒报告一次，直到你手动停止它（通常是通过按 Ctrl+C）。

[root@m01 ~]# iostat 1 5
Linux 3.10.0-1160.71.1.el7.x86_64 (m01)         08/14/2024      _x86_64_        (1 CPU)

avg-cpu:  %user   %nice %system %iowait  %steal   %idle
                   0.02    0.00    0.10         0.00         0.00    99.88

Device:     tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
sda          0.51         8.77         0.87           89237       8899
sdb          0.02         0.52         0.00            5275          0
dm-0       0.31         7.59         0.67           77250       6851
dm-1       0.01         0.22         0.00            2204          0
tps 显示了每秒传输的I/O请求数。
kB_read/s 和 kB_wrtn/s 分别显示了每秒读取和写入的数据量（以千字节为单位）。
kB_read 和 kB_wrtn 显示了总共读取和写入的数据量。


CPU部分
%user：在用户级别运行应用程序所占用的CPU百分比。
%nice：在用户级别运行应用程序，且优先级被调整（nice）所占用的CPU百分比。
%system：在系统级别运行内核进程所占用的CPU百分比。
%iowait：CPU空闲时等待I/O操作完成的时间所占的百分比。
%steal：虚拟机管理程序（hypervisor）为了另一个虚拟处理器而偷取（steal）当前虚拟处理器的时间所占的百分比。
%idle：CPU空闲且没有等待I/O操作的时间所占的百分比。





sar(sysstats包)  # System Activity Reporter）是一个用于收集、报告和保存系统活动信息
# sar 可以收集和报告CPU使用率、内存使用、磁盘I/O、网络活动、进程创建活动等多种系统资源的使用情况
常用选项
-u：显示CPU使用率信息。
-d：显示磁盘I/O信息。
-r：显示内存使用情况。
-n：显示网络统计信息。
-b：显示I/O和传输速率统计信息。
-P：显示指定CPU的信息。
-w：显示进程创建和切换统计信息。


sar -u 2 5  #每10秒收集一次CPU使用率信息，共收集5次：
sar -d 2 10  #每5秒收集一次磁盘I/O信息，共收集10次

[root@m01 ~]# sar -d 2 1
Linux 3.10.0-1160.71.1.el7.x86_64 (m01)         08/14/2024      _x86_64_        (1 CPU)

09:17:14 PM       DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
09:17:16 PM    dev8-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
09:17:16 PM   dev8-16      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
09:17:16 PM  dev253-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
09:17:16 PM  dev253-1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

Average:          DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
Average:       dev8-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:      dev8-16      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:     dev253-0      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
Average:     dev253-1      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00

DEV: 设备名称，
tps: 每秒传输次数，即每秒I/O请求的次数。
rd_sec/s: 每秒读取扇区数。
wr_sec/s: 每秒写入扇区数。
avgrq-sz: 平均请求扇区大小。
avgqu-sz: 平均队列长度，即在I/O请求队列中等待的请求数。
await: 平均等待时间（毫秒），即请求从提交到完成的平均时间。
svctm: 平均服务时间（毫秒），即完成一个I/O请求所需的时间。
%util: 磁盘使用率，表示磁盘在I/O请求期间的忙碌百分比。

tps: 如果 tps 的值很高，表明有很多I/O请求正在被处理。如果 tps 的值很低，但 await（平均等待时间）很高，这可能表明磁盘I/O性能瓶颈。
rd_sec/s 和 wr_sec/s: 这些值显示了每秒读取和写入的扇区数。扇区大小通常是512字节，因此这些值可以转换为字节/秒。
avgrq-sz: 这个值表示平均请求的大小。较大的值可能表明有大块数据的读写操作。
avgqu-sz: 如果这个值很高，可能表明有较多的I/O请求在队列中等待，这可能指示了磁盘I/O瓶颈。
await: 这个值是请求从提交到完成的平均时间。如果这个值很高，可能表明磁盘I/O性能不佳。
svctm: 这个值表示完成一个I/O请求所需的平均时间。如果 svctm 很高，而 await 也很高，这可能表明磁盘性能不佳。
%util: 这个值表示磁盘在I/O请求期间的忙碌百分比。如果这个值接近100%，表明磁盘几乎一直在处理I/O请求。


[root@m01 ~]# sar -r 2 1
Linux 3.10.0-1160.71.1.el7.x86_64 (m01)         08/14/2024      _x86_64_        (1 CPU)

09:34:05 PM kbmemfree kbmemused  %memused kbbuffers  kbcached  kbcommit   %commit  kbactive   kbinact   kbdirty
09:34:07 PM    797508    198132     19.90      2108     73092    219504      7.10     52880     55880         0
Average:       797508    198132     19.90      2108     73092    219504      7.10     52880     55880         0
输出通常包含以下列：
kbmemfree：系统中空闲的物理内存总量（KB）。
kbmemused：系统中已使用的物理内存总量（KB）。
%memused：已使用的物理内存占总物理内存的百分比。
kbbuffers：内核使用的缓冲区大小（KB）。
kbcached：内核使用的缓存大小（KB）。
kbcommit：为了满足系统当前需求，内核预留的内存总量（KB），包括已使用的和未使用的。
%commit：kbcommit 占系统总内存（物理内存+交换空间）的百分比，表示系统预留的内存相对于总内存的比例。
kbswapped：从交换空间读取或写入的内存总量（KB）。
%swpused：已使用的交换空间占总交换空间的百分比。
kbswpfree：系统中空闲的交换空间总量（KB）。

sar -n   用于报告网络相关的统计信息
sar -n [选项] [时间间隔] [次数]
时间间隔：指定两次报告之间的间隔时间（秒）。
次数：指定报告的次数。
选项
-n 后面可以跟不同的关键字来指定你想要查看的网络相关的统计信息类型。这些关键字包括：
E：显示网络接口统计信息。
SOCK：显示套接字使用统计信息。
IP：显示IP协议统计信息。
EIP：显示以太网和IP协议统计信息。
ICMP：显示ICMP协议统计信息。
TCP：显示TCP协议统计信息。
UDP：显示UDP协议统计信息。
RAW：显示原始套接字统计信息。
ALL：显示所有网络相关的统计信息。







chkcofnig  #一个在基于System V的初始化系统中用于管理服务的命令行工具，它允许用户设置服务在不同运行级别下的启动和停止
# chkconfig 主要用于较旧的Linux发行版，而较新的发行版（如基于systemd的发行版）则使用 systemctl 命令来管理服务
chkconfig [选项] [服务名]
服务名：你想要管理的服务名称。
常用选项
--list [服务名]：列出指定服务或所有服务在各个运行级别下的启动状态。
--add 服务名：向chkconfig管理列表中添加一个新服务。
--del 服务名：从chkconfig管理列表中删除一个服务。
--level 运行级别：指定服务在哪些运行级别下启动或停止。

chkconfig --list  # 列出所有服务的状态：
chkconfig --list httpd 
chkconfig httpd on   #设置服务在所有运行级别下启动
chkconfig httpd off
chkconfig --level 35 httpd on # 设置 httpd 服务在运行级别3和5下启动。


systemctl   #用于控制 systemd 系统和服务管理器的命令行工具
systemctl [命令] [服务名]
命令：指定要执行的操作，如 start、stop、restart、status 等。
服务名：指定要操作的服务名称。
常用命令
start：启动一个服务。
stop：停止一个服务。
restart：重启一个服务。
status：显示服务的状态。
enable：在启动时启用服务。
disable：在启动时禁用服务。
reload：重新加载 systemd 管理器的配置。
list-units：列出所有活动的单元文件。
list-unit-files：列出所有已安装的单元文件及其状态。

systemctl start httpd
systemctl stop httpd
systemctl restart httpd
systemctl status httpd

systemctl enable httpd  #httpd 服务在系统启动时自动启动
systemctl disable httpd  #httpd 服务在系统启动时不自动启动。

```

## 系统安全相关命令

```bash
chmod  #用于改变文件或目录权限
chmod [选项] 模式 文件或目录
模式：指定新的权限模式。可以使用数字模式（八进制）或符号模式（字母和符号）。
文件或目录：要修改权限的文件或目录。

权限模式
-数字模式
权限用三位八进制数表示，每一位代表一类用户的权限：

第一位：文件所有者（owner）的权限。
第二位：与文件所有者同组（group）用户的权限。
第三位：其他用户（others）的权限。
-rw-r--r-- 1 root root 21 Aug 10 21:31 file1.txt

每个位置的数字是以下三个权限的总和：
读（read）：4
写（write）：2
执行（execute）：1
例如，权限 755 表示所有者有读、写、执行权限（4+2+1=7），同组用户和其他用户有读和执行权限（4+1=5）。

- 符号模式
使用字母和符号来指定权限：
u：文件所有者（user）。
g：与文件所有者同组的用户（group）。
o：其他用户（others）。
a：所有用户（all）。
+：添加权限。
-：移除权限。
=：设置权限。
例如，chmod u+x file 会给文件所有者添加执行权限。

chmod 755 file
chmod u=rwx,g=rx,o=rx file
chmod a-w file

常用组合命令
查看文件权限：ls -l filename
更改文件所有者：chown user filename
更改文件所属组：chgrp group filename
递归更改目录权限：chmod -R 755 directory


chown #（change owner） 用于更改文件或目录的所有者和/或所属组
chown [选项] 用户名[:组名] 文件或目录
用户名：新的所有者用户名。
组名：可选，新的所属组名称。
-R：递归地更改目录及其内容的所有者和/或所属组
 chown newuser filename
 chown newuser:newgroup filename
 chown :newgroup filename
 chown -R newuser directory #递归更改目录及其内容的所有者

chgrp   #（change group）  用于更改文件或目录的所属组的命令
chgrp [选项] 组名 文件或目录
组名：新的所属组名称。
-R：递归地更改目录及其内容的所属组
chgrp newgroup filename
chgrp -R newgroup directory




chage  #  #用于管理用户密码过期信息  # 上面有

passwd  # 用于更改用户账户密码
选项
-l：锁定指定用户的账户，使其无法登录。
-u：解锁指定用户的账户。
-d：删除指定用户的密码，使其无需密码即可登录。
-e：强制指定用户在下次登录时更改密码。
-S：显示指定用户的密码状态。
passwd username   # 更改其他用户的密码
passwd -l username
passwd -u username
passwd -d username
passwd -e username
passwd -S username
echo "newpassword" | sudo passwd --stdin username   #一行命令修改用户密码,
 
 
su        #上面有
sudo    #上面有

umask #（用户文件创建掩码）用于设置默认权限
# 当你创建新文件或目录时，系统会根据 umask 值来确定这些新创建的文件和目录的权限
umask [掩码值]
掩码值：指定新的 umask 值。如果不指定，umask 命令将显示当前的 umask 值。
权限计算
umask 值通常以八进制数表示，它从完全权限中减去，以确定新创建文件或目录的默认权限。例如：

对于文件，默认的完全权限是 666（即 -rw-rw-rw-）。
对于目录，默认的完全权限是 777（即 drwxrwxrwx）。
umask 值从这些完全权限中减去，以得到实际的默认权限。

示例
假设当前的 umask 值是 0022：
新创建的文件默认权限将是 666 - 022 = 644（即 -rw-r--r--）。
新创建的目录默认权限将是 777 - 022 = 755（即 drwxr-xr-x）。

umask 0027  #临时修改掩码值
注意事项
-安全性：选择合适的 umask 值对于系统安全非常重要。一个较严格的 umask 值（如 0027 或 0077）可以防止其他用户访问新创建的文件和目录。
-默认值：不同的系统和用户可能有不同的默认 umask 值。通常，系统级的 umask 值在 /etc/profile 或 /etc/bashrc 中设置，而用户级的 umask 值在用户的家目录下的 .bashrc 或 .profile 文件中设置。
-持久化设置：如果你希望 umask 值在每次登录时都生效，可以将 umask 命令添加到用户的 .bashrc 或 .profile 文件中。


chattr  #上面有
lsattr   #上面有

```

## 查看系统用户登录信息的命令

```bash
whoami  #用于显示当前用户的有效用户ID
[root@m01 ~]# whoami
root



who  #用于显示当前登录到系统的用户信息
输出解释
用户名：登录系统的用户名称。
终端：用户登录的终端设备。例如，pts/0 表示伪终端设备，tty1 表示物理控制台。
登录时间：用户登录系统的时间。
远程主机：如果用户是通过网络远程登录的，这里会显示远程主机的地址。
[root@m01 ~]# who
root     tty1         2024-08-14  18:20
root     pts/0        2024-08-14 18:22 (10.0.0.1)


w  # 与 who 命令类似，w 提供了关于登录用户的信息，但它还提供了额外的细节，如用户登录后执行的命令、用户空闲时间、CPU使用情况等。

[root@m01 ~]# w
 22:20:53 up  4:01,  2 users,  load average: 0.00, 0.01, 0.05
USER     TTY      FROM           LOGIN@   IDLE    JCPU   PCPU WHAT
root     tty1                            18:20         3:58m  0.02s  0.02s -bash
root     pts/0    10.0.0.1         18:22         5.00s    0.11s  0.00s w
输出列解释
1.用户名：当前登录系统的用户名称。
2.终端：用户登录的终端设备。例如，pts/0 表示伪终端设备，tty1 表示物理控制台。
3.从哪里登录：用户从哪个IP地址或主机登录。这通常显示为远程主机的名称或IP地址。
4.登录时间：用户登录系统的时间。如果用户已经登录了很长时间，这个字段可能显示为 n/a 或者显示登录时间。
5.空闲时间：用户自上次活动以来的空闲时间。如果用户正在活动，这个字段可能显示为 .。
6.JCPU：与该终端相关的所有进程的CPU时间。这包括所有在该终端上运行的进程的CPU使用时间。
7.PCPU：当前正在运行的进程的CPU时间。这通常显示为用户当前活动的进程的CPU使用时间。
8.当前活动：用户当前执行的命令或活动。这可以是用户正在运行的命令，或者显示用户当前的活动状态，例如 w 命令本身。



last    #用于显示系统登录历史
last [选项] [用户]
用户：可选，指定特定用户的登录历史。
常用选项
-a：在输出的最后添加主机名的IP地址。
-d：将IP地址转换为主机名。
-f 文件名：指定一个文件来代替 /var/log/wtmp。
-n 数量：限制输出的记录数量。
-x：显示系统关机、运行级别变更等额外信息。
last   #显示所有用户的登录历史：
last username  #显示特定用户的登录历史
last -n 10        #显示最后10条记录
last -x | grep "Failed"  #显示登录失败尝试

last 命令的输出通常包含以下列：
用户名：登录系统的用户名称。
终端：用户登录的终端设备。例如，pts/0 表示伪终端设备，tty1 表示物理控制台。
主机名：用户登录的远程主机名或IP地址。
登录时间：用户登录的时间。
登出时间：用户登出的时间。如果用户仍然登录，这将显示为 still logged in。
持续时间：用户登录的持续时间。



lastlog  #用于查看系统中所有用户最后一次登录信息
# 它从 /var/log/lastlog 文件中读取数据，该文件记录了每个用户的最后一次登录时间、登录地点（终端或远程主机）以及登录状态（成功或失败）
lastlog [选项]
常用选项
-u 用户名：显示指定用户的最后一次登录信息。
-b 天数：显示指定天数前的最后一次登录信息。
-t 天数：显示指定天数内的最后一次登录信息。
lastlog
lastlog -u username   #username 的用户的最后一次登录信息
lastlog -b 30  # 超过30天没有登录的用户列表



users   #用于显示当前登录到系统的所有用户
[root@m01 ~]# users
root root
输出解释
用户名列表：输出的每一项代表一个当前登录的用户。如果多个用户登录到同一个终端，它们的名字会连续显示，用空格分隔。


finger  #用于显示本地或远程系统上用户信息
#查看用户账户的详细信息，包括用户名、真实姓名、登录状态、登录时间、终端位置等
#finger 命令在早期的Unix系统中非常流行，但现在在许多现代Linux发行版中可能默认不安装。
[root@m01 ~]# finger -l
Login: root                             Name: root
Directory: /root                        Shell: /bin/bash
On since Wed Aug 14 18:20 (CST) on tty1    4 hours 13 minutes idle
On since Wed Aug 14 18:22 (CST) on pts/0 from 10.0.0.1
   7 seconds idle
No mail.
No Plan.
[root@m01 ~]# finger -s
Login     Name       Tty      Idle  Login Time   Office     Office Phone   Host
root      root       tty1     4:14  Aug 14 18:20
root      root       pts/0          Aug 14 18:22                           (10.0.0.1)
```



## 其他

```bash
echo #用于在命令行界面中输出指定的字符串或变量值 ;经常用于脚本编写和命令行操作中。
echo [选项] [字符串]
字符串：要输出的文本或变量值。
[root@m01 ~]# echo Hello, World!
Hello, World!
[root@m01 ~]# MY_VAR="Hello, World"
[root@m01 ~]# echo $MY_VAR    #输出变量值
Hello, World

使用选项：
-n：不输出末尾的换行符。
-e：启用解释反斜杠转义字符（如 \n 表示换行，\t 表示制表符）。
echo -n "No newline at the end"
echo -e "This is a tab\tseparated line"

# 注意事项
引号：使用引号（单引号或双引号）:
单引号会阻止变量扩展和转义字符的解释，
而双引号允许变量扩展和转义字符的解释。




printf  #用于格式化并输出字符串
printf format [arguments]
format：指定输出格式的字符串。
arguments：要格式化并输出的变量或值。
printf "Hello, World!\n"

[root@m01 ~]# NAME="Alice"
[root@m01 ~]# printf "Hello, %s! \n" $NAME
Hello, Alice!
[root@m01 ~]# printf "Hello, %s\\n" $NAME
Hello, Alice

[root@m01 ~]# printf "%-10s %5d\n" "Name" 123   #指定宽度和对齐：
Name         123

printf "%.2f\n" 123.4567    #指定精度



rpm  #（RPM包管理器） 用于安装、卸载、更新、查询和验证软件包

sudo rpm -ivh package_name.rpm
-i：安装软件包。
-v：详细模式，显示安装过程中的详细信息。
-h：显示安装进度。

rpm -e package_name
-e：卸载软件包。

 rpm -Uvh package_name.rpm
-U：升级软件包，如果软件包不存在，则安装它。

rpm -q package_name
-q：查询软件包。

rpm -ql package_name
-l：列出软件包安装的所有文件。

rpm -V package_name
-V：验证软件包。


yum   #（Yellowdog Updater Modified）  它用于安装、更新、删除和管理软件包，以及处理软件包之间的依赖关系
#yum 通过与远程仓库通信来下载和安装软件包，这些仓库包含了大量预先编译好的软件包。

yum install package_name
yum update package_name
yum remove package_name
yum update     #升级所有可升级的软件包。
yum upgrade   #升级整个系统，包括内核和所有软件包。

#查询软件包
yum search keyword
yum list package_name

yum clean all       #清理缓存
yum makecache  #用于生成和更新 yum 仓库元数据缓存的命令
yum list installed  #列出已安装的软件包
yum info package_name  #查询软件包详情
yum deplist package_name  #检查软件包依赖性
yum provides commond  #根据命令找软件包


apt # apt（Advanced Package Tool）软件包管理工具
apt update    #更新软件包列表 ; 即从软件仓库获取最新的软件包信息
apt upgrade  #升级所有已安装的软件包到最新版本
apt install package_name
apt remove package_name
apt search keyword
apt show package_name


dpkg（Debian package manager）# 用于安装、构建、删除和管理软件包
dpkg -i package_file.deb
dpkg -r package_name  #删除软件包
dpkg -L package_name   #列出软件包中所有文件：
dpkg -s package_name   #查询状态
dpkg --fix-broken   #修复损坏的软件包
dpkg -l    #列出所有已安装的包

watch   #它用于周期性地执行指定的命令，并将输出结果以全屏方式显示
watch [选项] 命令
命令：你希望周期性执行的命令。
常用选项
-n 秒数 或 --interval=秒数：设置命令执行的间隔时间，默认为2秒。
-d 或 --differences[=cumulative]：高亮显示输出中变化的部分。
-t 或 --no-title：不显示标题栏。
-h 或 --help：显示帮助信息。
-v 或 --version：显示版本信息
watch -n 5 ls       #每5秒执行一次 ls 命令，并显示结果
watch -d df -h    #df -h 命令，并高亮显示输出中变化的部分
watch -n 10 top  #每10秒执行一次 top 命令，并显示结果。

alias  #用于创建命令别名的shell内建命令
alias 别名='实际命令'
别名：你希望用来代表实际命令的简短名称。
实际命令：你希望别名代表的完整命令或命令序列。
alias ll='ls -l'
alias work='cd /path/to/your/work/directory'
alias    #查看当前定义的所有别名

unalias 别名  #删除别名
unalias ll


date  ##用于显示和设置系统的日期和时间;  #上面有


clear   #清屏   快捷键 ctrl +l

history  #用于显示用户在当前终端会话中执行过的命令历史记录
常用选项
-c：清除历史记录。
-d：删除指定序号的命令。
-w：将历史记录写入历史文件（覆盖旧的历史记录）。
history -c
history -d 3
# 注意事项
历史记录文件：命令历史记录通常保存在用户的家目录下的 .bash_history 文件中（对于使用bash shell的用户）。如果终端会话被关闭，历史记录将被保存到这个文件中。
历史记录数量：默认情况下，历史记录的数量是有限制的，可以通过修改shell配置文件（如 .bashrc 或 .bash_profile）来调整这个限制。
隐私和安全：由于历史记录中可能包含敏感信息，确保在共享终端或在公共环境中使用时采取适当的安全措施。


eject  #用于弹出或卸载可移动媒体，如CD-ROM、DVD-ROM、软盘驱动器或USB闪存驱动器
常用选项
-t：锁定媒体托盘，防止自动弹出。
-f：强制弹出设备，即使设备当前被使用。
-r：弹出CD-ROM或DVD-ROM。
-h：弹出软盘驱动器。
-v：详细模式，显示额外的信息。
eject /dev/cdrom
eject



time   #用于测量命令执行时间的实用工具
[root@m01 ~]# time ls
[root@m01 ~]# time -p ls  #-p 选项将提供更详细的输出
输出解释
real：实际时间，即从命令开始到结束的总时间。
user：用户CPU时间，即命令在用户模式下运行所消耗的CPU时间。
sys：系统CPU时间，即命令在内核模式下运行所消耗的CPU时间。


nohup  #用于运行命令，使其在用户注销或终端关闭后继续运行
# nohup 是 "no hang up" 的缩写，意味着即使终端会话结束，运行的命令也不会被挂起或终止
nohup 命令 [参数] &
命令：你希望在后台运行的命令。
参数：传递给命令的任何参数。
&：将命令放入后台执行。

nohup ping localhost &    #在后台运行命令：

nohup ping localhost > ping_output.txt 2>&1 &  #重定向输出
#ping 命令的输出重定向到 ping_output.txt 文件中。2>&1 是将标准错误（stderr）重定向到标准输出（stdout）的常用方法。


2>&1 是一个常见的重定向操作符组合，用于将标准错误（stderr）重定向到标准输出（stdout）
尤其是在需要将命令的输出和错误信息都重定向到同一个文件时。
符号说明
2：代表标准错误（stderr），是程序输出错误信息的通道。
1：代表标准输出（stdout），是程序输出正常信息的通道。
>：重定向操作符，用于将输出重定向到文件或设备。
&：当与数字一起使用时，它表示一个文件描述符。当单独使用时，它表示标准输出（stdout）


文件描述符：在Unix系统中，
            0 代表标准输入（stdin），
            1 代表标准输出（stdout），
            2 代表标准错误（stderr）。

常用的重定向操作符：
标准输出和标准错误的重定向
>： 将标准输出重定向到文件。如果文件已存在，它会被覆盖。
>>： 将标准输出追加到文件。如果文件已存在，新的输出会被添加到文件的末尾。
2>： 将标准错误重定向到文件。如果文件已存在，它会被覆盖。
2>>： 将标准错误追加到文件。如果文件已存在，新的输出会被添加到文件的末尾。
同时重定向标准输出和标准错误
&> 或 >&： 将标准输出和标准错误都重定向到同一个文件。这等同于 > file 2>&1。
&>>： 将标准输出和标准错误都追加到同一个文件。这等同于 >> file 2>&1。
关闭文件描述符
n<&-： 关闭文件描述符 n。
<&-： 关闭标准输入（文件描述符 0）。
n>&-： 关闭文件描述符 n 的输出。
重定向到文件描述符
n>： 将文件描述符 n 的输出重定向到文件。
n>>： 将文件描述符 n 的输出追加到文件。
n>&： 将文件描述符 n 的输出重定向到另一个文件描述符。
从文件描述符读取
<n： 从文件描述符 n 读取输入。
示例
3>&1： 将文件描述符 3 的输出重定向到标准输出（文件描述符 1）。
1>&3： 将标准输出（文件描述符 1）的输出重定向到文件描述符 3。




screen   #创建多个虚拟终端（也称为窗口），在这些窗口中运行多个程序
#screen 可以在断开连接后继续运行程序，并在重新连接时恢复会话。
sudo apt-get install screen   # Debian/Ubuntu
sudo yum install screen       # CentOS/RHEL
常用命令
创建新窗口：Ctrl-A 然后按 C。
切换窗口：Ctrl-A 然后按 0 到 9（数字键），或者按 " 然后输入窗口编号。
分离会话：Ctrl-A 然后按 D。这将使你从 screen 会话中分离，程序继续在后台运行。
列出窗口：Ctrl-A 然后按 "。
杀死窗口：Ctrl-A 然后按 K。
重新连接会话：screen -r 或 screen -r [session_id]。

示例
1.启动 screen 会话：
screen   #这将启动一个新的 screen 会话。
2.在 screen 会话中创建新窗口：
Ctrl-A C   # 这将在当前 screen 会话中创建一个新的窗口。
3.分离当前 screen 会话：
Ctrl-A D   #这将使你从当前 screen 会话中分离，程序继续在后台运行。
4.列出所有 screen 会话：
screen -ls
5.重新连接到特定的 screen 会话：
screen -r [session_id]
其中 [session_id] 是你从 screen -ls 命令中得到的会话ID。

```



## 系统性能监视高级命令

```bash
内存： top  free vmstat mpstat iostat sar
cpu:  top   vmstat  mpstat iostat sar
I/O   vmstat  mpstat  iostat sar
进程： ipcs  ipcrm  lsof strace ltrace
负载：  uptime


ipcs # 用于报告关于进程间通信设施状态
ipcs [选项]
常用选项
-a 或 --all：显示所有可用的IPC资源信息。
-m 或 --shmems：仅显示共享内存段的信息。
-q 或 --queues：仅显示消息队列的信息。
-s 或 --semaphores：仅显示信号量的信息。
-u 或 --summary：显示摘要信息，包括每个类型IPC资源的总数、最大数量和当前使用量。

[root@m01 ~]# ipcs -a

------ Message Queues --------
key        msqid      owner      perms      used-bytes   messages

------ Shared Memory Segments --------
key        shmid      owner      perms      bytes      nattch     status

------ Semaphore Arrays --------
key        semid      owner      perms      nsems


输出解释
ipcs -a 的输出通常分为三个部分，每个部分对应一种类型的IPC资源：

1. 消息队列（Message Queues）
key：消息队列的键值，用于创建和访问消息队列。
msqid：消息队列标识符。用于在系统中唯一标识一个消息队列。
owner：创建消息队列的用户。
perms：消息队列的权限。
used-bytes：消息队列中已使用的字节数。表示当前消息队列中存储的消息所占用的字节数。
messages：消息队列中的消息数量。即当前消息队列中包含的消息总数。

2. 共享内存段（Shared Memory Segments）
key：共享内存的键值。它是创建共享内存时指定的键，可以是一个整数或者通过特殊方式生成的键。键用于在不同的进程之间识别和访问同一段共享内存。
shmid：共享内存标识符。这是一个整数，用于在系统中唯一标识一段共享内存。不同的共享内存段有不同的shmid。
owner：创建共享内存的用户。通常显示为用户名或用户 ID。
perms：共享内存的权限。通常用八进制数表示，如600、644等。它规定了不同用户（所有者、同组用户、其他用户）对共享内存的访问权限，如读、写、执行等。
bytes：共享内存的大小，以字节为单位。表示该段共享内存所占用的存储空间大小。
nattch：连接到该共享内存的进程数量。即有多少个进程正在使用或连接到这段共享内存。
status：共享内存的状态标志。可能包括一些状态信息，如是否正在被使用、是否已删除等。

3. 信号量（Semaphores）
key：信号量的键值，用于创建和访问信号量。
semid：信号量标识符。类似于共享内存的shmid，用于唯一标识一个信号量集合。
owner：创建信号量的用户。
perms：信号量的权限设置。
nsems：信号量集合中的信号量数量。一个信号量集合可以包含多个信号量。


ipcrm # 用于删除消息队列、共享内存段和信号量等进程间通信（IPC）资源
ipcrm [选项] [资源类型] [资源标识符]
资源类型：指定要删除的IPC资源类型，可以是 msg（消息队列）、shm（共享内存）或 sem（信号量）。
资源标识符：指定要删除的特定IPC资源的标识符。
示例
1.删除消息队列：
ipcrm msg msgid
这里 msg 表示资源类型为消息队列，msgid 是消息队列的标识符。
2.删除共享内存段：
ipcrm shm shmid
这里 shm 表示资源类型为共享内存，shmid 是共享内存段的标识符。
3.删除信号量：
ipcrm sem semid
这里 sem 表示资源类型为信号量，semid 是信号量集的标识符。



strace  #监控和记录一个进程对系统调用和接收到的信号的调用情况
# 查看进程正在执行哪些系统调用，以及这些调用的参数和返回值
strace [选项] 命令 [参数]
命令：你想要监控的程序。
参数：传递给程序的参数。
常用选项
-f：跟踪由子进程产生的所有系统调用。
-e：指定要跟踪的特定系统调用或系统调用类型。
-o：将输出重定向到文件。
-p：指定要跟踪的进程ID。
-s：指定输出的字符串的最大长度。
-t：在每行输出前加上时间戳。
-tt：在每行输出前加上微秒级的时间戳。
-T：显示系统调用所花费的时间。
-v：显示所有系统调用的详细信息。

示例
1.跟踪一个程序的系统调用：
strace ls   # 这将显示 ls 命令执行时调用的所有系统调用。
2.跟踪特定的系统调用：
strace -e open ls
这将仅显示 ls 命令中调用 open 系统调用的情况。
3.跟踪一个进程：
strace -p 1234
4.将输出重定向到文件：
strace -o output.txt ls



ltrace   #用于跟踪程序运行时调用的库函数
# 与 strace 相比，strace 用于跟踪系统调用，而 ltrace 用于跟踪程序调用的动态链接库（DLL）中的函数
ltrace [选项] 命令 [参数]
命令：你想要监控的程序。
参数：传递给程序的参数。
常用选项
-c：统计每个库函数调用的次数和总时间。
-f：跟踪子进程的库函数调用。
-l：仅跟踪指定库中的函数。
-p：指定要跟踪的进程ID。
-s：指定输出的字符串的最大长度。
-t：在每行输出前加上时间戳。
-tt：在每行输出前加上微秒级的时间戳。
-T：显示库函数调用所花费的时间。

示例
1.跟踪一个程序的库函数调用：
ltrace ls     #这将显示 ls 命令执行时调用的所有库函数。
2.统计函数调用次数和时间：
ltrace -c ls   # 这将统计 ls 命令中每个库函数调用的次数和总时间。
3.跟踪特定的库函数：
ltrace -l libpthread.so ls
这将仅显示 ls 命令中调用 libpthread.so 库中的函数的情况。
4.跟踪一个进程：
ltrace -p 1234





```



```bash

关机/重启/注销命令（7）
关机重启： shutdown init halt  poweroff reboot
注销退出： logout exit  ctl+d ---》快捷键（生产常用）

进程管理（16）
bg： 将暂停的作业放到后台继续运行。
fg： 将后台作业调到前台运行。
jobs ： 查看当前终端会话中的作业列表，包括后台作业和暂停的作业。

正在运行一个命令，如 vim test.txt，然后按下 Ctrl + Z 暂停该命令，此时它处于暂停状态。
jobs 查看作业列表，会看到该作业处于暂停状态。
bg %作业编号   将其放到后台继续运行，它会在后台执行。
fg %作业编号，它就会回到前台继续运行。

[root@m01 ~]# jobs
[1]+  Stopped                 vim test.txt
[root@m01 ~]# bg %1
[1]+ vim test.txt &
[root@m01 ~]# fg %1
vim test.txt


kill， killall ， pkill ： 杀掉进程
kill -9 1234 # -9信号 1234进程id号
killall httpd # 通过进程名称来终止进程
pkill -u username ;# 可以终止指定用户的所有进程 
pkill -t pts/0     #终止与指定终端相关的进程。

kill -l 命令用于列出系统中所有可用的信号名称及其对应的数字
# 信号是一种用于进程间通信（IPC）的机制，允许一个进程向另一个进程发送消息
以下是一些常用的信号及其用途：
SIGHUP (1)： 挂起信号，通常由终端断开连接时发送给前台进程组。
SIGINT (2)：  中断信号，通常由按下 Ctrl+C 时发送给前台进程。
SIGQUIT (3)：退出信号，通常由按下 Ctrl+\ 时发送给前台进程。
SIGKILL (9)：  强制终止信号，不能被捕获或忽略，用于立即终止进程。
SIGTERM (15)：终止信号，是 kill 命令默认发送的信号，可以被捕获或忽略，用于请求进程终止。
SIGSTOP (19)：停止信号，不能被捕获或忽略，用于暂停进程。
SIGCONT (18)：继续信号，用于从暂停状态恢复进程。


crontab: # 安排和管理计划任务（cron jobs）
# 它允许用户设置定时执行的命令或脚本，这些命令或脚本可以在指定的时间自动运行，无需人工干预。crontab 文件通常由系统守护进程 cron 管理，该守护进程会定期检查 crontab 文件并执行其中的计划任务。

crontab [选项] [文件]
选项：可以指定不同的选项来控制 crontab 的行为。
文件：指定一个包含计划任务的文件。如果未指定文件，crontab 将使用标准输入。
常用选项
-e：编辑用户的 crontab 文件。
-l：列出用户的 crontab 文件内容。
-r：删除用户的 crontab 文件。
-i：在删除 crontab 文件之前提示用户确认。
-u 用户名：指定要操作的用户的 crontab 文件。

crontab 文件格式
crontab 文件中的每一行代表一个计划任务，格式如下：

* * * * * command_to_execute
从左到右，五个星号分别代表：
分钟（0-59）
小时（0-23）
日期（1-31）
月份（1-12）
星期几（0-7，其中0和7都代表星期天）

crontab -e  #编辑当前用户的 crontab 文件：
crontab -l
crontab -r
crontab -ri

0 1 * * * /path/to/backup.sh  #每天凌晨1点执行 backup.sh 脚本。



ps： 查看进程
pstree： 显示进程树
top： 显示进程
nice：改变优先权
nohup： 用户退出系统后继续工作
pgrep： 查找匹配条件的进程
strace： 跟踪一个进程的系统调用
ltrace： 跟踪进程调用库函数的情况 
vmstat: 报告虚拟内存统计信息
runlevel  init  service

非常危险的系统命令
mv rm fdisk parted dd  

linux 系统四位剑客
grep （egrep ） sed  awk find







```



## linux bash快捷键

```bash
Tab          自动补全
Ctrl + a  把光标移动到行首
Ctrl + e  把光标移动到行尾
Ctrl + c  取消 cancel
Ctrl + d  退出当前用户
Ctrl + l  清屏
Ctrl + u  把光标所在位置到行首的内容删除（剪切）
Ctrl + k  把光标所在位置到行尾的内容删除（剪切）
ctrl + y  粘贴
ctrl+s     锁屏
ctrl+q/c   解锁
Ctrl + r   搜索最近使用的命令 不对继续按ctrl+r
```









以后linux 命令问题请按 介绍,语法,常用选项,示例,生产环境建议及常用组合命令

