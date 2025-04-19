const puppeteer = require('puppeteer');
const fs = require('fs');

const scrape = async () => {
  const browser = await puppeteer.launch({
    executablePath: '/usr/bin/chromium',
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  });

  const page = await browser.newPage();
  await page.goto(process.env.SCRAPE_URL || 'https://books.toscrape.com');

  const data = await page.evaluate(() => {
    const books = Array.from(document.querySelectorAll('.product_pod')).map(book => {
      const title = book.querySelector('h3 a')?.getAttribute('title');
      const price = book.querySelector('.price_color')?.innerText;
      const availability = book.querySelector('.availability')?.innerText.trim();
      const imageRelative = book.querySelector('img')?.getAttribute('src');
      const image = imageRelative ? new URL(imageRelative, 'https://books.toscrape.com').href : null;

      return { title, price, availability, image };
    });

    return {
      scrapedFrom: document.title,
      totalBooks: books.length,
      books
    };
  });

  fs.writeFileSync('scraped_data.json', JSON.stringify(data, null, 2));
  await browser.close();
};

scrape();

