#!/usr/bin/env python
# coding:utf-8

from locust import HttpUser, task, between


class QuickstartUser(HttpUser):
    wait_time = between(1, 2)

    @task(1)
    def welcome(self):
        response = self.client.get(url="/")
        if response.status_code == 200:
            print("request welcome success")
        else:
            print("request welcome fails")


if __name__ == "__main__":
    import os

    os.system("locust --config=master.conf")
