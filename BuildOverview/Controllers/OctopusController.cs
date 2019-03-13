using Octopus.Client;
using Octopus.Client.Model;
using Octopus.Client.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace BuildOverview.Controllers
{
    public class OctopusController : Controller
    {
        // GET: Octopus
        public ActionResult Index()
        {
            return View();
        }


        public List<ProjectResource> GetProjects()
        {
            var server = "https://gurdip-sira.octopus.app/";
            var apiKey = "API-FVRZ6YTGFVWV5YJHMJL9A58BKXK";             // Get this from your 'profile' page in the Octopus web portal
            var endpoint = new OctopusServerEndpoint(server, apiKey);
            using (var client = OctopusAsyncClient.Create(endpoint))
            {
                var repository = new OctopusRepository(endpoint);
                List<ProjectResource> prs = repository.Projects.GetAll();

                return prs;

            }
        }

        public List<EnvironmentResource> GetEnvironments()
        {
            var server = "https://gurdip-sira.octopus.app/";
            var apiKey = "API-FVRZ6YTGFVWV5YJHMJL9A58BKXK";             // Get this from your 'profile' page in the Octopus web portal
            var endpoint = new OctopusServerEndpoint(server, apiKey);
            using (var client = OctopusAsyncClient.Create(endpoint))
            {
                var repository = new OctopusRepository(endpoint);
                List<EnvironmentResource> envs = repository.Environments.GetAll();

              

                return envs;

            }
        }

        public void GetEnvironmentData(List<EnvironmentResource> er)
        {
            
        }

        public void GetProjectData(List<ProjectResource> projectResources)
        {
           foreach (ProjectResource project in projectResources)
            {
                //project.Name;
                //project.ProjectConnectivityPolicy.TargetRoles;
               
            }
        }
    }
}