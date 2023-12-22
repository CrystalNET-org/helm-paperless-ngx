export default {
    skipCommitsWithoutPullRequest: false,
    beforePrepare: async ({ exec, nextVersion }) => {
      await exec(`sed -i "s/^version:.*$/version: ${nextVersion}/g" chart/Chart.yaml`);
    },
  }
//TODO: helm-docs --template-files=./README.md.gotmpl --output-file=../README.md chart/