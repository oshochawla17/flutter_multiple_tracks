
import bisect
from collections import Counter
from typing import Optional


def maxVowels( s: str, k: int) -> int:
    left, right = 0, k - 1
    maxVowel = 0
    currentVowels = -1
    isLeftVowel = False
    vowels = ['a', 'e', 'i', 'o', 'u']
    while (right < len(s)):
        # check if left, and right are vowels
        # add it to current vowels
        if (currentVowels == -1):
            # count total vowels
            count = 0
            # subsctring from left
            for char in s[left:right + 1]:
                if (char in vowels):
                    count += 1
            currentVowels = count
            isLeftVowel = s[left] in vowels
        else :
            isRightVowel = s[right] in vowels
            if (isLeftVowel):
                currentVowels -= 1
            if (isRightVowel):
                currentVowels += 1
            isLeftVowel = s[left] in vowels
            print('..',currentVowels)
        maxVowel = max(maxVowel, currentVowels)
        print(maxVowel)
        right += 1
        left += 1
    print(maxVowel)
    return maxVowel
            




#list comprehension:
old_list = [1, 2, 3, 4]
# old_list = list(map(lambda x: x * x, old_list))
old_list = [x * x for x in old_list]
print(old_list)

# unpacking:
arr = [1]*4
arr2 = [2]*4

arr3 = [*arr, *arr2]

for i,j in zip(arr2, arr3):
    print(i,j)
print(arr3)


x = {'a': 1, 'g': 2}
x = {**x, 'c' : 9}
print(x)

# 2d array:
arr4 = [[0] * 4 for i in range(5)]
print(arr4)

st = 'sssss'
#st[3] = 'f'
# print(st)

a= [1, 2, 3]
for i, item in reversed(list(enumerate(a[0: len(a) - 1]))):
    print(i, item)
# print(list(reversed(a)))
# print(a)
def rotate( nums: dict, k: int) -> None:
    print(nums)
    return nums
rotate([1, 2, 4], 4)



class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right


def fun():
    xx = 4
    def x():
        nonlocal xx;
        xx = 5
    x()
    print(xx)

l = [1,2,3]
# reverse list
l = l[0:-1]
print(l)
maze = [["+","+",".","+"],[".",".",".","+"],["+","+","+","."]]
rows = len(maze)
columns = len(maze[0])
visited = [[False] * columns for i in range(rows)]
print(visited)
a = ['osho','a','ppppp']
a.sort(key= lambda x: len(x))
print(a)
print( 7//2)
print(bisect.bisect_left([1,1,2,4,5], 3))

empty_board = [["."] * 4 for _ in range(4)]
print(empty_board)

class Person:
    __att = '1111'
    def __init__(self):
        self.name = 'osho'
        #  private variable
        self._age = 10
        self._cols = [1]
    def method(self):
        print(self.name)
        self._age += 4
        print(self._age)
        print(self._cols)
class Student(Person):
    def __init__(self):
        super().__init__()
        self.name = 'osho2'
    def method(self):
        print(self.name)
a = Person()
a.name = 'osho2'
a._cols.append(2)
a.method()
a.method()
b = Person()

obj = {'name': 'akshay'}
def fun(obj):
    obj = {'name': 'osho'}
fun(obj)
print(obj)
