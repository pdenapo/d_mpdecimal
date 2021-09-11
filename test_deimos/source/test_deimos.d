import d_mpdecimal.deimos;
import core.stdc.stdio; // for printf

void main()
{
  mpd_context_t ctx;
  mpd_t* a;
  mpd_t* b;
  mpd_t* c;
  printf("Using libmpdec version %s \n",mpd_version);
  
  mpd_ieee_context(&ctx, 128);
  // We create a decimal and store a value in it
  a= mpd_new(&ctx);
  mpd_set_string(a, "3.1416", &ctx);
  a= mpd_new(&ctx);
  mpd_set_string(a, "3.1416", &ctx);
  b= mpd_new(&ctx);
  mpd_set_string(b, "0.01", &ctx);
  c= mpd_new(&ctx);
  mpd_add(c, a, b,&ctx);
  printf("a=");
  mpd_print(a);
  printf("b=");
  mpd_print(b);
  printf("c=");
  mpd_print(c);
  mpd_del(c);
  mpd_del(b);
  mpd_del(a);
}
