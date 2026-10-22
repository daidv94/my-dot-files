module.exports = {
  defaultBrowser: {
    name: "Google Chrome",
    profile: "Default" // Fallback profile for unmatched links
  },
  handlers: [
    // --- Route by source application (Slack, Teams, Terminal, etc.) ---
    {
      match: ({ opener }) =>
        opener && ["Slack"].includes(opener.name),
      browser: {
        name: "Google Chrome",
        profile: "Profile 4"
      }
    },

    // --- Route by domain or URL pattern ---
    {
      match: ({ url }) => [
        "pieis-team.atlassian.net",
        "pieis.backlog.com",
        "gitlab.mng.development.prmsysint.com"
      ].some(domain => url.host.endsWith(domain)),
      browser: {
        name: "Google Chrome",
        profile: "Profile 4"
      }
    },

    // --- Route by path or regex ---
    // {
    //   match: ({ url }) => /internal-corp-pattern/.test(url.pathname),
    //   browser: {
    //     name: "Google Chrome",
    //     profile: "Profile 1"
    //   }
    // },

    // --- Route personal domains ---
    // {
    //   match: ({ url }) => [
    //     "youtube.com",
    //     "reddit.com",
    //     "x.com"
    //   ].some(domain => url.host.endsWith(domain)),
    //   browser: {
    //     name: "Google Chrome",
    //     profile: "Default" // Your Personal profile folder
    //   }
    // }
  ]
};
