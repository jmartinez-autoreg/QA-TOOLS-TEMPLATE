#!/usr/bin/env node
const fs   = require('fs');
const path = require('path');
const os   = require('os');

const force = process.argv.includes('--force');

// Copia archivos respetando el flag --force (para archivos del workspace)
function copyDir(srcDir, destDir) {
  if (!fs.existsSync(destDir)) fs.mkdirSync(destDir, { recursive: true });
  fs.readdirSync(srcDir).forEach(file => {
    const srcFile  = path.join(srcDir, file);
    const destFile = path.join(destDir, file);
    if (fs.lstatSync(srcFile).isDirectory()) {
      copyDir(srcFile, destFile);
    } else if (!force && fs.existsSync(destFile)) {
      console.log('   ⚠️  Skip (ya existe): ' + path.relative(process.cwd(), destFile) + '  — usa --force para sobreescribir');
    } else {
      fs.copyFileSync(srcFile, destFile);
    }
  });
}

// Copia SIEMPRE (para skills y agentes que deben actualizarse automáticamente)
function copyDirAlways(srcDir, destDir) {
  if (!fs.existsSync(destDir)) fs.mkdirSync(destDir, { recursive: true });
  fs.readdirSync(srcDir).forEach(file => {
    const srcFile  = path.join(srcDir, file);
    const destFile = path.join(destDir, file);
    if (fs.lstatSync(srcFile).isDirectory()) {
      copyDirAlways(srcFile, destFile);
    } else {
      fs.copyFileSync(srcFile, destFile);
    }
  });
}

// 1. Copiar archivos del workspace (Template/ → cwd)
const templateSrc  = path.join(__dirname, 'Template');
const templateDest = process.cwd();
copyDir(templateSrc, templateDest);
console.log('\n✅ Archivos de workspace copiados a: ' + templateDest);

// 2. Instalar skills en ~/.agents/skills/ (SIEMPRE actualiza)
const skillsSrc  = path.join(__dirname, 'skills');
const skillsDest = path.join(os.homedir(), '.agents', 'skills');
if (fs.existsSync(skillsSrc)) {
  copyDirAlways(skillsSrc, skillsDest);
  console.log('\n✅ Skills actualizados en ' + skillsDest + ':');
  fs.readdirSync(skillsSrc).forEach(s => console.log('   📦 ' + s));
  console.log('\n   ⚙️  CONFIGURACIÓN REQUERIDA:');
  console.log('      zoho_timelog/SKILL.md → Actualiza Portal ID, Project ID y mapeo de US');
  console.log('      qa_tester/SKILL.md    → Ajusta referencias a tu documentación interna');
}

// 3. Instalar agentes en ~/.copilot/agents/ (SIEMPRE actualiza)
const agentsSrc  = path.join(__dirname, 'agents');
const agentsDest = path.join(os.homedir(), '.copilot', 'agents');
if (fs.existsSync(agentsSrc)) {
  copyDirAlways(agentsSrc, agentsDest);
  console.log('\n✅ Agente QA-PRO actualizado en ' + agentsDest);
}

// 4. Crear carpeta .agent-state/ si no existe
const agentStateDir = path.join(process.cwd(), '.agent-state');
if (!fs.existsSync(agentStateDir)) {
  fs.mkdirSync(agentStateDir, { recursive: true });
  console.log('\n✅ Carpeta .agent-state/ creada');
}

// 5. Crear .env.playwright a partir del ejemplo (solo si no existe)
const envDest    = path.join(process.cwd(), '.env.playwright');
const envExample = path.join(templateDest, '.env.playwright.example');
if (!fs.existsSync(envDest) && fs.existsSync(envExample)) {
  fs.copyFileSync(envExample, envDest);
  console.log('\n✅ .env.playwright creado — completa APP_URL, TEST_USER, TEST_PASS');
} else if (fs.existsSync(envDest)) {
  console.log('\n   ⚠️  .env.playwright ya existe — no sobreescrito');
}

console.log('\n🚀 Listo. Abre VS Code y usa GitHub Copilot Agent.');
console.log('   Lee el README.md para empezar.');
console.log('   Configura los skills con datos de tu empresa (ver sección ⚙️ arriba).\n');
console.log('💡 Skills y agentes se actualizan automáticamente en cada ejecución.');
if (!force) console.log('   Archivos del workspace: usa --force para sobreescribir si ya existen.\n');
