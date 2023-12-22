export default {
    skipCommitsWithoutPullRequest: false,
    beforePrepare: async ({ exec, nextVersion }) => {
      await exec(`sed -i "s/^version:.*$/version: ${nextVersion}/g" chart/Chart.yaml`);
    },
  }