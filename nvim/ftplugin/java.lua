-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
local mason_register = require 'mason-registry'
local jdtls = require 'jdtls'

vim.uv.os_setenv('JAVA_HOME', '/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home')
local home = vim.env.HOME -- Get the home directory

local jdtls_package = mason_register.get_package 'jdtls'
local jdtls_path = jdtls_package:get_install_path()
local launcher_jar_path = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
local configuration_path = vim.fn.glob(jdtls_path .. '/config_mac')

local workspace_path = home .. '/.local/share/nvim/jdtls-workspace/'
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = workspace_path .. project_name

-- Needed for debugging
local bundles = {
  vim.fn.glob(home .. '/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar'),
}

-- Needed for running/debugging unit tests
vim.list_extend(bundles, vim.split(vim.fn.glob(home .. '/.local/share/nvim/mason/share/java-test/*.jar', 1), '\n'))

local config = {
  -- The command that starts the language server
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = {

    'java', -- or '/path/to/java17_or_newer/bin/java'
    -- depends on if `java` is in your $PATH env variable and if it points to the right version.

    '-Declipse.application=org.eclipse.jdt.ls.core.id1',
    '-Dosgi.bundles.defaultStartLevel=4',
    '-Declipse.product=org.eclipse.jdt.ls.core.product',
    '-Dlog.protocol=true',
    '-Dlog.level=ALL',
    '-Xmx1g',
    '--add-modules=ALL-SYSTEM',
    '--add-opens',
    'java.base/java.util=ALL-UNNAMED',
    '--add-opens',
    'java.base/java.lang=ALL-UNNAMED',

    '-jar',
    launcher_jar_path,
    '-configuration',
    configuration_path,
    '-data',
    workspace_dir,
  },

  -- This is the default if not provided, you can remove it. Or adjust as needed.
  -- One dedicated LSP server & client will be started per unique root_dir
  --
  -- vim.fs.root requires Neovim 0.10.
  -- If you're using an earlier version, use: require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
  root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),

  -- here you can configure eclipse.jdt.ls specific settings
  -- see https://github.com/eclipse/eclipse.jdt.ls/wiki/running-the-java-ls-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      home = '/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home',
      eclipse = {
        downloadsources = true,
      },
      configuration = {
        --[[
          Specifies how modifications on build files update the Java classpath/configuration
          default is 'interactive'
         --]]
        updatebuildconfiguration = 'interactive',
        eclipse = {
          downloadSources = true,
        },
        runtimes = {
          {
            name = 'JavaSE-11',
            path = '/Library/Java/JavaVirtualMachines/temurin-11.jdk/Contents/Home',
          },
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        references = {
          includeDecompiledSources = true,
        },
        signatureHelp = { enabled = true },
        format = {
          enabled = true,
          -- Formatting works by default, but you can refer to a specific file/URL if you choose
          settings = {
            url = 'https://github.com/google/styleguide/blob/gh-pages/intellij-java-google-style.xml',
            profile = 'GoogleStyle',
          },
        },
        completion = {
          favoriteStaticMembers = {
            'org.hamcrest.MatcherAssert.assertThat',
            'org.hamcrest.Matchers.*',
            'org.hamcrest.CoreMatchers.*',
            'org.junit.jupiter.api.Assertions.*',
            'java.util.Objects.requireNonNull',
            'java.util.Objects.requireNonNullElse',
            'org.mockito.Mockito.*',
          },
          importOrder = {
            'java',
            'javax',
            'com',
            'org',
          },
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
          },
          useBlocks = true,
        },
      },
    },
  },
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
  flags = {
    allow_incremental_sync = true,
  },
  init_options = {
    -- References the bundles defined above to support Debugging and Unit Testing
    bundles = bundles,
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },
}
config['on_attach'] = function(client, buffer)
  jdtls.setup_dap { hotcodereplace = 'auto', config_overrides = {} }
  require('jdtls.dap').setup_dap_main_class_configs()
end
-- This starts a new client & server,
-- or attaches to an existing client & server depending on the `root_dir`.
jdtls.start_or_attach(config)
