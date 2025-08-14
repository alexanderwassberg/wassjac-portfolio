const fs = require("fs");
const path = require("path");
const matter = require("gray-matter");

const dir = "./content/photos";
const photos = [];

fs.readdirSync(dir).forEach(file => {
  if (file.endsWith(".md")) {
    const mdPath = path.join(dir, file);
    const imgName = file.replace(".md", ".jpg");
    const imgPath = `/content/photos/${imgName}`;
    const content = fs.readFileSync(mdPath, "utf8");
    const { data, content: body } = matter(content);

    photos.push({
      title: data.title || imgName,
      date: data.date || "",
      tags: data.tags || [],
      description: body.trim(),
      image: imgPath
    });
  }
});

fs.writeFileSync("photos.json", JSON.stringify(photos, null, 2));
console.log("✅ photos.json updated");

