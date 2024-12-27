// funny k6 to make more containers
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

const failureRate = new Rate('failed_requests');

export const options = {
  stages: [
    { duration: '1m', target: 100 },    
    { duration: '1m', target: 200 },    
    { duration: '1m', target: 300 },   
    { duration: '1m', target: 500 },  
    { duration: '1m', target: 1000 },      
  ],
  thresholds: {
    'failed_requests': ['rate<0.1'],    
    'http_req_duration': ['p(95)<2000'], 
  },
};

export default function () {
  const response = http.get('https://ui.konst.fish/');
  
  const success = check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 2000ms': (r) => r.timings.duration < 2000,
  });
  
  failureRate.add(!success);

  sleep(Math.random() * 1 + 1);
}