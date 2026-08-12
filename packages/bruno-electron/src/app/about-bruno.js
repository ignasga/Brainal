const fs = require('fs');
const path = require('path');

module.exports = function aboutBruno({ version }) {
  const currentYear = new Date().getFullYear();
  const logoBase64 = fs.readFileSync(path.join(__dirname, '..', 'about', '256x256.png')).toString('base64');
  return `
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, minimum-scale=1.0, initial-scale=1, user-scalable=yes">
        <title>About Brainal</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                text-align: center;
                margin: 0;
                padding: 10px;
                background-color: #f4f4f4;
                color: #333;
            }
            .logo {
                margin-top: 20px;
            }
            .logo img {
                width: 96px;
                height: 96px;
                border-radius: 20%;
            }
            .title {
                font-size: 24px;
                margin-top: 5px;
                font-weight: bold;
                color: #222;
            }
            .description {
                font-size: 12px;
                color: #222;
                margin-top: 5px;
            }
            .footer {
                margin-top: 5px;
                padding: 5px;
                font-size: 14px;
                color: #555;
            }
        </style>
    </head>
    <body>
      <div class="logo"><img src="data:image/png;base64,${logoBase64}" alt="Brainal" /></div>
      <h2 class="title">Brainal ${version}</h2>
      <div class="description">Based on <a href="https://github.com/usebruno/bruno">Bruno</a> (MIT license)</div>
      <footer class="footer">
          ©${currentYear} Brainal
      </footer>
    </body>
    </html>
  `;
};
