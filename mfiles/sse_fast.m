function ret = sse_fast(a,b,sum1,sum_square,count)
ret = sum_square(b)-sum_square(a-1);
ret = ret - (sum1(b)-sum1(a-1))^2 /(count(b)-count(a-1));