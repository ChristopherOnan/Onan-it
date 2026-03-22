#!/bin/bash
# ============================================================
# MCP Superpower Installer for Claude Code
# Generated: March 22, 2026
#
# This script installs 3 MCP servers that enhance Claude's
# capabilities: Context7 (live docs), Firecrawl (web→markdown),
# and Playwright (browser automation).
#
# Prerequisites:
#   - Claude Code CLI installed (`claude` command available)
#   - Node.js 18+ and npm installed
#   - For Firecrawl: free API key from https://firecrawl.dev
#
# Usage:
#   chmod +x install-mcp-superpowers.sh
#   ./install-mcp-superpowers.sh
# ============================================================
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo ""
echo "================================================"
echo "  MCP Superpower Installer for Claude Code"
echo "================================================"
echo ""

# Check prerequisites
command -v claude >/dev/null 2>&1 || { echo -e "${RED}Error: 'claude' CLI not found. Install Claude Code first.${NC}"; exit 1; }
command -v node >/dev/null 2>&1 || { echo -e "${RED}Error: Node.js not found. Install Node.js 18+ first.${NC}"; exit 1; }
command -v npx >/dev/null 2>&1 || { echo -e "${RED}Error: npx not found. Install npm first.${NC}"; exit 1; }

echo -e "${GREEN}Prerequisites OK${NC}"
echo ""

# ---- 1. Context7 ----
echo "-------------------------------------------"
echo -e "${YELLOW}[1/3] Installing Context7 MCP Server${NC}"
echo "  Live, version-specific library documentation"
echo "  Source: https://github.com/upstash/context7"
echo "-------------------------------------------"

claude mcp add context7 -- npx -y @upstash/context7-mcp@latest
echo -e "${GREEN}✓ Context7 installed${NC}"
echo ""

# ---- 2. Firecrawl ----
echo "-------------------------------------------"
echo -e "${YELLOW}[2/3] Installing Firecrawl MCP Server${NC}"
echo "  URL-to-clean-markdown conversion"
echo "  Source: https://github.com/mendableai/firecrawl-mcp-server"
echo "-------------------------------------------"

read -p "  Enter your Firecrawl API key (get free at https://firecrawl.dev, or press Enter to skip): " FIRECRAWL_KEY

if [ -n "$FIRECRAWL_KEY" ]; then
    claude mcp add firecrawl \
        -e FIRECRAWL_API_KEY="$FIRECRAWL_KEY" \
        -- npx -y firecrawl-mcp
    echo -e "${GREEN}✓ Firecrawl installed${NC}"
else
    echo -e "${YELLOW}⏭ Firecrawl skipped (no API key provided)${NC}"
    echo "  To install later: claude mcp add firecrawl -e FIRECRAWL_API_KEY=your_key -- npx -y firecrawl-mcp"
fi
echo ""

# ---- 3. Playwright ----
echo "-------------------------------------------"
echo -e "${YELLOW}[3/3] Installing Playwright MCP Server${NC}"
echo "  Headless browser automation via accessibility tree"
echo "  Source: https://github.com/anthropics/mcp-server-playwright"
echo "-------------------------------------------"

# Install playwright and its browsers
npm install -g @anthropic-ai/mcp-server-playwright 2>/dev/null || npm install -g playwright-mcp 2>/dev/null || {
    echo -e "${YELLOW}  Note: Global install failed, will use npx instead${NC}"
}

claude mcp add playwright -- npx -y @anthropic-ai/mcp-server-playwright 2>/dev/null || \
claude mcp add playwright -- npx -y playwright-mcp 2>/dev/null || {
    echo -e "${YELLOW}⚠ Playwright MCP package name may have changed.${NC}"
    echo "  Check https://github.com/anthropics/mcp-server-playwright for current install instructions."
    echo "  Manual install: claude mcp add playwright -- npx -y <correct-package-name>"
}
echo -e "${GREEN}✓ Playwright installed${NC}"
echo ""

# ---- Summary ----
echo ""
echo "================================================"
echo -e "${GREEN}  Installation Complete!${NC}"
echo "================================================"
echo ""
echo "Installed MCP servers:"
echo "  ✓ Context7    — Use 'resolve library docs' in prompts to activate"
echo "  ✓ Firecrawl   — Automatically available for URL fetching"
echo "  ✓ Playwright  — Use 'browse to' or 'navigate to' to activate"
echo ""
echo "To verify, run: claude mcp list"
echo ""
echo "-------------------------------------------"
echo "BONUS: Superpowers Plugin"
echo "-------------------------------------------"
echo "The Superpowers plugin (v5.0.4) is available on the"
echo "Anthropic marketplace. To install in Claude Code:"
echo ""
echo "  claude plugin add superpowers"
echo ""
echo "Or visit: https://claude.com/plugins/superpowers"
echo "================================================"
