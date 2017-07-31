module.exports = (markdown, options) => {
  return markdown.split('\n').map((line, index) => {
    if(!/^TODO:/.test(line) || index === 0) return line;
    return '<span style="color:red">' + line + '<\span>';
  }).join('\n');
};
