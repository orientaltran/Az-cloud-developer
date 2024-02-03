# Write-up Template

### Analyze, choose, and justify the appropriate resource option for deploying the app.

For both a VM or App Service solution for the CMS app, let's analyze costs, scalability, availability, and workflow to determine the appropriate resource option for deployment.

**Costs:**

- \*VM: VMs typically involve low up-front costs compared to App Service. You pay for the VM instances, storage, networking, and related services. However, VMs can be shut down when not in use, reducing costs during idle periods.
- \*App Service: App Service involves ongoing costs even if the app is not in use. However, the costs are usually lower compared to VMs. App Service pricing tiers offer different levels of features, scalability, and performance, allowing better cost control.
  **Scalability:**
- \*VM: VMs can be scaled vertically (increasing the VM size) or horizontally (adding more VM instances) to handle increased traffic or workload. However, scaling VMs requires manual intervention and can result in downtime during the scaling process.
- \*App Service: App Service provides built-in scalability features. It supports automatic scaling based on metrics like CPU utilization or requests per second. It can dynamically adjust resources without manual intervention, ensuring seamless scalability.
  **Availability:**
- \*VM: VM-based solutions can achieve high availability through strategies like load balancing, auto-scaling, and deploying VM instances across multiple availability zones or regions. However, ensuring high availability requires additional configuration and management efforts.
- \*App Service: App Service offers built-in high availability. It distributes the app across multiple instances and availability zones, handles load balancing, and provides fault tolerance, reducing the effort required to ensure high availability.
  **Workflow:**
- \*VM: Deploying an app on a VM involves managing the underlying infrastructure, including operating system updates, security patches, and maintenance tasks. This requires more manual effort and system administration skills. VMs offer greater flexibility and control over the environment.
- \*App Service: App Service abstracts away the underlying infrastructure management. Developers can focus on deploying and managing the app code while Azure handles the underlying infrastructure, including OS updates, patching, and security. This simplifies the workflow and reduces operational overhead.

### Choose the appropriate solution (VM or App Service) for deploying the app

Based on the analysis, the appropriate solution for deploying the CMS app would be Azure App Service. Here's the justification for this choice:

- \*Costs: While App Service involves ongoing costs, it is generally more cost-effective compared to VMs. Given that the CMS app is lightweight with basic functions, App Service's pricing tiers can offer a suitable cost structure.
- \*Scalability: App Service provides built-in scalability with automatic scaling based on metrics. Since the CMS app does not require a high-performance compute service, App Service's scalability capabilities should be sufficient.
- \*Availability: App Service offers high availability with built-in distribution, load balancing, and fault tolerance features. This ensures that the CMS app remains accessible and operational, even during high traffic or in case of failures.
- \*Workflow: App Service simplifies the deployment and management process by abstracting away the underlying infrastructure. This allows developers to focus on the app code, reducing operational overhead and enabling faster development cycles.

### Assess app changes that would change your decision.

To change the decision of deploying the CMS app on App Service and opt for a VM-based solution, the following app changes or needs would have to be considered:

- \*High-performance requirements: If the CMS app requires a high-performance compute service or has resource-intensive tasks, a VM-based solution might be more suitable. VMs provide more control over the underlying hardware and can be optimized for specific performance needs.
- \*Advanced customization: If the app requires extensive customization of the underlying infrastructure, such as specific security measures or custom server configurations not supported by App Service, a VM-based solution would be preferred.
- \*Specific networking configurations: If the app has advanced networking requirements or relies on specific network settings that are not supported by App Service, a VM-based solution may be necessary.
- \*Dependency on specific operating system or runtime: If the CMS app depends on a specific operating system or runtime that is not available on App Service, deploying on a VM would be required.

_It is important to evaluate these app changes or needs, considering the trade-offs between the benefits of App Service (e.g., simplified management, scalability, and cost savings) and the specific requirements that may warrant a VM-based solution._
