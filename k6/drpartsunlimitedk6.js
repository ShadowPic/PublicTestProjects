import http from 'k6/http';
import { htmlReport } from "https://raw.githubusercontent.com/benc-uk/k6-reporter/main/dist/bundle.js";
import {check} from 'k6';
import { chromium } from 'k6/x/browser';
import { jUnit, textSummary } from 'https://jslib.k6.io/k6-summary/0.0.1/index.js'; //imported from 'https://jslib.k6.io/k6-summary/0.0.1/index.js';


export const options = {
    scenarios: {
        DrPartsHtmlScenario: {
          executor: 'constant-vus',
          exec: 'drpartsHtml',
          vus: 5,
          duration: '30s',
        },
        DrPartsUIScenario: {
          executor: 'constant-vus',
          exec: 'drpartsUI',
          vus: 1,
          duration: '30s',
        },
      },
      thresholds: {
        browser_dom_content_loaded: ['p(90) < 1000'],
        browser_first_contentful_paint: ['max < 1000'],
        checks: ["rate==1.0"]
      }
};


export function drpartsHtml() {
    const res = http.get('https://drpartsunlimited.azurewebsites.net/', {tags: {name: 'homepage'}});
    check(res, {
        'is status 200': (r) => r.status === 200,
        'is faster than 500ms': (r) => r.duration < 500,
        'contains happy text':(r)=> r.body.includes('Keyword')
    });
}

export function drpartsUI(){
    const browser = chromium.launch({
        headless: __ENV.XK6_HEADLESS ? true : false,
      });
      const page = browser.newPage();
    
      page.goto('https://drpartsunlimited.azurewebsites.net', { waitUntil: 'networkidle' }).finally(() => {
        page.close();
        browser.close();
      });
}

// handles final results, generates various outputs based on needs (i.e. stdout, html, junit, etc.)
export function handleSummary(data) {
    return {
        'summary.html': htmlReport(data),
        'PerfTestProjjunit.xml': jUnit(data),
        'PerfTestResultRaw.json': JSON.stringify(data),
        'stdout': textSummary(data, { indent: ' ', enableColors: true }),
    };
}