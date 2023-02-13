# coding=utf-8
import requests

'''
这是爬 课程的章节数  及每个章节有多少节课
最后结果
{0: 50, 1: 8, 2: 14, 3: 21, 4: 11, 5: 21, 6: 24, 7: 12, 8: 18, 9: 11, 10: 7, 11: 59, 12: 20}
'''

if __name__ == "__main__":
    #UA伪装：将对应的User-Agent封装到一个字典中
    headers = {
        'User-Agent':'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36'
    }
    url = 'https://api.luffycity.com/api/v1/course/actual/148/sections/?courseType=actual&id=148'

    response = requests.get(url=url,headers=headers)

    dict_data = response.json()
    # print(dict_data.get('data').get('chapter_count')) #章节数
    # print(dict_data.get('data').get('section_count')) #小节数

    chapte_dict = dict_data.get('data').get('chapters')

    chapte_sum = len(chapte_dict)

    new_dict = {}

    for i,obj in enumerate(chapte_dict):
        new_dict[i] = len(obj.get("sections"))

    print(new_dict)
    # {0: 50, 1: 8, 2: 14, 3: 21, 4: 11, 5: 21, 6: 24, 7: 12, 8: 18, 9: 11, 10: 7, 11: 59, 12: 20}