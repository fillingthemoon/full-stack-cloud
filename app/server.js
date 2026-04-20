const http = require('http');
const { DynamoDBClient } = require("@aws-sdk/client-dynamodb");
const { DynamoDBDocumentClient, PutCommand, ScanCommand } = require("@aws-sdk/lib-dynamodb");

// Configuration
const REGION = process.env.AWS_REGION || "ap-southeast-1";
const TABLE_NAME = process.env.TABLE_NAME || "NotesTable";
const PORT = 3000;

// Initialize Clients
const client = new DynamoDBClient({ region: REGION });
const docClient = DynamoDBDocumentClient.from(client);

/**
 * Helper to parse JSON body from a stream
 */
const getRequestBody = (req) => {
    return new Promise((resolve, reject) => {
        let body = '';
        req.on('data', chunk => { body += chunk.toString(); });
        req.on('end', () => {
            try {
                resolve(body ? JSON.parse(body) : {});
            } catch (e) {
                reject(e);
            }
        });
    });
};

const server = http.createServer(async (req, res) => {
    res.setHeader('Content-Type', 'application/json');

    // Route: POST /notes
    if (req.url === '/notes' && req.method === 'POST') {
        try {
            const data = await getRequestBody(req);
            
            const newNote = {
                id: Math.random().toString(36).substring(2, 11), // Simple unique ID
                title: data.title || "Untitled",
                body: data.body || "",
                created_at: new Date().toISOString()
            };

            await docClient.send(new PutCommand({
                TableName: TABLE_NAME,
                Item: newNote,
            }));

            res.statusCode = 201;
            res.end(JSON.stringify(newNote));
        } catch (error) {
            console.error(error);
            res.statusCode = 500;
            res.end(JSON.stringify({ error: "Could not create note", details: error.message }));
        }
    } 
    
    // Route: GET /notes
    else if (req.url === '/notes' && req.method === 'GET') {
        try {
            const data = await docClient.send(new ScanCommand({
                TableName: TABLE_NAME,
            }));

            res.statusCode = 200;
            res.end(JSON.stringify(data.Items));
        } catch (error) {
            console.error(error);
            res.statusCode = 500;
            res.end(JSON.stringify({ error: "Could not retrieve notes" }));
        }
    } 

    else {
        res.statusCode = 404;
        res.end(JSON.stringify({ error: "Route not found" }));
    }
});

server.listen(PORT, () => {
    console.log(`Server writing to DynamoDB table: ${TABLE_NAME}`);
});