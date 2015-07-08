etcd0=192.168.123.100
etcd1=192.168.123.101
etcd2=192.168.123.102
INITIAL_CLUSTER="etcd0=http://$etcd0:2380,etcd1=http://$etcd1:2380,etcd2=http://$etcd2:2380"
for name in etcd0 etcd1 etcd2; do
   ssh -t ${!name} \
       sed -i -e "s#.*ETCD_NAME=.*#ETCD_NAME=$name#" \
                 -e "s#.*ETCD_INITIAL_ADVERTISE_PEER_URLS=.*#ETCD_INITIAL_ADVERTISE_PEER_URLS=http://${!name}:2380#" \
                 -e "s#.*ETCD_LISTEN_PEER_URLS=.*#ETCD_LISTEN_PEER_URLS=http://${!name}:2380#" \
                 -e "s#.*ETCD_LISTEN_CLIENT_URLS=.*#ETCD_LISTEN_CLIENT_URLS=http://${!name}:2379,http://127.0.0.1:2379,http://127.0.0.1:4001#" \
                 -e "s#.*ETCD_ADVERTISE_CLIENT_URLS=.*#ETCD_ADVERTISE_CLIENT_URLS=http://${!name}:2379#" \
                 -e "s#.*ETCD_INITIAL_CLUSTER=.*#ETCD_INITIAL_CLUSTER=$INITIAL_CLUSTER#" \
           /etc/etcd/etcd.conf
done

