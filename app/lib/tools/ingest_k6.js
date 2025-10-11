import http from "k6/http";
import { check, sleep } from "k6";

export const options = {
  vus: 50,            // usuários virtuais simultâneos
  duration: "20s",    // 50 * 20s ~ 1000 requests (ajuste como quiser)
};

const URL = __ENV.URL || "http://localhost:3000/ingest/sensor_readings";
const POND = __ENV.POND || "1";
const TOKEN = __ENV.INGEST_TOKEN;

export default function () {
  const now = new Date();
  const body = JSON.stringify({
    pond_id: Number(POND),
    reading_time: now.toISOString(),
    metrics: {
      temp_c: 24 + Math.random() * 8,
      ph: 6.5 + Math.random() * 2.0,
      do_mg_l: 5 + Math.random() * 5
    }
  });

  const params = {
    headers: {
      "Content-Type": "application/json",
      ...(TOKEN ? { "X-INGEST-TOKEN": TOKEN } : {})
    }
  };

  const res = http.post(URL, body, params);
  check(res, { "status is 201": (r) => r.status === 201 });
  sleep(0.01);
}
