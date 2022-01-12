import os
import basic_operations
# Get environment variables
tb_dir = os.getenv('TB_DIR')
filename = os.path.join(tb_dir, 'MontMul.txt')
r = [1, 0, 0, 0 ,1, 1, 1, 0, 1]
len_of_bit = 8
no_of_test = 100
 
file = open(filename,"w")
for i in range(no_of_test) :
    a = randint(0,2^len_of_bit - 1); 
    if (a == 0):
        a_ls = [0]
    else:
        a_ls = Integer(a).digits(2)[::-1]
    b = randint(0,15) 
    if (b == 0):
        b_ls = [0]
    else:
        b_ls = Integer(b).digits(2)[::-1]
    if (len(a_ls) < len_of_bit):
        while (len_of_bit - len(a_ls) != 0): a_ls.insert(0,0)
    if (len(b_ls) < len_of_bit):
        while (len_of_bit - len(b_ls) != 0): b_ls.insert(0,0)
    file.write("N="); file.write(str(i+1))
    file.write("\nA=")
    file.write("{0:0>2}".format(hex(a).upper()[2:]))
    
    file.write("\nB=")
    file.write("{0:0>2}".format(hex(b).upper()[2:]))

    result_ls = basic_operations.mul_poly(a_ls,b_ls,r)
    
    file.write("\nC=")
    file.write("{0:0>2}".format(result_ls))
    file.write("\n")
file.close()
