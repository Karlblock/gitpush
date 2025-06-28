import * as vscode from 'vscode';
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

export function activate(context: vscode.ExtensionContext) {
    console.log('Gitpush extension is now active!');

    // Status bar item
    const statusBarItem = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
    statusBarItem.text = "$(git-commit) Gitpush";
    statusBarItem.tooltip = "Click for Gitpush menu";
    statusBarItem.command = 'gitpush.showMenu';
    statusBarItem.show();

    // Commands
    const smartCommit = vscode.commands.registerCommand('gitpush.smartCommit', async () => {
        await handleSmartCommit();
    });

    const createIssue = vscode.commands.registerCommand('gitpush.createIssue', async () => {
        await handleCreateIssue();
    });

    const showStats = vscode.commands.registerCommand('gitpush.showStats', async () => {
        await handleShowStats();
    });

    const aiReview = vscode.commands.registerCommand('gitpush.aiReview', async () => {
        await handleAiReview();
    });

    const showMenu = vscode.commands.registerCommand('gitpush.showMenu', async () => {
        await handleShowMenu();
    });

    context.subscriptions.push(smartCommit, createIssue, showStats, aiReview, showMenu, statusBarItem);
}

async function handleSmartCommit() {
    try {
        // Check if gitpush is installed
        const gitpushPath = await findGitpush();
        if (!gitpushPath) {
            const install = await vscode.window.showErrorMessage(
                'Gitpush CLI not found. Install it first?',
                'Install', 'Cancel'
            );
            if (install === 'Install') {
                vscode.env.openExternal(vscode.Uri.parse('https://github.com/Karlblock/gitpush'));
            }
            return;
        }

        // Show progress
        await vscode.window.withProgress({
            location: vscode.ProgressLocation.Notification,
            title: "Generating AI commit message...",
            cancellable: false
        }, async (progress) => {
            try {
                // Get git diff
                const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
                if (!workspaceFolder) {
                    throw new Error('No workspace folder found');
                }

                // Execute gitpush AI commit
                const { stdout, stderr } = await execAsync(
                    `cd "${workspaceFolder.uri.fsPath}" && gitpush --ai-commit --yes`,
                    { timeout: 30000 }
                );

                if (stderr) {
                    throw new Error(stderr);
                }

                vscode.window.showInformationMessage('✅ Smart commit completed!');
                
                // Refresh git decoration
                vscode.commands.executeCommand('git.refresh');
                
            } catch (error) {
                throw error;
            }
        });

    } catch (error) {
        vscode.window.showErrorMessage(`Gitpush error: ${error}`);
    }
}

async function handleCreateIssue() {
    const title = await vscode.window.showInputBox({
        prompt: 'Issue title',
        placeHolder: 'Describe the issue...'
    });

    if (!title) return;

    const description = await vscode.window.showInputBox({
        prompt: 'Issue description (optional)',
        placeHolder: 'Additional details...'
    });

    const labels = await vscode.window.showQuickPick([
        'bug', 'enhancement', 'feature', 'documentation', 'question'
    ], {
        canPickMany: true,
        placeHolder: 'Select labels'
    });

    try {
        const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
        if (!workspaceFolder) {
            throw new Error('No workspace folder found');
        }

        let command = `cd "${workspaceFolder.uri.fsPath}" && gitpush --issues`;
        // Here we'd need to extend gitpush CLI to accept issue creation params
        
        vscode.window.showInformationMessage('📝 Issue creation feature coming soon!');
        
    } catch (error) {
        vscode.window.showErrorMessage(`Error creating issue: ${error}`);
    }
}

async function handleShowStats() {
    try {
        const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
        if (!workspaceFolder) {
            throw new Error('No workspace folder found');
        }

        const { stdout } = await execAsync(
            `cd "${workspaceFolder.uri.fsPath}" && gitpush --stats --json`,
            { timeout: 10000 }
        );

        // Parse stats and show in webview
        const panel = vscode.window.createWebviewPanel(
            'gitpushStats',
            'Gitpush Analytics',
            vscode.ViewColumn.One,
            { enableScripts: true }
        );

        panel.webview.html = getStatsWebviewContent(stdout);

    } catch (error) {
        vscode.window.showErrorMessage(`Error loading stats: ${error}`);
    }
}

async function handleAiReview() {
    try {
        const workspaceFolder = vscode.workspace.workspaceFolders?.[0];
        if (!workspaceFolder) {
            throw new Error('No workspace folder found');
        }

        await vscode.window.withProgress({
            location: vscode.ProgressLocation.Notification,
            title: "AI analyzing your code...",
            cancellable: false
        }, async () => {
            const { stdout } = await execAsync(
                `cd "${workspaceFolder.uri.fsPath}" && gitpush --ai`,
                { timeout: 30000 }
            );

            // Show results in output channel
            const output = vscode.window.createOutputChannel('Gitpush AI Review');
            output.clear();
            output.appendLine(stdout);
            output.show();
        });

    } catch (error) {
        vscode.window.showErrorMessage(`AI review error: ${error}`);
    }
}

async function handleShowMenu() {
    const action = await vscode.window.showQuickPick([
        '🤖 Smart Commit (AI)',
        '📝 Create Issue',
        '📊 Show Stats',
        '🔍 AI Code Review',
        '⚙️ Configure AI'
    ], {
        placeHolder: 'What would you like to do?'
    });

    switch (action) {
        case '🤖 Smart Commit (AI)':
            vscode.commands.executeCommand('gitpush.smartCommit');
            break;
        case '📝 Create Issue':
            vscode.commands.executeCommand('gitpush.createIssue');
            break;
        case '📊 Show Stats':
            vscode.commands.executeCommand('gitpush.showStats');
            break;
        case '🔍 AI Code Review':
            vscode.commands.executeCommand('gitpush.aiReview');
            break;
        case '⚙️ Configure AI':
            await configureAI();
            break;
    }
}

async function configureAI() {
    const config = vscode.workspace.getConfiguration('gitpush');
    
    const provider = await vscode.window.showQuickPick([
        'openai', 'anthropic', 'google', 'local'
    ], {
        placeHolder: 'Select AI provider'
    });

    if (provider) {
        await config.update('aiProvider', provider, vscode.ConfigurationTarget.Global);
        
        if (provider !== 'local') {
            const apiKey = await vscode.window.showInputBox({
                prompt: `Enter your ${provider} API key`,
                password: true
            });
            
            if (apiKey) {
                await config.update('apiKey', apiKey, vscode.ConfigurationTarget.Global);
                vscode.window.showInformationMessage('✅ AI configured successfully!');
            }
        } else {
            vscode.window.showInformationMessage('✅ Local AI configured! Make sure Ollama is running.');
        }
    }
}

async function findGitpush(): Promise<string | null> {
    try {
        const { stdout } = await execAsync('which gitpush');
        return stdout.trim();
    } catch {
        return null;
    }
}

function getStatsWebviewContent(statsJson: string): string {
    return `<!DOCTYPE html>
    <html>
    <head>
        <style>
            body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; }
            .stat { margin: 10px 0; padding: 10px; background: #f5f5f5; border-radius: 5px; }
        </style>
    </head>
    <body>
        <h1>📊 Gitpush Analytics</h1>
        <div class="stat">
            <h3>📝 Total Commits</h3>
            <p>Coming soon...</p>
        </div>
        <div class="stat">
            <h3>🤖 AI Usage</h3>
            <p>Coming soon...</p>
        </div>
        <pre>${statsJson}</pre>
    </body>
    </html>`;
}

export function deactivate() {}