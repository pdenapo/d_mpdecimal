import d_mpdecimal.decimal;
import d_mpdecimal.deimos;
import std.stdio;

// This is a test program computing the primes up to a given limit
// with a very inefficient method
// (serves as a stress test for the library).

void main()
{
  init_decimal(100);
  Decimal [] primes;
  Decimal  p=Decimal(2);
  
  primes ~= Decimal(2);
  writeln("2 is prime");
  long count =1;      
  auto limit=Decimal(10000000);

  while (p< limit)
  {
   p++;
   foreach(q;primes)
   {
        //writeln("q=",q);
        if (q*q>p)
        {
            // if we get here p is prime
            primes ~= Decimal(p);
            writeln(p, " is prime");
            count ++;
            break;   
         }
    
        if ((p%q).iszero())
        {
       // if we find a divisor, p is not prime 
       break;
        }
    }
  }

  //writeln(primes);

  // The prime counting function
  // We can compare this with the value given by Pari/Gp
  // which for intace gives gives  primepi(10000000)= 664579

  writeln("primepi(",limit,")=",count);
}
