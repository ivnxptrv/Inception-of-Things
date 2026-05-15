# p1

1. prepare debian based virtual machine on school machine
2. install: vagrant, quemu/kvm, libvirt

---

1. run `vagrant up`
2. run `vagrant ssh ipetrovSW`
3. run `vagrant ssh ipetrovS`
4. in ipetrovS run `sudo kubectl get nodes -o wide`
5. in ipetrovS run `ip a`
6. run `vagrant destroy -f` to clean up before next ex

---

# p2

1. prepare debian based virtual machine on school machine
2. install: vagrant, quemu/kvm, libvirt

---

1. run `vagrant up`
2. run `vagrant ssh`
3. inside run `sudo kubectl get nodes -o wide`
4. inside run `sudo kubectl get all -n kube-system`
5. inside run `sudo kubectl get all`
6. inside run `curl -H "Host:app2.com" 192.168.56.110`
7. open firefox install https://mybrowseraddon.com/modify-header-value.html
8. open firefox about:addons Extension → Preferences
9. add `http://192.168.56.110/` | `Host` | `app1.com`
10. then same for `app2.com` and `app3.com`
11. click INACIVE to make one of rules  active
12. open firefox `http://192.168.56.110/`
13. run `vagrant destroy -f` to clean up before next ex

---

# p3

1. prepare debian based virtual machine on school machine

---

1. run `cd ./scripts`
2. run `./init-cluster.sh`, it will install docker and k3d and start cluster with mapped port
3. run `./init-argocd.sh`, it will install argocd-plugin in running k3s and apply Application config
4. wait `3 min` to have wil app pulled and installed
5. try `curl http://localhost:8888/` to show response of wil app
6. in browser open `http://localhost:8888/argocd`, login: `admin`, pass: `sudo kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`
7. edit manifest in repo [link](https://github.com/ivnxptrv/ipetrov/edit/main/deployment.yml) — change `image: wil42/playground:v1` to `image: wil42/playground:v2`
8. in browser open `http://localhost:8888/` to show changed tag
9. run `sudo kubectl get all -n argocd`
10. run `sudo kubectl get all -n dev`
11. run `vagrant destroy -f` to clean up
