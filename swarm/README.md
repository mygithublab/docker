# CREATE A SWARM

Swarm usage introduce

1. Open a terminal and ssh into the machine where you want to run your manager node.

docker swarm init --advertise-addr <MANAGER-IP>

e.g. --> 

$ docker swarm init --advertise-addr 192.168.99.100

Swarm initialized: current node (dxn1zf6l61qsb1josjja83ngz) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \

    --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \

    192.168.99.100:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

     <--

3. View information about nodes.

$ docker node ls

# ADD NODES TO THE SWARM

1. Create a worker node joined to the existing swarm.

$ docker swarm join \

  --token  SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \

  192.168.99.100:2377

This node joined a swarm as a worker.

2. If you don't have the command available, you can run the following command on a manager node to retrieve the join command for a worker.

$ docker swarm join-token worker

To add a worker to this swarm, run the following command:

    docker swarm join \

    --token SWMTKN-1-49nj1cmql0jkz5s954yi3oex3nedyz0fb0xx14ie39trti4wxv-8vxv8rssmk743ojnwacrr2e7c \

    192.168.99.100:2377

# DEPLOY A SERVICE TO THE SWARM

1. Deploy a service to the swarm.

$ docker service create --replicas 1 --name helloworld alpine ping docker.com

9uk4639qpg7npwf3fn2aasksr

2. View the list of running service.

$ docker service ls

ID            NAME        SCALE  IMAGE   COMMAND

9uk4639qpg7n  helloworld  1/1    alpine  ping docker.com

# INSPECT A SERVICE ON THE SWARM

1. Display the details about a service in an easily readable format.

$ docker service inspect --pretty helloworld

2. To return the service details in json format, run the same command without the --pretty flag.

$ docker service inspect helloworld    

3. See which nodes are running the service.

$ docker service ps helloworld

4. Run docker ps on the node where the task is running to see details about the container for the task.

$docker ps

# SCALE THE SERVICE IN THE SWARM

1. Run the following command to change the desired state of the service running in the swarm.

$ docker service scale <SERVICE-ID>=<NUMBER-OF-TASKS>

e.g. -->

$ docker service scale helloworld=5

helloworld scaled to 5

     <--

2. Run docker service ps <SERVICE-ID> to see the updated task list.

$ docker service ps helloworld

# DELETE THE SERVICE RUNNING ON THE SWARM

1. Run docker service rum helloworld to remove the helloworld service.

$ docker service rm helloworld

helloworld

2. Run docker service inspect <SERICE-ID> to verify that the swarm manager removed the service. The CLI returns a message that the service is not found.

$ docker service inspect helloworld

[]

Error: no such service: helloworld

# APPLY ROLLING UPDATES TO A SERVICE

1. Deply Redis 3.0.6 to the swarm and configure the swarm with a 10 second update delay:

$ docker service create \

  --replicas 3 \

  --name redis \

  --update-delay 10s \

  redis:3.0.6

0u6a4s31ybk7yw2wyvtikmu50

2. Now you can update the container image for redis. The swarm manager applies the update to nodes according to the UpdateConfig policy.

$ docker service update --image redis:3.0.7 redis

redis

3. The output of service inspect shows if your update paused due to failure:

$ docker service inspect --pretty redis

ID:             0u6a4s31ybk7yw2wyvtikmu50

Name:           redis

...snip...

Update status:

 State:      paused

 Started:    11 seconds ago

 Message:    update paused due to failure or early termination of task 9p7ith557h8ndf0ui9s0q951b

...snip...

4. To restart a paused update run docker service update <SERVICE-ID>.

e.g. -->

docker service update redis

     <--

# DRAIN A NODE ON THE SWARM

1. Verify that all your nodes are actively available.

$ docker node ls

ID                           HOSTNAME  STATUS  AVAILABILITY  MANAGER STATUS

1bcef6utixb0l0ca7gxuivsj0    worker2   Ready   Active

38ciaotwjuritcdtn9npbnkuz    worker1   Ready   Active

e216jshn25ckzbvmwlnh5jr3g *  manager1  Ready   Active        Leader

2. If you aren't still running the redis service from the rolling update tutorial, start it now.

$ docker service create --replicas 3 --name redis --update-delay 10s redis:3.0.6

c5uo6kdmzpon37mgj9mwglcfw

3. Run docker service ps redis to see how the swarm manager assigned the tasks to different nodes.

$ docker service ps redis

NAME                               IMAGE        NODE     DESIRED STATE  CURRENT STATE

redis.1.7q92v0nr1hcgts2amcjyqg3pq  redis:3.0.6  manager1 Running        Running 26 seconds

redis.2.7h2l8h3q3wqy5f66hlv9ddmi6  redis:3.0.6  worker1  Running        Running 26 seconds

redis.3.9bg7cezvedmkgg6c8yzvbhwsd  redis:3.0.6  worker2  Running        Running 26 seconds

4. Run docker node update --availablility drain <NODE-ID> to drain a node that had a task assigned to it.

docker node update --availability drain worker1

worker1

5. Inspect the node to check its availability.

$ docker node inspect --pretty worker1

ID:			38ciaotwjuritcdtn9npbnkuz

Hostname:		worker1

Status:

 State:			Ready

 Availability:		Drain

...snip...

6. Run docker node update --availability active <NODE-ID> to return the drained node to an active state:

$ docker node update --availability active worker1

worker1

# USE SWARM MODE ROUTING MESH

1. In order to use the ingress network in the swarm, you need to have the following ports open between the swarm nodes before you enable swarm mode.

Port 7946 TCP/UDP for container network discovery.

Port 4789 UDP for the container ingress network.

# PUBLISH A PORT FOR A SERVICE

Use the --publish flag to publish a port when you create a service. 

Targe is used to specify the port inside the container, and published is used to specify the port to bind on the routing mesh.

If you leave off the published port, a random high-numbered port is bound for each service task. 

You will need to inspect the task to determine the port.

$ docker service create \

  --name <SERVICE-NAME> \

  --publish published=<PUBLISHED-PORT>,target=<CONTAINER-PORT> \

  <IMAGE>

e.g. --> 

The following command published port 80 in the nginx container to port 8080 for any node in the warm:

$ docker service create \

  --name my-web \

  --publish published=8080,target=80 \

  --replicas 2 \

  nginx

     -->

You can publish a port for an existing service using the following command.

$ docker service update \

  --publish-add published=<PUBLISHED-PORT>,target=<CONTAINER-PORT> \

  <SERVICE>

You can use docker service inspect to view the service's published port.

For instance:

$ docker service inspect --format="{{json .Endpoint.Spec.Ports}}" my-web

[{"Protocol":"tcp","TargetPort":80,"PublishedPort":8080}]

# PUBLISH A PORT FOR TCP ONLY OR UDP ONLY

By default, wheyn you publish a port, it is a TCP.

You can specifically publish a UDP port instead of or in addition to a TCP port.

When you publish both TCP and UDP ports, if you omit the protocol specifier, the port is pubilshed as a TCP port.

If you use the longer syntax (recommended for Docker 1.13 and higher), set the protocol key to either tcp or udp.

1. TCP ONLY

Long syntax:

$ docker service create --name dns-cache \

  --publish published=53,target=53 \

  dns-cache

Short syntax:

$ docker service create --name dns-cache \

  -p 53:53 \

  dns-cache

2. TCP AND UDP

Long syntax:

$ docker service create --name dns-cache \

  --publish published=53,target=53 \

  --publish published=53,target=53,protocol=udp \

  dns-cache

Short syntax:

$ docker service create --name dns-cache \

  -p 53:53 \

  -p 53:53/udp \

  dns-cache

2. UDP ONLY

Long syntax:

$ docker service create --name dns-cache \

  --publish published=53,target=53,protocol=udp \

  dns-cache

Short syntax:

$ docker service create --name dns-cache \

  -p 53:53/udp \

  dns-cache

# BYPASS THE ROUTING MESH

You can bypass the routing mesh, so that when you access the bound port on a given node, you are always accessing the instance of the service running on that node. 
This is referred to as host mode. There are a few things to keep in mind.

1. If you access a node which is not running a service task, the service will not be listening on that port.
  
   It is possible that nothing will be listening, or that a completely different application will be listening.

2. If you expect to run multiple service tasks on each node (such as when you have 5 nodes but run 10 replicas), you cannot specify a static target port.
  
   Either allow Docker to assign a random high-numbered port (by leaving off the target), or ensure that only a single instance of the service runs on a given node, by using a global service rather than a replicated one, or by using placement constraints.

To bypass the routing mesh, you must use the long --publish service and set mode to host. 

If you omit the mode key or set it to ingress, the routing mesh is used. 

The following command creates a global service using host mode and bypassing the routing mesh.

$ docker service create --name dns-cache \

  --publish published=53,target=53,protocol=udp,mode=host \

  --mode global \

  dns-cache

# CONFIGURE AN EXTERNAL LOAD BALANCER

You can configure an external load balancer for swarm services, either in combination with the routing mesh or without using the routing mesh at all.

1. Using the routing mesh

You can configure an external load balancer to route requests to a swarm service. 

For example, you could configure HAProxy to balance requests to an nginx service published to port 8080.

In this case, port 8080 must be open between the load balancer and the nodes in the swarm. 

The swarm nodes can reside on a private network that is accessible to the proxy server, but that is not publicly accessible.

You can configure the load balancer to balance requests between every node in the swarm even if there are no tasks scheduled on the node. 

For example, you could have the following HAProxy configuration in 

/etc/haproxy/haproxy.cfg:

     -->

global
        log /dev/log    local0
        log /dev/log    local1 notice
...snip...

//# Configure HAProxy to listen on port 80
frontend http_front
   bind *:80
   stats uri /haproxy?stats
   default_backend http_back

//# Configure HAProxy to route requests to swarm nodes on port 8080
backend http_back
   balance roundrobin
   server node1 192.168.99.100:8080 check
   server node2 192.168.99.101:8080 check
   server node3 192.168.99.102:8080 check

     <--

When you access the HAProxy load balancer on port 80, it forwards requests to nodes in the swarm. 

The swarm routing mesh routes the request to an active task. 

If, for any reason the swarm scheduler dispatches tasks to different nodes, you don’t need to reconfigure the load balancer.

You can configure any type of load balancer to route requests to swarm nodes. 

To learn more about HAProxy, see the HAProxy documentation. ->  https://cbonte.github.io/haproxy-dconv/

2. Without the routing mesh

To use an external load balancer without the routing mesh, set --endpoint-mode to dnsrr instead of the default value of vip. 

In this case, there is not a single virtual IP. 

Instead, Docker sets up DNS entries for the service such that a DNS query for the service name returns a list of IP addresses, and the client connects directly to one of these. 

You are responsible for providing the list of IP addresses and ports to your load balancer. 

See Configure service discovery. -> https://docs.docker.com/engine/swarm/networking/#learn-more

