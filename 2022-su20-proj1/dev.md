# Dev of proj1

@2022-08-26 10:28:43
昨天复习了一下Chained HashTable的概念, 妈呀忘完了都...

刚才写了点hashtable.c里的函数实现, 不过有几个问题

   1. **的双重指针, 能直接用[]取得里面的一个指针吗?
   2. 函数指针的调用方法?
   3. struct里的*, malloc出来是不是得手动指定指向NULL?

试试看!

Q1. 双重指针

自己写个试试, ```(OneDrive) F:C/doubleP/main.c```

唔, int是可以的, 再试试struct, 唔,  也是可以的,  C真的, 优雅永不过时

Q2. 函数指针

这个我应该百度一下就可以了, 到底加不加星号呢? [都可以](https://blog.csdn.net/qq_46527915/article/details/106164681)

Q3. struct里的pointer问题

也百度一下吧, 看到个说法是C99之后会init为null?
唔..看不出来, 但是感觉不安全, 我还是手动指向吧..


*** 

其他的还好, 就是怎么从文件中读取不定长度的字符串嗯呢?

@2022-09-01 10:40:48
ok, 上个周末给他搞tmd定了, 就getchar()硬判断, 不够加realloc加料是吧!

