#!/usr/bin/env node
const fs   = require('fs');
const path = require('path');

const force = process.argv.includes('--force');

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

// Copia archivos respetando el flag --force; permite excluir entradas de nivel superior
function copyDir(srcDir, destDir, exclude = []) {
  if (!fs.existsSync(destDir)) fs.mkdirSync(destDir, { recursive: true });
  fs.readdirSync(srcDir).forEach(file => {
    if (exclude.includes(file)) return;
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

// Inicializa context/ (CONTEXT.md, UI-UX.md, screenshots/, wiki/) — NUNCA se sobreescribe con --force,
// porque acumula conocimiento del proyecto construido por project-onboarding.
function setupContext(templateSrc, projectDest) {
  const contextSrc  = path.join(templateSrc, 'context');
  const contextDest = path.join(projectDest, 'context');
  if (!fs.existsSync(contextSrc)) return;
  if (!fs.existsSync(contextDest)) fs.mkdirSync(contextDest, { recursive: true });

  const renameMap = {
    'CONTEXT.template.md': 'CONTEXT.md',
    'UI-UX.template.md':   'UI-UX.md',
  };

  fs.readdirSync(contextSrc).forEach(entry => {
    const srcPath = path.join(contextSrc, entry);
    if (fs.lstatSync(srcPath).isDirectory()) {
      copyDir(srcPath, path.join(contextDest, entry)); // screenshots/, wiki/ (.gitkeep)
      return;
    }
    const destName = renameMap[entry] || entry;
    const destPath = path.join(contextDest, destName);
    if (fs.existsSync(destPath)) {
      console.log('   ⚠️  Skip (ya existe): context/' + destName + ' — no se sobreescribe (contiene contexto del proyecto)');
    } else {
      fs.copyFileSync(srcPath, destPath);
    }
  });
}

// ── MAIN ──────────────────────────────────────────────────────────────────────
async function main() {
  console.log('\n🤖 QA Agent Template — Instalador');

  // 0. Mostrar tabla de tiers
  const tiers = loadModelConfig();
  printTierTable(tiers);

  const projectDest = process.cwd();
  const templateSrc = path.join(__dirname, 'Template');

  // 1. Copiar archivos del workspace (Template/ → proyecto). Excluir:
  //    - context/ → se maneja aparte (setupContext)
  //    - copilot-instructions.md → Copilot lo lee desde .github/, no desde la raíz (paso 1b)
  copyDir(templateSrc, projectDest, ['context', 'copilot-instructions.md']);
  console.log('✅ Archivos de workspace copiados a: ' + projectDest);

  // 1b. Entrada de Copilot → .github/copilot-instructions.md (ubicación nativa que Copilot lee)
  const copilotInstrSrc  = path.join(templateSrc, 'copilot-instructions.md');
  const copilotInstrDest = path.join(projectDest, '.github', 'copilot-instructions.md');
  if (fs.existsSync(copilotInstrSrc)) {
    fs.mkdirSync(path.dirname(copilotInstrDest), { recursive: true });
    if (force || !fs.existsSync(copilotInstrDest)) {
      fs.copyFileSync(copilotInstrSrc, copilotInstrDest);
      console.log('✅ Entrada de Copilot en .github/copilot-instructions.md');
    }
  }

  // 2. Inicializar context/ (CONTEXT.md, UI-UX.md, screenshots/, wiki/)
  setupContext(templateSrc, projectDest);
  console.log('✅ context/ listo — usa el skill "project-onboarding" para completarlo (CONTEXT.md, UI-UX.md)');

  // 3. Instalar skills en skills/ (raíz del proyecto — plataforma-agnóstico, SIEMPRE actualiza)
  const skillsSrc  = path.join(__dirname, 'skills');
  const skillsDest = path.join(projectDest, 'skills');
  if (fs.existsSync(skillsSrc)) {
    copyDirAlways(skillsSrc, skillsDest);
    console.log('\n✅ Skills instalados/actualizados en ' + path.relative(projectDest, skillsDest) + ':');
    fs.readdirSync(skillsSrc).forEach(s => console.log('   📦 ' + s));
    console.log('\n   ⚙️  CONFIGURACIÓN REQUERIDA:');
    console.log('      skills/zoho_timelog/SKILL.md → Actualiza Portal ID, Project ID y mapeo de US');
    console.log('      skills/qa_tester/SKILL.md    → Ajusta referencias a tu documentación interna');
  }

  // 4. Instalar agentes (SIEMPRE actualiza) — Claude Code (.claude/agents/) y Copilot (.github/agents/)
  const agentsSrc        = path.join(__dirname, 'agents');
  const claudeAgentsDest = path.join(projectDest, '.claude', 'agents');
  const copilotAgentsDest = path.join(projectDest, '.github', 'agents');

  if (fs.existsSync(agentsSrc)) {
    fs.mkdirSync(claudeAgentsDest, { recursive: true });
    fs.mkdirSync(copilotAgentsDest, { recursive: true });

    // QA-PRO.agent.md y PO-PRO.agent.md → subagentes gemelos: Claude Code + Copilot (mismo contenido)
    // Cada uno es la fuente única de las reglas de su rol; las reglas globales viven en AGENTS.md.
    ['QA-PRO.agent.md', 'PO-PRO.agent.md'].forEach(f => {
      const src = path.join(agentsSrc, f);
      if (!fs.existsSync(src)) return;
      fs.copyFileSync(src, path.join(claudeAgentsDest, f));
      fs.copyFileSync(src, path.join(copilotAgentsDest, f));
    });

    console.log('\n✅ Agentes instalados/actualizados:');
    console.log('   📍 .claude/agents/  (Claude Code: QA-PRO, PO-PRO)');
    console.log('   📍 .github/agents/  (GitHub Copilot: QA-PRO, PO-PRO)');
    console.log('   🎨 QA-PRO (azul #00A9E0) + PO-PRO (morado #7B68EE)');
    if (tiers) {
      console.log('   🤖 Tiers activos:');
      for (const [id, t] of Object.entries(tiers)) {
        console.log(`      ${id}: ${t.model}${t.extended_thinking ? ' + extended thinking' : ''}`);
      }
    }
  }

  // 5. Crear .env.playwright a partir del ejemplo (solo si no existe)
  const envDest    = path.join(projectDest, '.env.playwright');
  const envExample = path.join(projectDest, '.env.playwright.example');
  if (!fs.existsSync(envDest) && fs.existsSync(envExample)) {
    fs.copyFileSync(envExample, envDest);
    console.log('\n✅ .env.playwright creado — completa BASE_URL y las credenciales TEST_USER_* / TEST_PASS_*');
  } else if (fs.existsSync(envDest)) {
    console.log('\n   ⚠️  .env.playwright ya existe — no sobreescrito');
  }

  console.log('\n🚀 Listo! Elige tu agente:');
  console.log('   📎 GitHub Copilot  → Ctrl+Shift+I y escribe "@QA-PRO" o "@PO-PRO"');
  console.log('   🤖 Claude Code     → abre la carpeta con "claude" en terminal');
  console.log('\n   Primer paso recomendado: pide "configura el contexto del proyecto" para completar context/CONTEXT.md y context/UI-UX.md.');
  console.log('   Lee el README.md para más detalles.');
  console.log('   Para cambiar modelos: edita models.config.yml y re-ejecuta node index.js\n');
  if (!force) console.log('   Usa --force para sobreescribir archivos del workspace existentes (no afecta context/).\n');
}

main().catch(err => { console.error('\n❌ Error:', err.message); process.exit(1); });
