import matplotlib.pyplot as plt 
import pandas as pd 
import pymysql
import numpy as np
plt.switch_backend('agg')



#建立数据库连接
conn = pymysql.connect("10.131.252.160","root","root","zc",charset="utf8")
print("连接成功")
#读取数据库表数据
data = pd.read_sql("SELECT duration FROM zc.repositories inner join zc.builds where zc.repositories.id= zc.builds.repository_id and zc.repositories.star_number>50 and zc.repositories.build_number>500 and zc.builds.duration <>0 and zc.builds.duration is not null  ",con=conn)
#数据转化为列表
x= list(data.duration)

# x=np.log(x)
fig, axes = plt.subplots(nrows=1, ncols=2, figsize=(12, 12))
tang_data = x
axes[0].violinplot(tang_data, showmeans=True, showmedians=True)
axes[0].set_title('violin plot')

axes[1].boxplot(tang_data)
axes[1].set_title('box plot')


for ax in axes:
    # 对y轴加上网格
    ax.yaxis.grid(True)
    ax.set_xticks([y+1 for y in range(0,1)])
# 对每个图加上xticks操作
plt.setp(axes, xticks=[y+1 for y in range(0,1)], xticklabels=['xbuilds'])
plt.show()
# x = list(data.DT_DATE) #日期
# y = list(data.HIGH_TEMP) #最高气温
# z = list(data.LOW_TEMP) #最低气温

# #设置折线样式
# plt.plot(x,y,"g--")
# plt.plot(x,z,"r--")

# #设置x坐标轴的范围
# plt.xlim(1,30)
# #设置y坐标轴的范围
# plt.ylim(-50,50)

# #设置X轴文字的标题
# plt.xlabel("date") 
# #设置Y轴文字的标题
# plt.ylabel("temperature(℃)")

# #设置图表的标题
# plt.title("Kunming temperature change chart in February")

# plt.show()
# print(type(x))
#关闭数据库连接
conn.close()