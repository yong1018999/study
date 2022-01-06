#!/bin/bash
#日志以当期日期重命名
rename_file(){
    mv  /var/log/messages /var/log/messages-`date +%Y-%m-%d`  
}   
#删除三个月前的日志文件
# rm_file(){
#     find /var/log/ -mtime +92 -type f -name *.messages- exec rm -f  
# }

# `xx`
# $xx
# ${xx}
for i in `1..100`
do
    echo $i
done

rm_file_jane() {
    for i in `ls /var/log/messages-*`
    do
        echo $i
        export filename=$i
        # 截取字符串。以/var/log/messages-为分隔
        export filedate=`echo $i | awk -F'-' '{print $2}'`
        echo $filedate
        # convert to date
        echo date - `date -d $filedate -d '2010-01-01'`

        # date +%Y%m%d
    done

}

{
#   rename_file
#   rm_file 
    rm_file_jane

}




find /var/log/ -mtime +91 -name "messages-*" -exec rf {}\

