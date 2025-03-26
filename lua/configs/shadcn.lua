return {
    default_installer = 'pnpm',

    format = {
        doc = 'https://ui.shadcn.com/docs/components/%s', -- or https://mynaui.com/components/%s
        npm = 'npx shadcn@latest add %s',
        pnpm = 'pnpm dlx shadcn@latest add %s',
        yarn = 'npx shadcn@latest add %s',
        bun = 'bunx --bun shadcn@latest add %s',
    },

    keys = { -- for telescope
        i = { doc = '<C-o>' },
        n = { doc = '<C-o>' },
    },

    telescope_config = {
        sorting_strategy = 'ascending',
        layout_config = {
            prompt_position = 'top',
            ...
        },
        prompt_title = 'Shadcn UI components',
    },
}
