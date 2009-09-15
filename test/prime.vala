using GLib;
using Valadate;

namespace Test {
	public class TestPrime : Object, Fixture {
		public int prime { get; set; }

		public static ValueArray generate_prime() {
			var ret = new ValueArray(8);
			ret.append(3);
			ret.append(5);
			ret.append(7);
			ret.append(11);
			ret.append(13);
			ret.append(17);
			ret.append(19);
			ret.append(23);
			return ret;
		}

		public void test_prime() {
			assert(prime > 1);
			for(int i = 2; prime / i >= i; ++i) {
				assert(prime % i != 0);
			}
		}
	}
}
