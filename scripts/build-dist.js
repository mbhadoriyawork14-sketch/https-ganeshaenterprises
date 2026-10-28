const fs = require('fs');
const path = require('path');

const rootDir = path.resolve(__dirname, '..');
const distDir = path.join(rootDir, 'dist');

console.log('====================================================');
console.log('  Ganesha Enterprises - Render Build & Deploy Script');
console.log('====================================================');
console.log(`[build-dist] Source directory: ${rootDir}`);
console.log(`[build-dist] Target directory: ${distDir}`);

// Recreate dist directory
if (fs.existsSync(distDir)) {
  console.log('[build-dist] Clearing existing dist directory...');
  fs.rmSync(distDir, { recursive: true, force: true });
}
fs.mkdirSync(distDir, { recursive: true });

// 1. Copy top-level HTML and static metadata files
const rootEntries = fs.readdirSync(rootDir);
let fileCount = 0;

for (const entry of rootEntries) {
  const fullPath = path.join(rootDir, entry);
  const stat = fs.statSync(fullPath);

  if (stat.isFile()) {
    const isHtml = entry.toLowerCase().endsWith('.html');
    const isMeta = ['robots.txt', 'sitemap.xml', 'favicon.ico', 'favicon.svg', 'manifest.json', '.env.example'].includes(entry);

    if (isHtml || isMeta) {
      fs.copyFileSync(fullPath, path.join(distDir, entry));
      fileCount++;
    }
  }
}
console.log(`[build-dist] Copied ${fileCount} root HTML and metadata files.`);

// 2. Copy directories to dist
const dirsToCopy = ['assets', 'css', 'js', 'services', 'blog', 'content', 'public', 'videos'];
let dirCount = 0;

for (const dir of dirsToCopy) {
  const src = path.join(rootDir, dir);
  const dest = path.join(distDir, dir);

  if (fs.existsSync(src)) {
    fs.cpSync(src, dest, { recursive: true });
    dirCount++;
    console.log(`[build-dist] Copied directory: ${dir}/`);
  }
}

// 3. Validation check
const indexPath = path.join(distDir, 'index.html');
if (!fs.existsSync(indexPath) || fs.statSync(indexPath).size === 0) {
  console.error('[build-dist] ERROR: dist/index.html was not generated or is empty!');
  process.exit(1);
}

console.log('====================================================');
console.log(`[build-dist] SUCCESS: dist directory populated with ${fileCount} root files and ${dirCount} asset folders.`);
console.log('[build-dist] Ready for Render static site publishing!');
console.log('====================================================');
