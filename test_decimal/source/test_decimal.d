import d_mpdecimal.decimal;
import d_mpdecimal.deimos;
import std.stdio;

// This is a test program for the d_mpdecimal.decimal module.
// (C) 2021 Pablo De Nápoli

int passed;
int failed;

void perform_test(string name, bool result)
{
  if (result)
  {
    writeln("Test ", name, " passed");
    passed++;
  }
  else
  {
    writeln("Test ", name, " failed");
    failed++;
  }
}

Decimal doble(Decimal x)
{
  return (Decimal(2) * x);
}

void main()
{
  init_decimal(128);
  Decimal a = Decimal("3.1416");
  print_status();
  Decimal b = Decimal("0.01");
  Decimal zero = Decimal(0);
  writeln("a=", a);
  Decimal with_error = Decimal("?");
  writeln("with_error=", with_error);
  print_status();
  perform_test("with_error", get_status() && MPD_Conversion_syntax);

  clear_status();

  // How to check if a Decimal object has a defined value

  Decimal undefined;
  perform_test("undefined", !undefined.value);
  print_status();
  perform_test("a is defined", a.value != null);
  print_status();

  perform_test("a_to_string", a.toString() == "3.1416");
  print_status();
  string a_with_format = a.format("0.3f");
  writeln("a_with_format=", a_with_format);
  perform_test("a_with_format", a_with_format == "3.142");
  print_status();

  writeln("b=", b);
  perform_test("b_to_string", b.toString() == "0.01");
  print_status();
  writeln("b=", zero);
  perform_test("zero_to_string", zero.toString() == "0");
  print_status();
  perform_test("isinteger b ", !b.isinteger);
  print_status();

  // Test +
  Decimal c = a + b;
  writeln("c=", c);
  perform_test("+", c.toString() == "3.1516");
  print_status();
  perform_test("a_to_string +", a.toString() == "3.1416"); // We test that a has not been modified!
  print_status();
  perform_test("b_to_string +", b.toString() == "0.01");

  // Test -

  Decimal d = a - b;
  writeln("d=", d);
  print_status();
  perform_test("- ", d.toString() == "3.1316");
  print_status();
  perform_test("a_to_string -", a.toString() == "3.1416"); // We test that a has not been modified!
  print_status();
  perform_test("b_to_string -", b.toString() == "0.01");
  print_status();

  // Test *
  Decimal e = a * b;
  print_status();
  writeln("e=", e);
  print_status();
  perform_test("* ", e.toString() == "0.031416");
  print_status();
  perform_test("a_to_string *", a.toString() == "3.1416"); // We test that a has not been modified!
  print_status();
  perform_test("b_to_string *", b.toString() == "0.01");
  print_status();

  // Test /
  Decimal f = a / b;
  writeln("f=", f);
  print_status();
  perform_test("/ ", f.toString() == "314.16");
  print_status();
  perform_test("a_to_string *", a.toString() == "3.1416"); // We test that a has not been modified!
  print_status();
  perform_test("b_to_string /", b.toString() == "0.01");
  print_status();

  // Test +=
  Decimal g = a;
  perform_test("= ", g.toString() == a.toString());
  print_status();
  g += b;
  perform_test("!= ", g.toString() != a.toString());
  print_status();
  writeln("g=", g);
  perform_test("+=", g.toString() == "3.1516");
  print_status();
  perform_test("b_to_string", b.toString() == "0.01"); // We test that a has not been modified!
  print_status();

  // Test -=
  Decimal h = a;
  print_status();
  perform_test("a_to_string =", a.toString() == "3.1416");
  print_status();
  perform_test("h_to_string =", h.toString() == "3.1416");
  print_status();
  writeln("h=", h);
  h -= b;
  writeln("h=", h);
  print_status();
  perform_test("-=", h.toString() == "3.1316");
  print_status();
  perform_test("b_to_string", b.toString() == "0.01");

  // Test unary +
  perform_test("Unary +", a == +a);
  print_status();
  writeln("a=", a);
  print_status();
  writeln("+a=", +a);
  print_status();
  writeln("-a=", -a);
  print_status();
  perform_test("Unary -", (-a).toString == "-3.1416");
  print_status();
  perform_test("-zero", -zero == zero);
  print_status();

  perform_test("abs ", decimal_abs(-a) == a);
  print_status();
  perform_test("<", (a < b) == false);
  print_status();
  perform_test(">", (a > b) == true);
  print_status();
  perform_test("is_zero ", zero.iszero);
  print_status();
  perform_test("a.ispositive", a.ispositive);
  print_status();
  perform_test("!(-a).ispositive", !(-a).ispositive);
  print_status();
  perform_test("!a.isnegative", !a.isnegative);
  print_status();
  Decimal my_nan = Decimal("Nan");
  perform_test("my_nan.isnan", my_nan.isnan);
  perform_test("!a.isnan", !a.isnan);

  // beware that mpdecimal considers zero as positive
  perform_test("zero.ispositive", zero.ispositive);
  print_status();
  perform_test("(-zero).ispositive", (-zero).ispositive);
  print_status();
  perform_test("!zero.isnegative", !zero.isnegative);
  print_status();

  perform_test("a=a ", a == a);
  print_status();
  perform_test("a=b ", !(a == b));
  print_status();

  Decimal other_b = Decimal("0.01");
  print_status();
  perform_test("= ", b == other_b);
  print_status();
  perform_test("!= ", !(b != other_b));
  print_status();

  Decimal m = Decimal(17);
  perform_test("isinteger m  ", m.isinteger);
  print_status();
  Decimal n = Decimal(3);
  perform_test("% ", m % n == Decimal(2));
  print_status();

  perform_test("doble ", doble(m) == Decimal(34)); //test calling a function
  print_status();

  perform_test("++ ", ++m == Decimal(18));
  print_status();
  perform_test("++2 ", m == Decimal(18));
  print_status();
  perform_test("++3 ", m++ == Decimal(18));
  print_status();
  perform_test("++4 ", m == Decimal(19));
  print_status();

  perform_test("-- ", --m == Decimal(18));
  print_status();
  perform_test("--2 ", m == Decimal(18));
  print_status();
  perform_test("--3 ", m-- == Decimal(18));
  print_status();
  perform_test("--4 ", m == Decimal(17));
  print_status();

  m++;
  perform_test("++5 ", m == Decimal(18));
  print_status();
  ++m;
  perform_test("++6 ", m == Decimal(19));
  print_status();
  m--;
  perform_test("--5 ", m == Decimal(18));
  print_status();
  --m;
  perform_test("--6 ", m == Decimal(17));
  print_status();

  // When a variable is declared to be of type Decimal but not initializated,
  // value is a null pointer. We check that this does nos cause a segmentation fault

  Decimal x;
  perform_test("null", x.toString() == "null");
  perform_test("null1", (x + Decimal(1)).toString() == "null");
  perform_test("null2", (x++).toString() == "null");
  perform_test("null3", !x.iszero());
  print_status();
  x += Decimal(1);
  perform_test("null4", x.toString() == "null");
  Decimal one = Decimal("1");
  perform_test("exp ", decimal_exp(zero) == one);
  print_status();
  perform_test("ln ", decimal_ln(one) == zero);
  print_status();
  Decimal ten = Decimal("10");
  perform_test("log10 ", decimal_log10(ten) == one);
  print_status();
  Decimal four = Decimal("4");
  Decimal two = Decimal("2");
  perform_test("sqrt ", decimal_sqrt(four) == two);
  print_status();
  perform_test("invsqrt ", decimal_invroot(four) == Decimal("0.5"));
  auto status = print_status();
  perform_test("invsqrt status", status == (MPD_Inexact | MPD_Rounded));

  clear_status();
  print_status();
  perform_test("decimal_round_to_int ", decimal_round_to_int(Decimal("1.9999")) == two);
  print_status();
  perform_test("decimal_floor ", decimal_floor(Decimal("1.9999")) == one);
  print_status();
  perform_test("decimal_ceil ", decimal_ceil(Decimal("1.9999")) == two);
  print_status();
  perform_test("decimal_trunc ", decimal_floor(Decimal("1.9999")) == one);
  print_status();
  Decimal division_by_zero = Decimal("1") / Decimal("0");
  status = print_status();
  perform_test("division_by_zero ", status == MPD_Division_by_zero);

  writeln(passed, " tests passed.");
  writeln(failed, " tests failed.");
}
