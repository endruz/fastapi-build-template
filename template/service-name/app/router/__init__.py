#!/usr/bin/env python
# coding:utf-8

from fastapi import FastAPI, Request
from starlette.responses import HTMLResponse
from fastapi.openapi.docs import get_swagger_ui_html

from app.router.root_router import root_router


def register_routers(app: FastAPI) -> None:
    async def custom_swagger_ui_html(req: Request) -> HTMLResponse:
        root_path = req.scope.get("root_path", "").rstrip("/")
        openapi_url = root_path + app.openapi_url
        oauth2_redirect_url = app.swagger_ui_oauth2_redirect_url
        if oauth2_redirect_url:
            oauth2_redirect_url = root_path + oauth2_redirect_url
        return get_swagger_ui_html(
            openapi_url=openapi_url,
            title=app.title + " - Swagger UI",
            oauth2_redirect_url=oauth2_redirect_url,
            swagger_js_url="/static/swagger/swagger-ui-bundle.js",
            swagger_css_url="/static/swagger/swagger-ui.css",
            swagger_favicon_url="/static/swagger/favicon.png",
        )

    # swagger-ui 本地化
    app.add_route("/docs", custom_swagger_ui_html, include_in_schema=False)
    # 注册路由
    app.include_router(root_router, prefix="")


__all__ = [
    "register_routers",
]
