#!/usr/bin/env node
const fs       = require('fs');
const path     = require('path');
const os       = require('os');
const readline = require('readline');

const force      = process.argv.includes('--force');
const skipPrompt = process.argv.includes('--yes') || process.argv.includes('-y');

// Lee y parsea models.config.yml de forma simple (sin dependencia externa)
function loadModelConfig() {
  const configPath = path.join(__dirname, 'models.config.yml');
  if (!fs.existsSync(configPath)) return null;
  const lines = fs.readFileSync(configPath, 'utf8').split('\n').map(l => l.replace(/\r$/, ''));
  const tiers = {};
  let currentTier = null;

  for (const line of lines) {
    // Detectar inicio de tier: "  T1:" o "  TOps:"
    const tierMatch = line.match(/^  (T\w+):$/);
    if (tierMatch) { currentTier = tierMatch[1]; tiers[currentTier] = {}; continue; }
    if (!currentTier) continue;
    // Parsear propiedades de 4 espacios
    const nameM  = line.match(/^    name:\s+"(.+)"/);
    const modelM = line.match(/^    model:\s+"(.+)"/);
    const etM    = line.match(/^    extended_thinking:\s+(\w+)/);
    if (nameM)  tiers[currentTier].name  = nameM[1];
    if (modelM) tiers[currentTier].model = modelM[1];
    if (etM)    tiers[currentTier].extended_thinking = etM[1] === 'true';
  }
  return Object.keys(tiers).length ? tiers : null;
}

// Muestra tabla de tiers en consola
function printTierTable(tiers) {
  if (!tiers) return;
  console.log('\n📊 MODEL TIERS (models.config.yml):');
  console.log('   ┌───────┬────────────────────────┬──────────────────────────────┬────────────┐');
  console.log('   │ Tier  │ Rol                    │ Modelo                       │ Thinking   │');
  console.log('   ├───────┼────────────────────────┼──────────────────────────────┼────────────┤');
  for (const [id, t] of Object.entries(tiers)) {
    const tier    = id.padEnd(5);
    const name    = t.name.substring(0, 22).padEnd(22);
    const model   = t.model.padEnd(30);
    const think   = t.extended_thinking ? '✅ extended' : '—          ';
    console.log(`   │ ${tier} │ ${name} │ ${model} │ ${think} │`);
  }
  console.log('   └───────┴────────────────────────┴──────────────────────────────┴────────────┘');
  console.log('   💡 Edita models.config.yml para cambiar modelos en todo el sistema\n');
}

// Interfaz de preguntas interactivas
const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
function ask(pregunta) {
  return new Promise(resolve => rl.question(pregunta, r => resolve(r.trim().toLowerCase())));
}

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

// ── MAIN ──────────────────────────────────────────────────────────────────────
async function main() {
  console.log('\n🤖 QA Agent Template — Instalador Inteligente');

  // 0. Mostrar tabla de tiers
  const tiers = loadModelConfig();
  printTierTable(tiers);

  // 1. Copiar archivos del workspace (Template/ → cwd)
  const templateSrc  = path.join(__dirname, 'Template');
  const templateDest = process.cwd();
  copyDir(templateSrc, templateDest);
  console.log('✅ Archivos de workspace copiados a: ' + templateDest);

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

  // 3. Detectar agentes existentes y preguntar
  const agentsSrc   = path.join(__dirname, 'agents');
  const copilotDest = path.join(os.homedir(), '.copilot', 'agents');
  const claudeDest  = path.join(os.homedir(), '.claude', 'agents');

  if (fs.existsSync(agentsSrc)) {
    const hasCopilot = fs.existsSync(copilotDest) && fs.readdirSync(copilotDest).length > 0;
    const hasClaude  = fs.existsSync(claudeDest)  && fs.readdirSync(claudeDest).length  > 0;
    let instalar = true;

    if ((hasCopilot || hasClaude) && !skipPrompt) {
      console.log('\n📋 AGENTES DETECTADOS EN TU EQUIPO:');
      if (hasCopilot) console.log('   ✅ GitHub Copilot  → ' + copilotDest);
      if (hasClaude)  console.log('   ✅ Claude Code     → ' + claudeDest);
      console.log('\n¿Qué deseas hacer?');
      console.log('   [1] Actualizar todos los agentes (recomendado)');
      console.log('   [2] Solo instalar los que faltan');
      console.log('   [3] Saltar — no tocar agentes');
      const r = await ask('\nTu elección (1/2/3): ');
      if (r === '3') { instalar = false; console.log('⏭️  Agentes sin cambios'); }
      else if (r === '2') console.log('📦 Instalando solo faltantes...');
      else console.log('🔄 Actualizando todos...');
    }

    if (instalar) {
      // 3a. GitHub Copilot
      if (!hasCopilot || skipPrompt || (await ask('').length === 0)) {
        copyDirAlways(agentsSrc, copilotDest);
        console.log('\n✅ GitHub Copilot — agentes instalados');
        console.log('   📍 ' + copilotDest);
        console.log('   🎨 QA-PRO (azul #00A9E0) + PO-PRO (morado #7B68EE)');
      }
      // 3b. Claude Code
      if (!hasClaude || skipPrompt || (await ask('').length === 0)) {
        copyDirAlways(agentsSrc, claudeDest);
        console.log('\n✅ Claude Code — agentes instalados');
        console.log('   📍 ' + claudeDest);
        if (tiers) {
          console.log('   🤖 Tiers activos:');
          for (const [id, t] of Object.entries(tiers)) {
            console.log(`      ${id}: ${t.model}${t.extended_thinking ? ' + extended thinking' : ''}`);
          }
        }
      }
    }
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

  console.log('\n🚀 Listo! Elige tu agente:');
  console.log('   📎 GitHub Copilot  → Ctrl+Shift+I y escribe "@QA-PRO" o "@PO-PRO"');
  console.log('   🤖 Claude Code     → abre la carpeta con "claude" en terminal');
  console.log('\n   Lee el README.md para empezar.');
  console.log('   Para cambiar modelos: edita models.config.yml y re-ejecuta node index.js\n');
  if (!force) console.log('   Usa --force para sobreescribir archivos del workspace.\n');

  rl.close();
}

main().catch(err => { console.error('\n❌ Error:', err.message); rl.close(); process.exit(1); });
