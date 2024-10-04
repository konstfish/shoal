module.exports = {
    branchPrefix: 'renovate/',
    username: 'renovate-release',
    gitAuthor: 'Renovate Bot <bot@renovateapp.com>',
    onboarding: false,
    platform: 'github',
    repositories: ['konstfish/shoal'],
    packageRules: [
      {
        matchUpdateTypes: ['minor', 'patch', 'pin', 'digest'],
        automerge: true
      }
    ]
  };