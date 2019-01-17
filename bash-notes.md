# Learning BASH via abs
1,特殊字符使用  

    #   --> 注释(不包括#!)
        --> 变量替换使用 echo ${PATH#*:}
    ;   --> 命令分隔符,用于连接多个命令
    ;;  --> 用于终止一个case语句
    .   --> 等同于source命令
        --> 可作为隐藏文件的文件名开头
        --> 相对路径的表示,当前路径和父目录路径
        --> 匹配单个字符
    ''  --> 忽略所有特殊字符,全部引用
    ""  --> 忽略除去`,$,\外所有的特殊字符,部分引用
    ,   --> 连接一串运算,只返回最后一个的结果
            let "t2 = ((a = 9, 15 / 3))"          ## set "a=9" and "t2 = 15 / 3"
        --> for file in /{,usr/}bin/*calc         ## 与{}一起使用,用作选择的一种,简略代码
    1.1 变量替换中的大小写替换
        echo ${var,}   --> 第一个字符小写
        echo ${var,,}  --> 所有字符小写
        echo ${var^}   --> 第一个字符大写
        echo ${var^^}  --> 所有字符大写
    \   --> 脱意符,除去特殊字符的含义,\X等效与'X'
    `   --> 运算符,将命令的输出结果作为内容传递给变量
    :   --> 空命令,no op,执行结果返回值为0
        --> 在if/then记过中作为占位符使用
            if condition;then :;else action;done
        --> 为需要二进制文件存在的场合提供占位符
            : ${username=`whoami`}   |  : ${1?"Usage: $0 ARGUMENT"}
        --> 作为切片使用,同python中的切片
            ${var:1} ${var:3:3}
        --> 同重定向一同使用,用于清空一个文件而不更改其权限,如果文件不存在,则创建该文件
            : > /tmp/testfile
        --> 可以用作注释符使用,但与#不同,:仍然会检查注释内容中命令是否正确
        --> 用作/etc/passwd文件和$PATH的分隔符
    !   --> 更改命令返回值,反转test命令的含义
        --> ${!variable},获取变量$variable的变量值
        --> 调用历史命令,在脚本中无法使用
    *   --> 通配符,用以指代在给定的目录下的任何文件
        --> 在正则表达式中,表示任意数量的(包括0)xxx
        --> 运算符,**便是乘方
    ?   --> 在双括号结构中,可以用做判断
            (( var0 = var1<98?9:21 ))
        --> 变量替换,当parameter不存在是,打印err_msg内容,返回值为1,两种形式的差别仅当parameter被声明且为空值时有差别
            ${parameter?err_msg}, ${parameter:?err_msg}
        --> 通配符,给定目录中的单字符文件名,在扩展正则表达式中代表单个字符
    $   --> 变量替换
        --> 锚定符,代表行尾
    ${} --> 参数替换
    $*  --> 位置参数
    $@  --> 位置参数
    $?  --> 命令返回值
    $$  --> 进程ID
    ()  --> 小括号中的一组命令开启一个子shell,在脚本当中,其他部分无法读取括号中定义的变量
        --> 用于数组的初始化
            Array=(e1 e2 e3)
    {}  --> 大括号展开
            echo {file1,file2}\ :{\ A," B",' C'}
        --> 扩展大括号展开
            echo {a..e}
        --> 代码块,内联组(inline group), anonymous function, the variate in the inline group \
            can be seen in the scripts anywhere
            { read line1
              read line2
            } < /tmp/passwd line1和line2可以直接读取passwd中的文件内容
            在{}中的代码块,一般情况下不会开启一个新的子shell
        --> {}可以用在非标准的for循环当中
            for ((n=1; n<=10; n++)); { echo -n "* $n *"; }
        --> many commands can be used in a {} section, just like a function, return the outcome
        --> 占位符, use with xargs; 'ls . | xargs -i -t cp ./{} $1'
    {} \; --> 该结构用在find架构当中,不作为shell的关键字存在
            The ";" ends the -exec option of a find command sequence. It needs to be escaped to protect it from interpretation by the shell.
    []  --> test命令,[是test命令的内置指令(test的同义字),并不是test的链接
        --> 数组元素,用于展开各个序号的数组元素
        --> 正则表达式中使用,用于表示一个序列
            "[B-Pk-y]"
    $[] --> 运算符,等效与(())
            echo $[$a+$b]

    $[...] --> 整数扩展符, 可用于整数的计算; 'echo $[3*5]'
            
    (())--> 运算符
            (( a = 23 )); (( a++ ))
    <>  --> 重定向,包含>,&>,>&,>>,<,<>
        --> &> 把标准输出和标准错误都重定向
        --> >&2重定向到标准错误
        --> >> 追加
        --> [i]<>filename 打开文件filename读写,分配文件描述符i给文件,若i不存在,则默认使用stdin
        --> (command)> 进程替换, 暂且记下,后续有具体讲解
        --> << here document
        --> <<< here string
        --> askii 比较,对比文本字符顺序
    \>  --> 单词边界,同时还有\<
            grep '\<the\>' textfile
    [[]]--> test,比[]更灵活
    |   --> 管道,将命令的输出作为输入传递给下一个命令
            echo ls -l | sh  ## 可以作为一种方式执行命令
        --> 管道运行在子shell当中,所以不能在管道中定义变量
            variable="initial_value";echo "new_value" | read variable;echo "variable = $variable"  # variable = initial_value
    >|  --> 强制重定向,强制清空文件内容,即使已经设置了noclobber属性已经设置了
    ||  --> 或逻辑运算符,在test结构中使用
    &   --> 在后台运行任务,在脚本中,命令甚至是循环结构可以运行在后台中
            for i in {1..10};do echo -n "$i"; done &
            脚本中包含后台运行的命令可能会导致脚本hang死,可以设置补救措施;
            a,在后台命令后面增加一个wait命令可以解决该问题
            b,在将结果重定向至/dev/null或者一个文件也可
            ls -l &; ehco "Done."; wait
    &&  --> 逻辑和运算符,用于test结构中
    -   --> 选项前缀, ls -l
        --> 从stdin重定向输入或从stdout重定向输入
            1, (cd /source/directory && tar cf - . ) | (cd /dest/directory && tar xpvf -)
            2, bunzip2 -c linux-2.6.16.tar.bz2 | tar xvf -
            3, grep Linux file1 | diff file2 -
        --> 前一个工作目录,由$OLDPWD变量保存
        --> 减号,用作逻辑运算符
    --  --> 命令长格式选项前缀
            ls --all
        --> 与set结合使用,设置位置参数
            variable="one two three four five"
            set -- $variable;
            first_param=$1
            second_param=$2
            shift; shift
            echo "first parameter = $first_param"    # one
            echo "second parameter = $second_param"  # two
    =   --> 赋值运算符;a=28
    +   --> 逻辑运算符,相加
        --> 正则表达式,1各或者多个
        --> 特定命令的参数前缀,+为开启,-为关闭,如set命令
    %   --> 逻辑运算符,余
    ~   --> 家目录,由$HOME保存
    ~+  --> 当前工作目录,由$PWD保存
    ~-  --> 上一个工作目录,由$OLDPWD保存
    =~  --> 正则表达式中匹配
            variable="This is a fine mess."
            if [[ "$variable" =~ T.........fin*es* ]]

    ^   --> 行开头
        --> 参数替换中,大写替换
    ^^  --> 参数替换中,大写替换
    ' ' --> 空格,用作命令或者是变量的分隔
2,变量及参数

    1, 变量名是变量值的占位符,获取变量值的操作称之为变量替换
    2, 变量裸露的情况(没有前缀'$'符)
        --> 变量声明或者是赋值的时候
        --> 取消变量unset
        --> 被export
        --> 逻辑运算表达式(())中
    3, 变量的赋值可以在如下结构中
        --> '='中
        --> read结构
        --> 类似for var in xx的循环结构中
    4, 变量引用中
        --> 使用$a,不用""括起来,移除变量中的tab和newline
        --> 使用"$a",保存whitespace(空白)
    5, 使用$(...)替换`...`来进行变量赋值
    6, shell变量没有类型
    7, 特殊类型的变量
        --> 本地变量: 只在代码块或者是函数中可见
        --> 环境变量: 影响shell动作的变量,如PATH或者是PS1等
        --> 位置参数: $0,$1这些,$0表示脚本;$*和$@代表所有的位置参数
    8, 每次新建shell,在shell中会创建相应的环境变量
    9, 使用export命令来将本地变量变成环境变量
        --> 脚本中,变量只能export给子子进程,也即在脚本中声明的变量无法作用于脚本之外
	10,shift命令的作用是重新赋值位置参数,每执行一次,位置参数向左偏移一位
		--> 默认可调用10个
		--> $0不参与
		--> 被重新赋值的变量是move,不是copy(只有两个位置参数,shift后,$2不存在)
		--> shift可接受数字,表示每次偏移多少

    append:
    1, 脚本名称不变,使用软链接给创建多个脚本名称,调用不同的名称,执行不同的功能
        case `basenam # Or: case ${0##*/} in
			"wh" 		) whois $1@whois.tucows.com;;
			"wh-ripe" 	) whois $1@whois.ripe.net;;
			"wh-apnic" 	) whois $1@whois.apnic.net;;
			"wh-cw" 	) whois $1@whois.cw.net;;
			* 			) echo "Usage: `basename $0` [domain-name]";;
        esac
	
3, 引用

	1, grep '[Ff]irst' *.txt;在''中的特殊情况,这里并不会去除[]的作用,而是作为被保护的内容传递给grep
	2, ""保护除过$,\,`的其他符号
	3, 可以引用\n
		quote=$'\116'
		echo -e '\'${quote,}
    4, $'...'可以将8进制或者16进制数转换成ascii字符保存到变量中
        quote=$'\042'
    5, echo -e用于转换特殊含义字符

7, 测试

    测试结构:
    1, if/then/elif/else结构,结合if后面的返回值确定执行顺序
        --> if结构不仅仅只能判断[]结构,后面可借命令
        --> if和then都是关键字参数,关键字开启代码块,在同一行开启一行新语句,就语句必须终结
    2, []结构,等效于test
    3, [[]]关键字结构,类比于test
    4, ((...))和let ...结构,运算结果为非零时,返回值为0;运算结果为零时,返回值为非零
    5, test是bash的内建命令,因此在一个脚本中使用test,使用的并不是/usr/bin/test二进制文件
        --> 在脚本中需要使用/usr/bin/test命令,需要写全路径
    6, 使用[[]]替换[]做测试结构可以防止很多脚本中的逻辑错误
        --> &&, ||, <, >可以用在[[]]中,但无法在[]中使用
        --> 8进制,10进制,16进制可在[[]]中进行比较,[]会报错
    7, (())也可用于测试,展开并对括号中的变量进行运算;当运算结果非零或为0或者'true';当运算结果为零时返回1或者'false'
    文件测试:
    1, 返回true
        --> -e 文件存在
        --> -f 是普通文件,不是目录或设备文件
        --> -s 大小不为零
        --> -d 是个目录
        --> -b 块设备
        --> -c 字符设备
        --> -p 管道文件
```
    function show_input_type()
    {
        [ -p /dev/fd/0 ] && echo PIPE || echo STDIN
    }
    show_input_type "Input"             # STDIN
    echo "Input" | show_input_type      # PIPE
```
        --> -h 符号链接
        --> -L 符号链接
        --> -S socket文件
        --> -t 文件绑定一个终端设备
            [ -t 0 ]用来测试脚本执行是不是在终端上
        --> -r/w/x/g/u/k 检测文件是否具有相应的权限
        --> -O/G你是文件所属者(组)
        --> f1 -nt f2 文件f1比f2新
        --> f1 -ot f2 文件f1比f2旧
        --> f1 -ef f2 文件f1和f2是指向同一个文件的硬链接
        --> ! 非
8, 操作符
    --> bash不明白浮点数的运算,会将浮点数当作字符处理;需要处理浮点数的运算,可以使用bc操作

    逻辑运算符:
    1, && 和/与
        --> if [ $condition1 ] && [ $condition2 ] Same as: if [ $condition1 -a $condition2 ]
    2, ! 非
        --> if [ ! -f $file ]
    3, || 或
        --> if [ $condition1 ] || [ $condition2 ] Same as: if [ $condition1 -o $condition2 ]
    4, &&/||在判断结构中的使用
        --> if [[ $a -eq 24 && $b -eq 24 ]] works.
        --> if [ "$a" -eq 24 && "$b" -eq 47 ] error
    5, 进制换算
        --> 可以使用$((...))结构对各个进制数进行换算
            echo $((0x9abc))
        --> 在shell中,默认使用10进制,当把8进制或者16进制数使用let赋值存储在变量中,打印后变为10进制
            let 'hex = 0x32';echo $hex
        --> 不限制进制数格式,可以使用let进行换算,可以使用10 digits + 26 lowercase characters + 26 uppercase characters + @ + _
            echo $((36#zz)) $((2#10101010)) $((16#AF16)) $((53#1aA)) # 1295 170 44822 3375

    双括号结构:
    同let,(())结构允许逻辑展开和运算
    1, (( a = 23 )) 赋值,等号左右两侧都要有空格
    2, (( --a ))和(( a-- ))都可以进行运算
    3, (( t = a<45?7:11 ))
        echo "if a < 45;then t = 7;else t = 11;fi" # a = 23
        echo "t = $t "                             # t = 7
```
运算符优先顺序:
if [ "$v1" -gt "$v2" -o "$v1" -lt "$v2" -a -e "$filename" ]
# Unclear what's going on here...,不能有超过三个的叠加存在(-a/-o)

if [[ "$v1" -gt "$v2" ]] || [[ "$v1" -lt "$v2" ]] && [[ -e "$filename" ]]
# Much better -- the condition tests are grouped in logical sections.
```

9, 其他变量视角

	内部变量:
	1, $BASHPID(返回当前shell),不同于$$(返回父shell),虽然大部分时候两个值相同
		echo $BASHPID;(echo $BASHPID)  ## output different
		echo $$;(echo $$)			   ## output same
    2, $DIRSTACK,在目录栈中的第一个值,被pushd和popd影响
		内置变量响应dirs命令,dirs会显示栈中所有的信息
	3, $EDITOR,默认被脚本引用的编辑器,一般是vi或者emacs,nano
	4, $EUID,有效UID
	5, $FUNCNAME,在函数中,显示当前函数的名字
	6, $GROUPS,当前用户所属用户组,是一个数组
		echo ${GROUPS[1]}
	7, $HOSTTYPE,检查当前系统的硬件类型
		echo $HOSTTYPE # i686
	8, $IFS,内部边界分隔符;这个变量决定bash怎样判断词组,字符串的边界
		--> 默认为空白符(空格,tab,新行)
		--> 这个值可以被更改
			 bash -c 'set w x y z; IFS=":-;"; echo "$*"'  ## w:x:y:z
		--> 在设置IFS时需要注意,IFS对待空格和其他字符不一样
			var=" a  b c  "使用for循环打印出来时,会变成三行,而不是和','一样,变为多行(超过三行)
			对于使用在awk中的FS也存在同样的问题 
	9, $PATH,二进制文件路径
	10,$PIPESTATUS,保存上一条命令的执行返回值
	11,$PPID,父进程的PID号
	12,$PROMPT_COMMAND,保存将要被执行的命令(是否为该含义待查)
	13,$PS1,主提示符,命令行界面显示
	14,$PS2,备提示符,在需要输入额外输入是显示,显示为'>'
	15,$PS3,select loop中使用
	16,$PS4,set -x后界面显示的提示符'+'
	17,$PWD,pwd命令显示结果
	18,$REPLY,当且仅当上一条read命令无变量时,保存read的变量值
	19,$SECONDS,当前脚本运行了多长时间
		while [ "$SECONDS" -le "$TIME_LIMIT" ]
	20,$SHELLOPTS,保存set -o的options项
	21,$TMOUT,设置为一个非零值之后,超时会自动登出
		--> 可以在脚本中设置超时,在一定时间内未输入,则退出
```
TMOUT=3
# Prompt times out at three seconds.
echo "What is your favorite song?"
echo "Quickly now, you only have $TMOUT seconds to answer!"
read song
if [ -z "$song" ]
then
	song="(no answer)"
	# Default response.
fi
```
	位置参数:
	1, $0,$1,$2...,位置参数,从命令行传递给脚本,函数;或者使用set进行设置
	2, $#,位置参数或者命令行参数的数目
	3, $*,所有的位置参数,视为一个word,需要使用""外加
	4, $@,同$*,但每个参数单独使用""括起来,同样也需要使用""括起来
		--> 使用IFS和$@,$*时需要注意
		--> $@和$*仅在使用双引号引用的时候有差别
    5, $!,上一个跑在后台的job的进程号
        --> 可用于任务控制
```
{ sleep ${TIMEOUT}; eval 'kill -9 $!' &> /dev/null; }
```
        --> 另一种方式
```
TIMEOUT=30
count=0
         possibly_hanging_job & {
		while ((count < TIMEOUT )); do
			eval '[ ! -d "/proc/$!" ] && ((count = TIMEOUT))'
			# /proc is where information about running processes is found.
			# "-d" tests whether it exists (whether directory exists).
			# So, we're waiting for the job in question to show up.
			((count++))
			sleep 1
		done
	eval '[ -d "/proc/$!" ] && kill -15 $!'
	# If the hanging job is running, kill it.
}
```
	6, $_,映射为执行的上一个命令最后一项内容
		--> du > /dev/null;echo $_ 			# du
		--> ls -al > /dev/null;echo $_ 		# -al
	7, $?,命令,函数或者是脚本的执行状态返回值
	8, $$,脚本自己的pid号,常用于创建惟一的temp文件,相较于mktemp使用更简单
	
	变量归类:declare/typeset
	declare/typeset属于内建命令
	可设置选项:
	1, -r,设置只读变量
		--> declare -r var1=xx 等效于 readonly var1=xx
	2, -i,设置为整数变量
		--> 设置为整数变量,允许直接进行运算,不需要expr结构
```
n=6/3
echo "n = $n"
declare -i n

echo "n = $n"
# n = 6/3
# n = 2
```
	3, -a,设置为数组变量
	4, -f,显示函数
		--> declare -f后未接任何参数,显示所有的函数;可以用在ssh远程连接,传递函数使用
		--> declare -f func_name仅显示func_name函数内容
	5, -x,等效于export
	6, 使用declare声明一个变量会限制其scope
	7, 使用declare可以非常方便的辨别变量,尤其是在辨认数组时
		--> declare | grep HOME
		--> Colors=([0]="purple" [1]="reddish-orange" [2]="light green");declare |grep Colors
	
__RANDOM使用:生成随机数__
--------
not finished
--------

	变量操作: bash允许大量字符串操作,部分属于变量替换操作,部分属于UNIX的expr功能
	1, 字符串长度
		--> ${#string},显示变量string的长度
		--> expr length $string,使用expr功能显示字符串长度
		--> expr "$string" : '.*',同样是显示变量string中字符串的长度值
	2, substring从string开头匹配的字符数,substring是正则表达式
		--> expr match "$string" '$substring'
			stringZ=abcABC123ABCabc
		--> expr "$string" : '$substring'
			echo `expr match "$stringZ" 'abc[A-Z]*.2'`   # 8
			echo `expr "$stringZ" : 'abc[A-Z]*.2'` 		 # 8
	3, substring在string中第一次匹配的下标号
		--> expr index $string $substring
			echo `expr index "$stringZ" 1c`
			# 'c' (in #3 position) matches before '1'.
	4, 变量取出
		1, 切片用法
		--> ${string:position}  					# 从position处开始抽取string,此处的position和length都可以是变量
		--> ${string:position:length}   			# 从position处抽取length个string字符
			stringZ=abcABC123ABCabc
			echo ${stringZ:7} 						# 23ABCabc
			echo ${stringZ:7:3} 					# 23A
			echo ${stringZ:(-4)} 					# Cabc 区别于${stringZ:-4},这种形式等效于${string:-default}
		--> ${*:position} 							# 从position处开始取位置参数
		--> ${@:position} 							# 同上一条
		--> ${*:position:length} 					# 同string 的用法,换成位置参数
       	--> expr substr $string $position $length   # expr用法,切片用法
		--> expr match "$string" '\($substring\)'	# 获取第一次匹配的substring内容,substring为正则表达式
		--> expr "$string" : '\($substring\)'		# 同上
			echo `expr match "$stringZ" '\(.[b-c]*[A-Z]..[0-9]\)'`	 # abcABC1
			echo `expr "$stringZ" : '\(.[b-c]*[A-Z]..[0-9]\)'`  	 # abcABC1
			echo `expr "$stringZ" : '\(.......\)'`  				 # abcABC1
		--> expr match "$string" '.*\($substring\)' # 获取尾部第一次匹配的substring内容,substring为正则表达式
		--> expr "$string" : '.*\($substring\)'     # 同上
			echo `expr match "$stringZ" '.*\([A-C][A-C][A-C][a-c]*\)'`  # ABCabc
			echo `expr "$stringZ" : '.*\(......\)'`						# ABCabc
    5, 变量置换
        file=/dir1/dir2/dir3/my.file.txt
        --> ${file#*/}             # 拿掉第一条/及其左边的字串：dir1/dir2/dir3/my.file.txt
        --> ${file##*/}            # 拿掉最后一条/及其左边的字串：my.file.txt
        --> ${file#*.}             # 拿掉第一个.及其左边的字串：file.txt
        --> ${file##*.}            # 拿掉最后一个.及其左边的字串：txt
        --> ${file%/*}             # 拿掉最后一条/及其右边的字串：/dir1/dir2/dir3
        --> ${file%%/*}            # 拿掉第一条/及其右边的字串：（空值）
        --> ${file%.*}             # 拿掉最后一个.及其右边的字串：/dir1/dir2/dir3/my.file
        --> ${file%%.*}            # 拿掉第一个.及其右边的字串：/dir1/dir2/dir3/my
            mv $filename ${filename%$1}$2  # 可以用作重命名

        --> ${file:0:5}            # 提取最左边的5个字节：/dir1
        --> ${file:5:5}            # 提取第5个字节右边的连续5个字节：/dir2

        --> ${file-my.file.txt}    # 假如$file没有设定，则使用my.file.txt作传回值。（空值及非空值时不作处理）
        --> ${file:-my.file.txt}   # 假如$file没有设定或为空值，则使用my.file.txt作传回值。（非空值时不作处理）
            ${username-`whoami`}   #  when username has not been set, return the value of result of whoami 
            filename=${1:-DEFAULT_FILENAME}

        --> ${file+my.file.txt}    # 假如$file设为空值或非空值，均使用my.file.txt作传回值。（没设定时不作处理）
        --> ${file:+my.file.txt}   # 若$file为非空值，则使用my.file.txt作传回值。（没设定及空值时不作处理）
        --> ${file=my.file.txt}    # 若$file没设定，则使用my.file.txt作传回值，同时将$file赋值为my.file.txt。\
                                    （空值及非空值时不作处理）
        --> ${file:=my.file.txt}   # 若$file没设定或为空值，则使用my.file.txt作传回值，同时将$file赋值为my.file.txt。\
                                    （非空值时不作处理）
        --> ${file?my.file.txt}    # 若$file没设定，则将my.file.txt输出至STDERR,用于变量报错设置（空值及非空值时不作处理）
        --> ${file:?my.file.txt}   # 若$file没设定或为空值，则将my.file.txt输出至STDERR。（非空值时不作处理）
        --> 要分清楚unset与null及non-null这三种赋值状态。一般而言，: 与null有关，若不带 : 的话，null不受影响，若带 : 则连null \
            也受影响。

        --> ${var,,}               # 更改var的大小写,将$var中的大写字符转换成小写
        --> ${#var}                # get the length of the variate of var

    6, 变量替换
        stringZ=abcABC123ABCabc
        --> echo ${stringZ/abc/xyz}     # xyzABC123ABCabc,将开头的abc替换成xyz
        --> echo ${stringZ//abc/xyz}    # xyzABC123ABCxyz,将字符串中的所有abc替换成xyz
            abc和xyz都可以使用变量替换
        --> echo ${stringZ/abc}         # ABC123ABCabc,不包含replacement时,则是直接删除第一处匹配内容
        --> echo ${stringZ//abc}        # ABC123ABC,同上,删除所有的匹配内容
        --> echo ${stringZ/#abc/XYZ}    # XYZABC123ABCabc,匹配前端的第一个,进行替换
        --> echo ${stringZ/%abc/XYZ}    # abcABC123ABCXYZ,匹配后端的最后一个,进行替换
        --> echo ${!varprefix*}         # 匹配所有已声明已xyz开头的变量
        --> echo ${!varprefix@}         # 匹配所有已声明已xyz开头的变量
            abc23=something_else
            b=${!abc*}
            echo "b = $b"               # b = abc23
            c=${!b}                     # Now, the more familiar type of indirect reference.
            echo $c


    7, awk的使用,等效变量替换
        String=23skidoo1
        # 012345678 Bash 变量替换中bash的下标计算方式
        # 123456789 awk  变量替换中awk的下标计算方式
        --> echo | awk '{ print substr("'"${String}"'",3,4) }'  # skid
            前面使用空echo的作用是,所谓伪输入,不需要填写输入文件

10, 循环和分支结构(循环和分支结构帮助脚本完成结构化)  
    循环:

    1, for循环
        for arg in [list]; do command;done
        --> for循环和set结合使用,会很方便,以下是例子
```
    set `uname -a`; for item in $(seq $#); do echo ${!item}; done
    for planet in "Mercury 36" "Venus 67" "Earth 93" "Mars 142" "Jupiter 483"; do
        set -- $planet
        echo "$1    $2,000,000 miles from the sun"
    done
```
        --> set中使用的--,避免难预测的bug,当后面的变量为空或者是以'-'开头
        --> [list]可以是一个变量,保存了多个值,用于for循环使用
        --> [list]也可以使用*通配符
        --> 无[list]项也可,循环使用的内容为位置参数
            for a; do echo -n "$a "; done       # 写入脚本后,执行脚本时,后接参数或者不接参数,得出结果不同
        --> [list]内容同样可为命令替换后的结果
            for name in $(awk 'BEGIN{FS=":"}{print $1}' < "$PASSWORD_FILE" )   # 系统上所有用户 
            for word in $(generate_list)                                       # 函数运行结果
        --> for loop结束后,在done后面可直接使用管道进行操作,例如排序等
            for file in "$( find $directory -type l )";do echo "$file"; done | sort  # 对循环执行后的结果进行排序
        --> C风格的for循环,需要用到(());
            LIMIT=10; for ((a=1; a <= LIMIT ; a++)); do echo $a; done
            for ((a=1, b=1; a <= LIMIT ; a++, b++)); do echo -n "$a-$b "; done
        --> 一般情况下,do和done分割for循环的结构,但在特定情况下,省略do和done
            for((n=1; n<=10; n++))
            {   # No do
                echo -n "* $n *"
            }   # No done!
            
            for n in 1 2 3
            { echo -n "$n "; }          # 在经典的for结构中,花括号中需要包含;,用于结尾
        --> E_NOARGS=65 --> The standards of variate naming, exit-because-no-arguments
        --> read command read reads a line every time, in the function 'while read i j', i stands for the first word, j stands for the rest of this line
        --> the difference between return and exit
            若在script里，用exit RV来指定其值，若没指定，在结束时以最后一道命令之RV为值。
            若在function里，则用return RV来代替exit RV即可。
            若在loop里，则用break

    2, while循环
        相对于for循环,while循环更适合用于不确定condition情况下进行的循环
        while [condition]; do command(s); done
        --> 在while循环中可能存在多个条件,但只有最后一个条件决定什么时候终止循环
            while echo "previous-variable = $previous"
                echo
                previous=$var1
                [ "$var1" != end ]; do ...
        --> 同for循环一样,while可以接收C风格的条件格式
            while (( a <= LIMIT ))
            do
                echo -n "$a"
                ((a += 1))      # let "a+=1"
            done
        --> while的条件可以直接接函数
            condition(){
                ((t++))

                if [ $t -lt 5 ]; then
                    return 0 # true
                else
                    return 1 # false
                fi
            }
            while condition
        --> 与read一起结合使用,得到while read结构
            cat file | while read line      # 同时是以管道作为输入内容
        --> while可以在done后使用'<'来作为内容输入
    3, until循环
        循环体在顶部,直到条件正确,才退出执行循环结构中的内容;与while循环相反
        until [ condition-is-true ]; do command(s); done
        until循环结构格式类同于for循环
        --> 条件为真才退出
            END_CONDITION=end
			until [ "$var1" = "$END_CONDITION" ]
			    # Tests condition here, at top of loop.
			do
			    echo "Input variable #1 "
			    echo "($END_CONDITION to exit)"
			    read var1
			    echo "variable #1 = $var1"
			    echo
			done
		--> until同样接受C风格的判断条件,使用双括号的格式(())
			until (( var > LIMIT ))
	4, 嵌套循环
		一个循环结构属于另一个循环结构的构成部分,称为嵌套循环
	5, 循环控制
		影响循环行为的命令
		break;continue
		--> break的作用为终止当前循环
		--> continue的作用为跳过当前这次的循环,在该分支中,跳过该分支后面需要执行的命令和操作
```
while [ $a -le "$LIMIT" ]; do
	a=$(($a+1))
	if [ "$a" -eq 3 ] || [ "$a" -eq 11 ]; then 			# Excludes 3 and 11.
		continue										# Skip rest of this particular loop iteration.
	fi
	echo -n "$a"										# This will not execute for 3 and 11.
done

while [ "$a" -le "$LIMIT" ]; do
	a=$(($a+1))
	if [ "$a" -gt 2 ]; then
		break 											# Skip entire rest of loop.
	fi
	echo -n "$a"
done
```
		--> break可以后接参数,单个的break表示终止当前循环;break N表示终止几层循环
		--> continue也可以接参数,单个的continue表示此次循环,continue N会终止当前层级的循环,开始下一次的循环,从N层开始
    6, 测试和分支
        case和select结构不属于循环结构,但他们通过条件判断引导程序流向

        --> case对标的是C/C++中的switch结构;case可以说是简化版的if/elif/elif/.../else结构,case可以用于设置程序接口
        case "$variable" in
        "$condition1")
            command...
            ;;
        "$condition2")
            command...
            ;;
        esac
		--> 判断后接参数
        E_PARAM=1
        case "$1" in
        "") echo "Usage: ${0##*/} <filename>"; exit $E_PARAM;;  # 提示信息,精简化
        -*) FILENAME=./$1;;                                     # 如果后面所接参数包含破折号,将其替换为./$1,这样后面的命令嗯就不会把其当做$1
        * ) FILENAME=$1;;
        esac
```
--> while和case一起使用:
while [ $# -gt 0 ]; do
    case "$1" in
      	-d|--debug)
      	    DEBUG=1
      	    ;;
      	-c|--conf)
      	    CONFFILE="$2"
      	    shift
      	    if [ ! -f $CONFFILE ]; then
      	        echo "Error: Supplied file doesn't exist!"
      	        exit $E_CONFFILE
      	    fi
      	    ;;
    esac
    shift
done

--> 做匹配函数:
match_string (){
	MATCH=0
	E_NOMATCH=90
	PARAMS=2
	E_BAD_PARAMS=91

	[ $# -eq $PARAMS ] || return $E_BAD_PARAMS
	
	case "$1" in
	    "$2") return $MATCH;;
	    *   ) return $E_NOMATCH;;
	esac
}
```

--> select继承自ksh,同样是一个可用于构建入口的工具
select variable [in list]
do
	command...
	break
done
		--> select结构提示用户输入给定的选项之一,默认情况下使用环境变量PS3作为提示符,但这个可以被改变
		PS3='Choose your favorite vegetable: ' 	 # Sets the prompt string.
											  	 # Otherwise it defaults to #? .

		select vegetable in "beans" "carrots" "potatoes" "onions" "rutabagas"
		do
			echo
			echo "Your favorite veggie is $vegetable."
			echo "Yuck!"
			echo
			break 								 # What happens if there is no 'break' here?
		done

		--> 如果结构中list不存在,select会使用传递给脚本或包含select结构的函数的位置参数$@;可类比for variable [in list]
		PS3='Choose your favorite vegetable: '
		choice_of(){
		select vegetable							# [in list] omitted, so 'select' uses arguments passed to function.
		do
			echo
			echo "Your favorite veggie is $vegetable."
			echo "Yuck!"
			echo
			break
		done
		}
		choice_of beans rice carrots radishes rutabaga spinach
		------------------------------------------------------------------------------------------------------
12, 命令替换

	命令替换重新单个甚至多个命令的输出结果,逐字的将输出内容传递给另一个上下文
	--> 命令的输出结果可以是传递给其他命令的参数,可以是设置变量,甚至生成for循环需要使用的内容参数
	--> 命令替换有两种形式:`commands`,$(commands),两种方式等效
	--> 命令替换生成一个子shell
	--> 命令替换可能把输出结果分片
		COMMAND `echo a b` 		 # 2 args: a and b
		COMMAND "`echo a b`"	 # 1 arg: "a b"
        note: 有时命令替换会出现不期望的结果
        mkdir 'dir with trailing newline
        '
        cd "`pwd`"      # error inform
        cd "$PWD"       # works fine
    --> 使用echo输出命令替换厚的未括变量,echo会将换行符去除
    --> 命令替换允许使用重定向或者cat来获取文件内容作为变量内容
        echo ` <$0`     # 输出脚本内容
    --> 不要将一个长文本内容作为值赋给一个变量，也不要将二进制文件内容作为变量的值 
    --> 没有缓冲溢出的情况出现，这是翻译性语言的特性，相较编译语言提供更多的保护
    --> 变量声明甚至可以通过一个循环结构来赋值
```
variable1=`for i in 1 2 3 4 5
do
    echo -n "$i"
done`
```
    --> 命令替换使用$()替换掉反引号的使用
        允许这种形式：content=$(<$File2)
    --> $()的形式允许多重嵌套

13，运算展开

    算数展开提供了一个强大的工具，用于在脚本中进行算数运算；常用的有反引号、双括号、let

    变种：
    --> 使用反引号的算数运算，常常和expr结合使用
        z=`expr $z + 3`
    --> 算数展开使用双括号和let，反引号的结构已经被(())，$(())和let替换
        z=$(($z+3))或者z=$((z+3))也可以
        (( n += 1 ))是正确的；(( $n += 1 ))是错误的
        let z=z+3是正确的；let "z += 3"也可以

## linux命令
15，内部命令和内部指令
    内建指令是指包含在bash工具集内部的命令；内建命令的作用一方面是为了提升性能，常用于需要fork新进程的命令，另一方面是出于某些命令需要直接访问shell内部
    
    --> 父进程获取到紫禁城的pid后，可以传递参数给紫禁城，反过来则不行；这个需要注意，出现这种问题时，一般难以排查
```
PIDS=$(pidof sh $0) # Process IDs of the various instances of this script.
P_array=( $PIDS )
echo $PIDS

let "instances = ${#P_array[*]} - 1" 
echo "$instances instance(s) of this script running."
echo "[Hit Ctl-C to exit.]"; 
echo

sleep 1
sh $0
exit 0
```
    --> 一般来说，bash内建指令不会自动fork新的进程，外部命令或者管道过滤时会fork新进程
    --> 内建指令可能和系统命令有同样的名字，但bash会使用内建命令，echo和/bin/echo并不一样
        echo "This line uses the \"echo\" builtin."
        /bin/echo "This line uses the /bin/echo system command."
    --> 关键字是预留字、符号，或者是操作符；关键字对shell来说具有特殊的含义，是shell的语句块的构成部分；关键字属于bash的硬编码部分，不同于内建指令，关键字是命令的子单元

### IO命令
    echo：打印表达式或者变量到标准输出
    --> 和-e使用，用来打印脱意符
    --> 默认情况下，每个echo会打印一个终端换行符，当与-n一起使用时，会将换行符省略掉
    --> echo `command`的形式会删除所有由command生成的换行符
        变量$IFS默认情况下降'\n'作为分隔符之一，bash将换行符后面的内容作为参数传递给echo，echo将这些参数打印出来，使用空格分隔
    
    printf：格式化打印，增强型的echo，是一个C语言中printf()函数的限制型变体，部分内容与原函数使用不同
    printf format-string... parameter...
    --> 格式化输出
```
declare -r PI=3.14159265358979
printf "Pi to 2 decimal places = %1.2f" $PI
printf "Pi to 9 decimal places = %1.9f" $PI
```
    --> 格式化输出错误内容很实用
```
# 注意$'strings...'的格式，在此处与%s的使用
error()
{
    printf "$@" >&2 # Formats positional params passed, and sends them to stderr.
    echo
    exit $E_BADDIR
}
cd $var || error $"Can't cd to %s." "$var"
```
    read：通过标准输入读取变量值，动态的通过键盘获取值，与-a选项一起使用时可获取数组变量
    --> read通常情况下，'\'会去除换行的含义，当与-r参数一同使用时，'\'按照原意进行输出
    --> -s：不显示输入内容到屏幕上
    --> -n：设置仅接收多少字符，-n同样能接受特殊按键，但需要清楚特殊按键对应的字符，但不能获取到回车的字符
            arrowup='\[A'
            arrowdown='\[B'
            arrowrt='\[C'
            arrowleft='\[D'
            insert='\[2'
            delete='\[3'
    --> -p：在接收输入内容前，打印后续内容到屏幕上，作为提示用
    --> -t：用在设置超时时间的场景下
    --> -u：获取目标文件的文件描述符
    --> read命令同样可以通过重定向到标准输入的文件来读取变量，如果文件内容超过一行，则只有第一行内容会被用于变量读取；
    --> 当read后接的参数多余一个时，默认会以空格（或者连续空格）作为分隔符来读取变量，此行为可通过更改环境变量$IFS来改变
```
read var1 < /tmp/file1
read var1 var2 < /tmp/file1
while read line; do echo $line; done < /tmp/file1
```

### 文件系统命令
    cd：切换路径命令
    --> 使用-P参数，忽略链接文件
    --> cd -,切换到上一个目录，$OLDPWD变量保存的内容
    --> 使用两个斜杠时，cd命令会出现我们不期望的情况
```
# 以下的问题在命令行和脚本中都存在，需要注意
$ cd //
$ pwd
//
```
    pwd：显示当前工作目录路径
    -->使用该命令的效果同$PWD完全相同

    pushd,popd,dirs：这个命令集合是一个工作目录书签工具，用于在工作目录中有序的来回切换；后进先出的堆栈方式处理工作目录组，允许对这个堆栈进行各种不同的操作
    --> pushd dir-name把目录dir-name放入到到堆栈中（栈顶），同时切换当前目录到dir-name中去
    --> popd 将目录栈顶的目录从栈中移除，同时将工作目录切换至此时的栈顶目录中去
    --> dirs 列出栈中的目录列表，popd和pushd会引用到dirs

    在脚本中需要切换多个目录工作时，使用这个命令集可以方便的进行管理，$DIRSTACK数组包含有目录的列表栈内容

### 变量操作命令
    let：let命令执行对变量的算数运算操作，在很多种情况下，let相当于简化版的expr命令
```
let a=11; let a=a+5
let "a <<= 3"
let "a += 5"
let a++(++a)
let "t = a<7?7:11"
```
    --> 使用let命令，在特定情况下，命令返回值和通常情况不同
```
$ var=0
$ echo $?
0
$ let var++
$ echo $?
1
```
    eval：
    eval arg1 [arg2] ... [argN]
    结合一个表达式或者一列表达式中的参数，是这些参数联合；所有在表达式中的变量都会被展开，得出的字符串被转换为命令
```
$ command_string="ps ax"
$ eval "$command_string"
```
    --> 每次调用eval都会强制重新评估其参数
```
$ a="$b"
$ b="$c"
$ c=d
$ echo $a
$ eval echo $a
$ eval eval echo $a
```
```
params=$#
param=1
while [ "$param" -le "$params" ]
do
    echo -n "Command-line parameter "
    echo -n \$$param
    echo -n " = "
    eval echo \$$param
    (( param ++ ))
done
```
    --> 使用eval命令有一定的风险，如果存在替换的方案，尽量使用替换方案来实现目的；像是eval $COMMANDS，在命令的返回结果中可能存在危险的内容如rm -rf *等
    set：
    set命令可用于更改脚本内部的变量值或者脚本选项，用法之一是可以设置option flags来更改脚本执行的动作；另一个用法是可以是将命令的输出结果设置为位置参数。  
```
set `uname -a`
```
    --> 当单独使用set命令时，终端显示所有的环境变量以及已经设置的变量
    --> set后接--,表示将一个变量的内容设置为位置参数,当--后没有任何参数时,表示取消所有的位置参数
```
variable="one two three four five"
set -- $variable
first_param=$1
second_param=$2
shift; shift

remaining_params="$*"
echo "first parameter = $first_param"                   # one
echo "second parameter = $second_param"                 # two
echo "remaining parameters = $remaining_params"         # three four five

set --
first_param=$1
second_param=$2
echo "first parameter = $first_param"                   # (null value)
echo "second parameter = $second_param"                 # (null value)
```
    unset:
    unset命令删除一个shell变量,将变量的值设置为null,改命令不影响位置参数
    --> 大多数情况下,使用unset设置过的变量和undeclare设置过的变量是等效的;但对于${parameter:-default}还是有区分的

    export:
    export命令将变量的值声明至所有由脚本生成的子shell或者是shell,令其都可使用;在开机启动脚本中使用是export一个重要使用场景,有初始化环境的作用,让后启用的脚本能够继承环境变量
    --> 父进程是没有办法获取到子进程的变量的
    --> 大部分情况下,export var=xxx和var=xxx;export var是等效的,但在某些情况下有差别
```
bash$ export var=(a b); echo ${var[0]}
(a b)
bash$ var=(a b); export var; echo ${var[0]}
a
```

