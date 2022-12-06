class Solution:
    """
    @param: strs: a list of strings
    @return: encodes a list of strings to a single string.
    """

    def encode(self, strs):
        res = ""
        for s in strs:
            res += str(len(s)) + "#" + s
        return res

    """
    @param: s: A string
    @return: dcodes a single string to a list of strings
    """

    def decode(self, s):
        res=[]
        i=0
        length=""
        while i < len(s):
            if(s[i]=='#'):
                print(length)
                length=int(length)
                string=s[i+1:i+1+length]
                res.append(string)
                i=i+1+length
                length=""
            else:
                length=length+s[i]
                i=i+1
        return res
## the problem with this approach is, since strings are immutable, we create so many lengths, by simply
# adding characters, we create new string objects in memory, a simpler way would by not using string objects, but taken the length as 
# as distance between two indexes

    def decode(self, s):
        res, i = [], 0

        while i < len(s):
            j = i
            while s[j] != "#":
                j += 1
            length = int(s[i:j])
            res.append(s[j + 1 : j + 1 + length])
            i = j + 1 + length
        return res
 


if __name__ == '__main__':
    strs=["name","chuks","data"]
    p="3#day6##mon#h4#year"
    mL=  Solution()
    z=mL.decode(p)
    print(z)

