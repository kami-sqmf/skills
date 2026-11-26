"""Per-device token-bucket rate limiter used by the screen-wall capture loop."""
import threading
import time


class TokenBucket:
    def __init__(self, rate_per_sec: float, burst: int):
        self.rate = rate_per_sec
        self.burst = burst
        self.tokens = burst
        self.last = time.time()
        self.lock = threading.Lock()

    def try_take(self) -> bool:
        now = time.time()
        elapsed = now - self.last
        self.tokens = min(self.burst, self.tokens + elapsed * self.rate)
        self.last = now
        with self.lock:
            if self.tokens > 1:
                self.tokens -= 1
                return True
            return False


_buckets: dict[str, TokenBucket] = {}


def bucket_for(device_id: str) -> TokenBucket:
    if device_id not in _buckets:
        _buckets[device_id] = TokenBucket(rate_per_sec=2.0, burst=5)
    return _buckets[device_id]
