Sure, here's a detailed analysis report based on your draft:

---

### Analysis Report: Research on Jenkins Integration with A3P using AWS SSM Documents and Assume Role

#### 1. Introduction

Currently, we are utilizing AWS STS (Security Token Service) to assume roles and obtain temporary credentials from Jenkins to perform specific operations on our existing AWS cloud platform, referred to as AWS Legacy. The Cloud team is developing a new platform called A3P (AWS as a Platform). This report explores the options for Jenkins to connect to the new AWS platform and outlines potential solutions and their feasibility.

#### 2. Current Process

In the existing setup:
- Jenkins uses STS assume role to fetch temporary credentials.
- This requires updating the CloudBees Jenkins instance role permissions, allowing Jenkins to assume the role in the target account to fetch credentials.
- This process involves production changes as Jenkins and its agents are running in the production environment.

#### 3. Proposed Solutions and Analysis

##### Solution 1: Using SSM Document API

- **Idea:**
  - Configure SSM documents in each AWS account during the onboarding process.
  - Jenkins can make an API call to the SSM document in AWS Cloud to fetch the credentials on the fly.
- **Advantages:**
  - Simplifies credential management by using SSM.
  - Reduces the need for Jenkins to manage long-term credentials.
- **Disadvantages:**
  - Requires managing a long-running credential service account to make the API call.
  - A3P team rejected this Proof of Concept (POC) as it contradicts their requirement to avoid long-running credential management.

##### Solution 2: Current Standard with Improvements

- **Current Standard:**
  - Each application has a dedicated Jenkins agent.
  - Each application has an AWS account for each environment.
  - Roles are created for each application (e.g., `role-sys-cloudbees-xyz` for application ID `xyz`).
  - Jenkins agent role policies are updated to assume the specific role and perform necessary actions.
  - This approach adheres to the principle of least privilege.
- **Challenges:**
  - Requires manual role creation and policy updates during AWS account onboarding.

- **Proposed Improvement:**
  - Automate the role creation and Jenkins instance role policy update process as part of AWS account onboarding.
  - This will minimize manual intervention and streamline the process.

##### Solution 3: Simplified Approach

- **Idea:**
  - Create a role called `role-sys-cloudbees-pipeline` in the AWS prod account where Jenkins is running.
  - Onboard a Lambda function in all new A3P AWS accounts to provide temporary credentials.
  - Create a role called `role-sys-cloudbees-a3p` with permissions to invoke the Lambda function in target A3P accounts.
  - Grant `role-sys-cloudbees-pipeline` access to all Jenkins agents.
  - Allow `role-sys-cloudbees-a3p` to assume `role-sys-cloudbees-pipeline` and grant Jenkins agents permission to assume `role-sys-cloudbees-a3p` to fetch temporary credentials.

- **Advantages:**
  - Centralizes and simplifies the credential management process.
  - Reduces the need for multiple roles per application and environment.
  - Enhances security by maintaining least privilege principles.

- **Implementation Steps:**
  1. **Create `role-sys-cloudbees-pipeline`:**
     - Define this role in the AWS production account.
  2. **Deploy Lambda Function:**
     - Create and deploy a Lambda function in all A3P AWS accounts to generate temporary credentials.
  3. **Create `role-sys-cloudbees-a3p`:**
     - Define this role with permissions to invoke the Lambda function.
  4. **Configure Role Assumptions:**
     - Ensure `role-sys-cloudbees-pipeline` can be assumed by `role-sys-cloudbees-a3p`.
     - Allow Jenkins agents to assume `role-sys-cloudbees-a3p` to fetch credentials.

#### 4. Conclusion

Based on the research and analysis:
- **Solution 1 (SSM Document API)** was rejected due to the requirement of managing long-running credentials, which does not align with A3P’s security practices.
- **Solution 2 (Current Standard with Improvements)** involves automating the role creation and policy updates, reducing manual efforts and potential errors.
- **Solution 3 (Simplified Approach)** provides a centralized and efficient way to manage credentials, adhering to security principles and reducing complexity.

#### 5. Recommendations

- **Adopt Solution 3:** Implement the simplified approach to streamline credential management for Jenkins in the A3P environment. This approach balances security, efficiency, and scalability.
- **Automate Onboarding:** Integrate the role creation and policy update automation as part of the AWS account onboarding process.
- **Continuous Monitoring and Optimization:** Regularly review and optimize the credential management process to adapt to any changes in security policies or operational requirements.

---

### Action Items:

- Draft and implement the necessary AWS IAM roles and policies.
- Develop and deploy the Lambda function in all A3P accounts.
- Update Jenkins configuration to utilize the new credential management process.
- Monitor and refine the implementation to ensure it meets operational and security needs.

---

This analysis report can be attached to the Jira story for further discussion and implementation.

---

Feel free to adjust or add any specific details relevant to your requirements.
