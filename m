Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4EE71119C
	for <lists+live-patching@lfdr.de>; Thu,  2 May 2019 04:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfEBCj7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 1 May 2019 22:39:59 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:33649 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726397AbfEBCj7 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 1 May 2019 22:39:59 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 08CAB65B;
        Wed,  1 May 2019 22:32:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 01 May 2019 22:32:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=+mDlg6YvPp3wklf/jmi7xhv9NAzlQtv203GvlNGu7hE=; b=X3YaRQmG
        yGfcYyrs9kPmuNJ3iPRDB196t3mez3ij3blf2Q6K06cpOJ6Yq5Zt+KlELPycbjIq
        3OGW9cWu1fhHJ1aiJuo3DOgJQNypm1J8CgWSvRO3Po2I+O3wbt+UETv8jXlLi3oC
        khDkKQpqYZeGXuBbOZLsiViQTxhD0NkiCgaXl3Y8mcjgHlXs/wzUea9Uc2PeHZGC
        b21XpIC7eifgX3n0G06yUIh4H5tagEIOmHzG6MHUtCQvacJf+4OPcxYyaueMnskX
        Un7BREBbVf7Ai1Nm/TJJI5m79KiZGb1/4SufqAC0Is9oaymMrRxBbTcEnYFl15AJ
        WvwOP6SmfcTOIQ==
X-ME-Sender: <xms:wlbKXD6SMOxfZqdQJWpq9CZa7w_eBrc1spval6EktVlytQQExYU6mA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrieekgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepfdfvohgsihhn
    ucevrdcujfgrrhguihhnghdfuceothhosghinheskhgvrhhnvghlrdhorhhgqeenucfkph
    epuddvuddrgeegrddvtdegrddvfeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehtohgs
    ihhnsehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:wlbKXN2txtaVgJNC0WiaC5rF3mSIJl4qcyp7GQuSKwANu4Rd2EjoZg>
    <xmx:wlbKXOvECGLqExFbEA_BaAoLfuex8OdCWdZWkl37VzgB3vpdslHeKw>
    <xmx:wlbKXD6w7AJkrPKy1QuPGfoLmw4sqeycBQkNgP5IsH3j4XA4prX1bg>
    <xmx:wlbKXGEXP1xKbiXjCxXA91ismY4rWiPLp1nBZdcF5rbK2bP89-a6UQ>
Received: from eros.localdomain (ppp121-44-204-235.bras1.syd2.internode.on.net [121.44.204.235])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3ED4BE40C4;
        Wed,  1 May 2019 22:32:30 -0400 (EDT)
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/5] livepatch: Fix kobject memleak
Date:   Thu,  2 May 2019 12:31:38 +1000
Message-Id: <20190502023142.20139-2-tobin@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502023142.20139-1-tobin@kernel.org>
References: <20190502023142.20139-1-tobin@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Currently error return from kobject_init_and_add() is not followed by a
call to kobject_put().  This means there is a memory leak.

Add call to kobject_put() in error path of kobject_init_and_add().

Signed-off-by: Tobin C. Harding <tobin@kernel.org>
---
 kernel/livepatch/core.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/livepatch/core.c b/kernel/livepatch/core.c
index eb0ee10a1981..98295de2172b 100644
--- a/kernel/livepatch/core.c
+++ b/kernel/livepatch/core.c
@@ -727,7 +727,9 @@ static int klp_init_func(struct klp_object *obj, struct klp_func *func)
 	ret = kobject_init_and_add(&func->kobj, &klp_ktype_func,
 				   &obj->kobj, "%s,%lu", func->old_name,
 				   func->old_sympos ? func->old_sympos : 1);
-	if (!ret)
+	if (ret)
+		kobject_put(&func->kobj);
+	else
 		func->kobj_added = true;
 
 	return ret;
@@ -803,8 +805,10 @@ static int klp_init_object(struct klp_patch *patch, struct klp_object *obj)
 	name = klp_is_module(obj) ? obj->name : "vmlinux";
 	ret = kobject_init_and_add(&obj->kobj, &klp_ktype_object,
 				   &patch->kobj, "%s", name);
-	if (ret)
+	if (ret) {
+		kobject_put(&obj->kobj);
 		return ret;
+	}
 	obj->kobj_added = true;
 
 	klp_for_each_func(obj, func) {
@@ -862,8 +866,10 @@ static int klp_init_patch(struct klp_patch *patch)
 
 	ret = kobject_init_and_add(&patch->kobj, &klp_ktype_patch,
 				   klp_root_kobj, "%s", patch->mod->name);
-	if (ret)
+	if (ret) {
+		kobject_put(&patch->kobj);
 		return ret;
+	}
 	patch->kobj_added = true;
 
 	if (patch->replace) {
-- 
2.21.0

