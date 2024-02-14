--1.1 countries that have the lowest invoices.
SELECT i.BillingCountry, COUNT(invoiceid) Invoices
FROM invoice i
GROUP BY i.BillingCountry
ORDER BY Invoices;

--1.2 5 city that has the lowest sum of invoice totals.
SELECT invoice.billingcity, invoice.Total
FROM invoice
ORDER BY invoice.total
LIMIT 5;

--1.3  the person who has spent the least money.
SELECT c.*, SUM(i.total)  total_invoices
FROM customer c
JOIN invoice i
    ON c.customerid = i.customerid
GROUP BY c.customerid
ORDER BY total_invoices
LIMIT 1;

--1.4 all the customers who listen to Rock music.
SELECT c.Email, c.FirstName, c.LastName,  g.name
FROM customer c
JOIN invoice
    ON c.customerid = invoice.customerid
JOIN invoiceline
    ON invoice.invoiceid = invoiceline.invoiceid
JOIN track
    ON invoiceline.trackid = track.trackid
JOIN genre g
    ON track.genreid = g.genreid
WHERE g.name = 'Rock' AND c.email LIKE 's%'
ORDER BY c.email;

--1.5 the customer that has spent the most on music for each country.
SELECT Country, FirstName, LastName, Email, TotalSpent
FROM (
    SELECT c.customerId, Country, FirstName, LastName, Email,
        SUM(Total) AS TotalSpent,
        RANK() OVER (PARTITION BY Country ORDER BY SUM(Total)) SpendRank
    FROM Customer c
    JOIN Invoice
        ON c.customerid = Invoice.customerid
    GROUP BY c.customerId) RankedCustomers
WHERE SpendRank = 1
ORDER BY Country, TotalSpent DESC;

--2.1 How many tracks appeared how many times ?
SELECT appeared_times, COUNT(*)  num_of_tracks
FROM (
    SELECT trackId, COUNT(*)  appeared_times
         FROM invoiceline
         GROUP BY trackId
     ) track_appeared
GROUP BY appeared_times
ORDER BY appeared_times DESC;

--2.2  Which album generated the most revenue?
SELECT
    a.Title albumtitle,
    SUM(invoiceline.unitprice * invoiceline.quantity)  total_revenue
FROM
    album a
        JOIN
    track ON a.AlbumId = Track.AlbumId
        JOIN
    invoiceLine ON Track.TrackId = InvoiceLine.TrackId
        JOIN
    artist ON a.ArtistId = Artist.ArtistId
GROUP BY
    a.AlbumId
ORDER BY
    total_revenue DESC
LIMIT 1;

--2.3 Which countries have the highest sales revenue and the percent of total revenue ?
SELECT billingcountry, SUM(Total) total_revenue,
    ROUND(SUM(Total) * 100.0 / (SELECT SUM(Total) FROM invoice), 2) percent_of_total_revenue
FROM invoice
GROUP BY billingcountry
ORDER BY total_revenue DESC;