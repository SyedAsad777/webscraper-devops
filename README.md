1. Clone the Repository
First, clone the repository to your local machine:

bash
Copy
Edit
git clone <repository-url>
cd <repository-directory>
2. Modify the Dockerfile
Ensure that the Dockerfile has the necessary steps for both scraping (via Puppeteer) and serving (via Flask). If you haven't already, use the multi-stage Dockerfile approach.

3. Build the Docker Image
Build the Docker image by specifying the URL to scrape as a build argument:


docker build -docker build -t webscraper --build-arg SCRAPE_URL=https://books.toscrape.com/catalogue/page-2.html .
Replace "https://books.toscrape.com" with the URL of the website you want to scrape.

webscraper is the name/tag of the built Docker image.

SCRAPE_URL is an environment variable used to configure the target URL during the scraping process.

This step will:

Build the image.

Install necessary dependencies like Puppeteer and Flask.

Scrape the data from the provided URL (SCRAPE_URL).

Store the scraped data in scraped_data.json.

4. Run the Docker Container
Once the image is successfully built, run the container using the following command:

docker run -p 5000:5000 webscraper

This will start the Flask web server inside the container.

The server will listen on port 5000 on your local machine (mapped from the container's port 5000).

5. Access the Scraped Data
Once the container is running, you can access the scraped data by opening your browser or any API tool (like Postman) and navigating to:

http://localhost:5000
This will return the scraped data in JSON format.
